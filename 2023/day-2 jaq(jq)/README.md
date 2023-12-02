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
>
> `jaq` ne subtenas `$ENV` nuntempe, do oni bezonas anstataŭigi `$ENV.PART_2` en
> la kodo kiel `true` aŭ `false` por uzi ĝin.

- parto 1: `$JQ -n --raw-input -f main.jq < input.txt`
- parto 1: `$JQ -n --raw-input -f main.jq < input.txt`
