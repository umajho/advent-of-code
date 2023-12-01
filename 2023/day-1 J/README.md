# Day 1

<https://adventofcode.com/2023/day/1>

La lingvo, kiun mi elektis hodiaŭ, estas [J].

Mi aŭdis la koncepto “Array Programming” por jaroj, sed ni neniam havis
oportunon uzi tiajn lingvojn.

[J]: https://www.jsoftware.com/

Vidu: [turneo.md](Turneo.md).

## Ruli

- parto 1: `$JCONSOLE_BIN_PATH main.ijs < input.txt`.
- parto 2: `./transform.zx.mjs < input.txt | $JCONSOLE_BIN_PATH main.ijs`.
- ĝisdatigo 1 (2023/12/01):
  - en rust:
    - parto 1: `cargo +nightly -Zscript main.rs < input.txt`
    - parto 2: `PART_2=1 cargo +nightly -Zscript main.rs < input.txt`
- ĝisdatigo 2 (2023/12/01):
  - parto 2 en J: `PART_2=1 $JCONSOLE_BIN_PATH main.ijs < input.txt`
