// 无头 Edge 截图。
// 用法：node tools/shot.mjs <url> <输出> [宽] [高] [滚动位置] [移动端] [js] [滚轮] [点击]
import { execFile, spawn } from "node:child_process";
import { mkdtempSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

const EDGE = process.env.EDGE_PATH || "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe";
const [url, target, w = "1440", h = "900", offsets = "0", mobile = "false", js = "", wheel = "false", click = ""] = process.argv.slice(2);
const port = 9500 + Math.floor(Math.random() * 300);
const profile = mkdtempSync(join(tmpdir(), "r99shot-"));
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
  await send("Emulation.setDeviceMetricsOverride", {
    width: Number(w),
    height: Number(h),
    deviceScaleFactor: 1,
    mobile: mobile === "true",
  });
  await send("Page.navigate", { url });
  await sleep(2600);
  await send("Runtime.evaluate", { expression: "document.fonts.ready", awaitPromise: true });
  await sleep(500);

  if (click) {
    const [cx, cy] = click.split(",").map(Number);
    for (const type of ["mousePressed", "mouseReleased"]) {
      await send("Input.dispatchMouseEvent", { type, x: cx, y: cy, button: "left", clickCount: 1 });
      await sleep(120);
    }
    await sleep(700);
  }
  if (js) {
    await send("Runtime.evaluate", { expression: js });
    await sleep(600);
  }

  const extMatch = target.match(/\.(png|jpe?g|webp)$/i);
  const ext = extMatch ? extMatch[1].toLowerCase() : "png";
  const stem = extMatch ? target.slice(0, -extMatch[0].length) : target;
  const jpeg = ext === "jpg" || ext === "jpeg";

  let prev = 0;
  for (const y of offsets.split(",")) {
    if (wheel === "true") {
      const delta = Number(y) - prev;
      prev = Number(y);
      await send("Input.dispatchMouseEvent", { type: "mouseWheel", x: 5, y: 5, deltaX: 0, deltaY: delta });
      await sleep(900);
    } else {
      await send("Runtime.evaluate", { expression: `window.scrollTo(0, ${Number(y)})` });
      await sleep(650);
    }
    const shot = await send("Page.captureScreenshot", jpeg ? { format: "jpeg", quality: 84 } : { format: "png" });
    const list = offsets.split(",");
    const out = list.length > 1 ? `${stem}-${y}.${ext}` : `${stem}.${ext}`;
    writeFileSync(out, Buffer.from(shot.data, "base64"));
    console.log("ok", out);
  }
  ws.close();
} catch (e) {
  console.error("fail", e.message);
  process.exitCode = 1;
} finally {
  execFile("taskkill", ["/PID", String(edge.pid), "/T", "/F"], () => {});
}
