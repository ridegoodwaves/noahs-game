#!/usr/bin/env node
/**
 * Vercel build: validates static site output exists (no Godot compile here).
 */
const fs = require("fs");
const path = require("path");
const pub = path.join(__dirname, "..", "public", "index.html");
if (!fs.existsSync(pub)) {
  console.error("Missing public/index.html");
  process.exit(1);
}
console.log("Static site OK:", pub);
