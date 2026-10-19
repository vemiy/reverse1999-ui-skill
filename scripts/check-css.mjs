import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const dir = "assets";
const allowed = new Set(["0", "0 14px 0 0", "50%"]);
let failed = false;

for (const name of readdirSync(dir).filter((f) => f.endsWith(".css"))) {
  const text = readFileSync(join(dir, name), "utf8");
  const open = (text.match(/\{/g) || []).length;
  const close = (text.match(/\}/g) || []).length;
  if (open !== close) {
    console.error(`${name}: braces ${open} / ${close}`);
    failed = true;
  }
  for (const match of text.matchAll(/border-radius:\s*([^;]+);/g)) {
    const value = match[1].replace("!important", "").trim();
    if (!allowed.has(value)) {
      console.error(`${name}: unexpected border-radius ${value}`);
      failed = true;
    }
  }
}

if (failed) process.exit(1);
console.log("css ok");
