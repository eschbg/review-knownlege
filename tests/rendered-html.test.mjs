import assert from "node:assert/strict";
import test from "node:test";

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
  assert.match(html, /Học ít hơn/);
  assert.match(html, /CODEX REVIEW/);
  assert.match(html, /Chọn tuần 12/);
  assert.doesNotMatch(html, /codex-preview/);
});
