// 在页面里执行 JS 并打印结果。
// 用法：node tools/probe.mjs <url> <表达式> [等待毫秒] [宽x高]
import { execFile, spawn } from "node:child_process";
import { mkdtempSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const EDGE = process.env.EDGE_PATH || "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe";
const [url, expression, wait = "2500", size = ""] = process.argv.slice(2);
if (!url || !expression) {
  console.error('用法: node tools/probe.mjs <url> "<表达式>" [等待毫秒]');
  process.exit(2);
}

const port = 9800 + Math.floor(Math.random() * 150);
const profile = mkdtempSync(join(tmpdir(), "r99probe-"));
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const edge = spawn(EDGE, [
  "--headless=new",
  "--disable-gpu",
  "--hide-scrollbars",
  "--no-first-run",
  "--no-default-browser-check",
  "--allow-file-access-from-files",
  `--remote-debugging-port=${port}`,
  `--user-data-dir=${profile}`,
  "about:blank",
], { stdio: "ignore" });

try {
  const base = `http://127.0.0.1:${port}`;
  let ready = false;
  for (let i = 0; i < 80 && !ready; i++) {
    try {
      ready = (await fetch(`${base}/json/version`)).ok;
    } catch {}
    if (!ready) await sleep(250);
  }
  if (!ready) throw new Error("devtools 未就绪");

  const res = await fetch(`${base}/json/new?${encodeURIComponent("about:blank")}`, { method: "PUT" });
  const t = await res.json();
  const ws = new WebSocket(t.webSocketDebuggerUrl);
  await new Promise((ok, bad) => {
    ws.onopen = ok;
    ws.onerror = bad;
  });

  let id = 0;
  const pending = new Map();
  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id && pending.has(msg.id)) {
      pending.get(msg.id)(msg.result);
      pending.delete(msg.id);
    }
  };
  const send = (method, params = {}) =>
    new Promise((ok) => {
      const mid = ++id;
      pending.set(mid, ok);
      ws.send(JSON.stringify({ id: mid, method, params }));
    });

  await send("Page.enable");
  if (size) {
    const [sw, sh] = size.split("x").map(Number);
    await send("Emulation.setDeviceMetricsOverride", { width: sw, height: sh, deviceScaleFactor: 1, mobile: false });
  }
  await send("Page.navigate", { url });
  await sleep(Number(wait));
  const out = await send("Runtime.evaluate", { expression, awaitPromise: true, returnByValue: true });
  if (out && out.exceptionDetails) {
    console.error("error:", out.exceptionDetails.text || "exception");
    process.exitCode = 1;
  } else {
    console.log(JSON.stringify(out.result && "value" in out.result ? out.result.value : out, null, 2));
  }
  ws.close();
} catch (e) {
  console.error("fail", e.message);
  process.exitCode = 1;
} finally {
  execFile("taskkill", ["/PID", String(edge.pid), "/T", "/F"], () => {});
}
