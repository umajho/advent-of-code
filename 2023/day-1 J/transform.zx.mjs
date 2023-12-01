#!/usr/bin/env zx

let content = await stdin();

let map = {
  "one": 1,
  "two": 2,
  "three": 3,
  "four": 4,
  "five": 5,
  "six": 6,
  "seven": 7,
  "eight": 8,
  "nine": 9,
};

let lines = content.split("\n");

for (const [n, line] of lines.entries()) {
  let line_out = line.split("");
  for (const [word, n] of Object.entries(map)) {
    line_out[line.indexOf(word)] = `${n}`;
    line_out[line.lastIndexOf(word)] = `${n}`;
  }
  await process.stdout.write(line_out.join(""));
  if (n < lines.length - 1) {
    await process.stdout.write("\n");
  }
}
