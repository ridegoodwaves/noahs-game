#!/usr/bin/env node
/**
 * Vercel build: Godot headless Web export → dist/web/
 */
const { spawnSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const root = path.join(__dirname, "..");
const outDir = path.join(root, "dist", "web");
const index = path.join(outDir, "index.html");

const shell = process.platform === "win32" ? "cmd.exe" : "bash";
const script = path.join(root, "scripts", "export-web.sh");
const args =
  process.platform === "win32"
    ? ["/c", script]
    : [script];

const r = spawnSync(shell, args, {
  stdio: "inherit",
  cwd: root,
  env: process.env,
});

if (r.status !== 0) {
  process.exit(r.status ?? 1);
}
if (!fs.existsSync(index)) {
  console.error("Missing", index);
  process.exit(1);
}
console.log("Web export OK:", index);
