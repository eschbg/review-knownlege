import assert from "node:assert/strict";
import { readdir } from "node:fs/promises";
import test from "node:test";
import { assetResponse, formatProgressMarkdown, isProgress, parseProgressMarkdown } from "../local-server.mjs";

async function render() {
  const workerUrl = new URL("../dist/server/index.js", import.meta.url);
  workerUrl.searchParams.set("test", `${process.pid}-${Date.now()}`);
  const { default: worker } = await import(workerUrl.href);
  return worker.fetch(new Request("http://localhost/", { headers: { accept: "text/html" } }), { ASSETS: { fetch: async () => new Response("Not found", { status: 404 }) } }, { waitUntil() {}, passThroughOnException() {} });
}

test("renders the 12-week review lab", async () => {
  const response = await render();
  const html = await response.text();
  assert.equal(response.status, 200);
  assert.match(html, /Review Lab/);
  assert.match(html, /Ôn tập có hệ thống/);
  assert.match(html, /CODEX REVIEW/);
  assert.match(html, /STUDY PACK/);
  assert.match(html, /Performance checklist/);
  assert.match(html, /Core essentials/);
  assert.match(html, /skill-row/);
  assert.match(html, /Chọn tuần 12/);
  assert.doesNotMatch(html, /codex-preview/);
});

test("accepts only valid file-backed progress", () => {
  assert.equal(isProgress({ selectedWeek: 0, completed: [], reviews: {}, artifacts: {} }), true);
  assert.equal(isProgress({ selectedWeek: 0, completed: [], reviews: {}, artifacts: {}, mastery: { "w0-t0": 2 } }), true);
  assert.equal(isProgress({ selectedWeek: 0, completed: [], reviews: {}, artifacts: {}, mastery: { "w0-t0": 4 } }), false);
  assert.equal(isProgress({ selectedWeek: 99, completed: [], reviews: {}, artifacts: {} }), false);
  assert.equal(isProgress({ selectedWeek: 0, completed: "all", reviews: {}, artifacts: {} }), false);
});

test("round-trips progress through the Markdown source of truth", () => {
  const progress = { selectedWeek: 2, completed: ["w2-t0"], reviews: {}, artifacts: { "Technical design": 1 }, mastery: { "w2-t0": 3 } };
  const markdown = formatProgressMarkdown(progress, "2026-08-03T00:00:00.000Z");
  assert.match(markdown, /# Review Lab/);
  assert.match(markdown, /1\/48/);
  assert.deepEqual(parseProgressMarkdown(markdown), progress);
  assert.throws(() => parseProgressMarkdown("# Missing data"), /Missing Review Lab data block/);
});

test("serves built styles with the correct content type", async () => {
  const cssFile = (await readdir(new URL("../dist/client/assets/", import.meta.url))).find((file) => file.endsWith(".css"));
  assert.ok(cssFile, "build must include a stylesheet");
  const response = await assetResponse(new Request(`http://localhost/assets/${cssFile}`));
  assert.equal(response.status, 200);
  assert.match(response.headers.get("content-type") ?? "", /^text\/css\b/);
});
