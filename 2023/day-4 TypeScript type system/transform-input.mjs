#!/usr/bin/env node

import fs from "fs/promises";

async function main() {
  const input = await fs.readFile("/dev/stdin", "utf-8");
  const transformed = `export type INPUT = \`${input}\`;`;
  await fs.writeFile("/dev/stdout", transformed);
}

await main();
