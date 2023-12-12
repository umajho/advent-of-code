# Day 10

<https://adventofcode.com/2023/day/10>

La ĉefa lingvo, kiun mi elektis hodiaŭ estas Steel[^versio] (dialekto de
Scheme).

[^versio]: versio 0.5.0

Legaĵoj:

- [steel/crates/steel-core/src/primitives] kaj pli por serĉi uzeblaj funkcioj.
- [steel/docs/src/reference] por baza uzado.
- [steel/steel-examples].

[steel/crates/steel-core/src/primitives]: https://github.com/mattwparas/steel/blob/master/crates/steel-core/src/primitives
[steel/docs/src/reference]: https://github.com/mattwparas/steel/tree/master/docs/src/reference
[steel/steel-examples]: https://github.com/mattwparas/steel/tree/master/steel-examples

## Ruli

- antaŭnecesaĵo:
  - `cargo install steel-interpreter`[^antaŭnecesaĵo]
- parto 1: `steel main.scm < input.txt`
- parto 2: `PART_2=1 steel main.scm < input.txt`

[^antaŭnecesaĵo]: fakte: `git clone https://github.com/mattwparas/steel`,
`cd steel`, kaj tiam `cargo install --path .`.
