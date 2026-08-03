import { createServer } from "node:http";
import { readFile, rename, stat, writeFile } from "node:fs/promises";
import { extname, resolve, sep } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const root = fileURLToPath(new URL("./", import.meta.url));
const clientRoot = resolve(root, "dist/client");
const progressFile = resolve(root, "data/review-progress.md");
const legacyProgressFile = resolve(root, "data/progress.json");
const emptyProgress = { selectedWeek: 0, completed: [], reviews: {}, artifacts: {}, mastery: {} };
const mime = { ".css": "text/css; charset=utf-8", ".js": "text/javascript; charset=utf-8", ".png": "image/png", ".svg": "image/svg+xml", ".json": "application/json; charset=utf-8" };

export function isProgress(value) {
  const mastery = value?.mastery ?? {};
  return Boolean(
    value && typeof value === "object" &&
    Number.isInteger(value.selectedWeek) && value.selectedWeek >= 0 && value.selectedWeek < 12 &&
    Array.isArray(value.completed) && value.completed.length <= 48 && value.completed.every((item) => /^w(?:[0-9]|1[01])-t[0-3]$/.test(item)) &&
    value.reviews && typeof value.reviews === "object" && !Array.isArray(value.reviews) && Object.entries(value.reviews).every(([week, review]) => /^(?:[0-9]|1[01])$/.test(week) && review && typeof review === "object" && typeof review.submission === "string" && review.submission.length <= 500_000 && ["", "0", "1", "2", "3"].includes(review.score) && typeof review.feedback === "string" && review.feedback.length <= 500_000) &&
    value.artifacts && typeof value.artifacts === "object" && !Array.isArray(value.artifacts) && Object.entries(value.artifacts).every(([name, count]) => name.length <= 100 && Number.isInteger(count) && count >= 0 && count <= 50) &&
    mastery && typeof mastery === "object" && !Array.isArray(mastery) && Object.entries(mastery).every(([id, score]) => /^w(?:[0-9]|1[01])-t[0-3]$/.test(id) && Number.isInteger(score) && score >= 0 && score <= 3),
  );
}

export function parseProgressMarkdown(markdown) {
  const match = markdown.match(/<!-- REVIEW_LAB_DATA_START -->\s*~~~json\s*([\s\S]*?)\s*~~~\s*<!-- REVIEW_LAB_DATA_END -->/);
  if (!match) throw new Error("Missing Review Lab data block");
  const value = JSON.parse(match[1]);
  if (!isProgress(value)) throw new Error("Invalid Review Lab progress");
  return { ...emptyProgress, ...value, mastery: value.mastery ?? {} };
}

export function formatProgressMarkdown(value, updatedAt = new Date().toISOString()) {
  const normalized = { ...emptyProgress, ...value, mastery: value.mastery ?? {} };
  const mastered = Object.values(normalized.mastery).filter((score) => score === 3).length;
  const passedWeeks = Object.values(normalized.reviews).filter((review) => review.score === "3").length;
  return `# Review Lab — Trạng thái học tập

> Đây là nguồn dữ liệu local của website. Khi mở dự án, UI đọc block JSON bên dưới qua \`/api/progress\`.

## Tổng quan

- Tuần hiện tại: ${normalized.selectedWeek + 1}/12
- Kỹ năng đạt 3/3: ${mastered}/48
- Tuần đạt chuẩn: ${passedWeeks}/12
- Cập nhật lần cuối: ${updatedAt}

## Dữ liệu đầy đủ

<!-- REVIEW_LAB_DATA_START -->
~~~json
${JSON.stringify(normalized, null, 2)}
~~~
<!-- REVIEW_LAB_DATA_END -->
`;
}

async function readProgress() {
  try {
    return parseProgressMarkdown(await readFile(progressFile, "utf8"));
  } catch (error) {
    if (error?.code !== "ENOENT") throw error;
    try {
      const legacy = JSON.parse(await readFile(legacyProgressFile, "utf8"));
      if (!isProgress(legacy)) throw new Error("Invalid legacy progress");
      const normalized = { ...emptyProgress, ...legacy, mastery: legacy.mastery ?? {} };
      await saveProgress(normalized);
      return normalized;
    } catch (legacyError) {
      if (legacyError?.code !== "ENOENT") throw legacyError;
      return emptyProgress;
    }
  }
}

async function saveProgress(value) {
  const temporary = `${progressFile}.tmp`;
  await writeFile(temporary, formatProgressMarkdown(value), "utf8");
  await rename(temporary, progressFile);
}

async function readBody(request) {
  const chunks = [];
  let size = 0;
  for await (const chunk of request) {
    size += chunk.length;
    if (size > 1_000_000) throw new Error("Payload too large");
    chunks.push(chunk);
  }
  return JSON.parse(Buffer.concat(chunks).toString("utf8"));
}

export async function assetResponse(request) {
  const pathname = decodeURIComponent(new URL(request.url).pathname);
  const file = resolve(clientRoot, `.${pathname}`);
  if (!file.startsWith(`${clientRoot}${sep}`)) return new Response("Not found", { status: 404 });
  try {
    if (!(await stat(file)).isFile()) throw new Error();
    return new Response(await readFile(file), { headers: { "content-type": mime[extname(file)] ?? "application/octet-stream" } });
  } catch {
    return new Response("Not found", { status: 404 });
  }
}

async function send(nodeResponse, response) {
  nodeResponse.writeHead(response.status, Object.fromEntries(response.headers));
  nodeResponse.end(Buffer.from(await response.arrayBuffer()));
}

export async function start(port = Number(process.env.PORT) || 4173) {
  const { default: worker } = await import("./dist/server/index.js");
  const server = createServer(async (request, response) => {
    try {
      const url = new URL(request.url ?? "/", `http://${request.headers.host ?? `127.0.0.1:${port}`}`);
      if (url.pathname === "/api/progress") {
        if (request.method === "GET") return send(response, Response.json(await readProgress()));
        if (request.method === "PUT") {
          const value = await readBody(request);
          if (!isProgress(value)) return send(response, Response.json({ error: "Invalid progress" }, { status: 400 }));
          await saveProgress(value);
          return send(response, Response.json({ ok: true }));
        }
        return send(response, new Response("Method not allowed", { status: 405 }));
      }

      const asset = await assetResponse(new Request(url));
      if (asset.status !== 404) return send(response, asset);

      const fetchRequest = new Request(url, { method: request.method, headers: request.headers });
      return send(response, await worker.fetch(fetchRequest, { ASSETS: { fetch: assetResponse } }, { waitUntil() {}, passThroughOnException() {} }));
    } catch (error) {
      console.error(error);
      return send(response, new Response("Internal server error", { status: 500 }));
    }
  });

  server.listen(port, "127.0.0.1", () => console.log(`Review Lab: http://127.0.0.1:${port}`));
  return server;
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) start();
