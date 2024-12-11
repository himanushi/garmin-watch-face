const description =
  "Garmin の Connect IQ アプリを作成するためのプロジェクトです。";

import fs from "node:fs";
import path from "node:path";
import clipboardy from "clipboardy";

// コピペから除外するファイル又はディレクトリ（正規表現対応）
const excludeFiles = [
  /^bin$/,
  /^node_modules$/,
  /^\.git$/,
  /^\.wrangler$/,
  /^dist$/,
  /^drizzle$/,
  /^\.github$/,
  /^\.vscode$/,
  /^biome\.json$/,
  /^\.DS_Store$/,
  /^Thumbs\.db$/,
  /^package-lock\.json$/,
  /^favicon\.ico$/,
  /^tsconfig\.json$/,
  /^vite\.config\.ts$/,
  /^vite-env\.d\.ts$/,
  /^tsconfig\.node\.json$/,
  /^static$/,
  /^\.env(\.local)?$/,
  /^README\.md$/,
  /^\.keep$/,
  /^wrangler\.toml$/,
  /^meta$/,
  /^developer_key$/,
  /^device$/,
  /\.png$/,
  /\.bmglyph$/,
  /\.ttf$/,
  /\.fnt$/,
];

// ファイル名が除外対象かチェックする関数
function isExcluded(file) {
  return excludeFiles.some((regex) => regex.test(file));
}

function directoryContents(dir, depth = 0) {
  let output = "";

  const files = fs.readdirSync(dir);

  for (const file of files) {
    if (isExcluded(file)) continue;

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

const excludeTreeFiles = excludeFiles; // 共通の除外リストを使用

function tree(dir, indent = 0) {
  let output = "";
  const files = fs.readdirSync(dir);

  for (const file of files) {
    if (isExcluded(file)) continue;

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
