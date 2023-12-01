# Day 1

<https://adventofcode.com/2023/day/1>

La lingvo, kiun mi elektis hodiaŭ, estas [J].

Mi aŭdis la koncepto “Array Programming” por jaroj, sed ni neniam havis
oportunon uzi tiajn lingvojn.

[J]: https://www.jsoftware.com/

Vidu: [turneo.md](turneo.md).

## Ruli

- parto 1: `cat input.txt | $JCONSOLE_BIN_PATH main.ijs`.
- parto 2: `cat input.txt | ./transform.zx.mjs | $JCONSOLE_BIN_PATH main.ijs`.
- ĝisdatigo 1 (2023/12/01):
  - en rust:
    - parto 1: `cat input.txt | cargo +nightly -Zscript main.rs`
    - parto 2: `cat input.txt | PART_2=1 cargo +nightly -Zscript main.rs`
