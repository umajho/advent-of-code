# Day 2

<https://adventofcode.com/2023/day/2>

La ĉefa lingvo, kiun mi elektis hodiaŭ estas [jq]/[jaq].

Mi uzis jq pasintece, sed ki ne estas tuŝinte ĝin delonge.

Mi trovis jaq antaŭ tagoj el afiŝo sur HN[^afiŝo].

[jq]: https://jqlang.github.io/jq/
[jaq]: https://github.com/01mf02/jaq

[^afiŝo]: https://news.ycombinator.com/item?id=38461249

## Ruli

> `JQ=jq` aŭ `JQ=jaq`.

- parto 1: `$JQ -n --raw-input -f main.jq --arg PART_2 0 < input.txt`
- parto 2: `$JQ -n --raw-input -f main.jq --arg PART_2 1 < input.txt`
- ĝisdatigo 1 (2023/12/02):
  - en rust:
    - parto 1: `cargo +nightly -Zscript main.rs < input.txt`
    - parto 2: `PART_2=1 cargo +nightly -Zscript main.rs < input.txt`
