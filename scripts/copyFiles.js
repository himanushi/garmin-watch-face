const description =
  "Garmin の Connect IQ アプリを作成するためのプロジェクトです。";

import fs from "node:fs";
import path from "node:path";
import clipboardy from "clipboardy";

// コピペから除外するファイル又はディレクトリ
const excludeFiles = [
  "bin",
  "node_modules",
  ".git",
  ".wrangler",
  "dist",
  "drizzle",
  ".github",
  ".vscode",
  "biome.json",
  ".DS_Store",
  "Thumbs.db",
  "package-lock.json",
  "favicon.ico",
  "tsconfig.json",
  "vite.config.ts",
  "vite-env.d.ts",
  "tsconfig.node.json",
  "static",
  ".env",
  ".env.local",
  "README.md",
  ".keep",
  "wrangler.toml",
  "meta",
  ".wrangler",
  "developer_key",
];

function directoryContents(dir, depth = 0) {
  let output = "";

  const files = fs.readdirSync(dir);

  for (const file of files) {
    if (excludeFiles.includes(file)) continue;

    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);

    if (stat.isDirectory()) {
      output += `${" ".repeat(depth * 2)}Dir: ${file}\n`;
      output += directoryContents(filePath, depth + 1);
    } else {
      output += `${" ".repeat(depth * 2)}File: ${file}\n${fs.readFileSync(
        filePath,
        "utf8",
      )}\n`;
    }
  }

  return output;
}

const excludeTreeFiles = ["node_modules", ".git", "dist", ".DS_Store"];

function tree(dir, indent = 0) {
  let output = "";
  const files = fs.readdirSync(dir);

  for (const file of files) {
    if (excludeTreeFiles.includes(file)) continue;

    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);

    output += `${" ".repeat(indent * 2)}${
      stat.isDirectory() ? "Dir" : "File"
    }: ${file}\n`;

    if (stat.isDirectory()) {
      output += tree(filePath, indent + 1);
    }
  }

  return output;
}

const treeOutput = tree(process.cwd());
const contents = directoryContents(process.cwd());
const combinedOutput = `${description}\n\n${treeOutput}\n\n${contents}`;

clipboardy.writeSync(combinedOutput);
console.log("コピーしました");
