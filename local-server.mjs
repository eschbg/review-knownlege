import { createServer } from "node:http";
import { readFile, rename, stat, writeFile } from "node:fs/promises";
import { extname, resolve, sep } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const root = fileURLToPath(new URL("./", import.meta.url));
const clientRoot = resolve(root, "dist/client");
const progressFile = resolve(root, "data/progress.json");
const emptyProgress = { selectedWeek: 0, completed: [], reviews: {}, artifacts: {} };
const mime = { ".css": "text/css; charset=utf-8", ".js": "text/javascript; charset=utf-8", ".png": "image/png", ".svg": "image/svg+xml", ".json": "application/json; charset=utf-8" };

export function isProgress(value) {
  return Boolean(
    value && typeof value === "object" &&
    Number.isInteger(value.selectedWeek) && value.selectedWeek >= 0 && value.selectedWeek < 12 &&
    Array.isArray(value.completed) && value.completed.length <= 100 && value.completed.every((item) => typeof item === "string") &&
    value.reviews && typeof value.reviews === "object" && !Array.isArray(value.reviews) &&
    value.artifacts && typeof value.artifacts === "object" && !Array.isArray(value.artifacts),
  );
}

async function readProgress() {
  try { return JSON.parse(await readFile(progressFile, "utf8")); }
  catch { return emptyProgress; }
}

async function saveProgress(value) {
  const temporary = `${progressFile}.tmp`;
  await writeFile(temporary, `${JSON.stringify(value, null, 2)}\n`, "utf8");
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
