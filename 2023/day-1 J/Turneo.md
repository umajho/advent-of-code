# Turneo

## Legante _[Learning J]_

[Learning J]: https://www.jsoftware.com/help/learning/contents.htm

### Ch 1

- `%/2`, kiu kutime estas uzata por “modulo”, estas “divido” en J.
- ekzistas koncepto nomiĝas “monad” (“unuloka” en Esperanto) in J, sed ŝajnas ke
  tiu tute ne rilatas al “monad”s en lingvoj kiel Haskell. [^monado]

[^monado]: https://stackoverflow.com/questions/23485637/

#### Funkcioj

- `+/2`, `*/2`, `%/2`, `%/1`, `-/1`, `-/2`, `^/2`, `*:/1`, `|/2`.
- `>/2`, `=/2`, `</2`.
  - `>./1`, `>./2`, `>:/1`, `>:/2`.
- `=:/2`.
- `#/1`, `#/2`.
- `+/ 1 2 3` => `1 + 2 + 3`.
- `NB.`.

### Ch 2

- `'…'`.

#### Funkcioj

- `$/2`, `$/1` (`# $ …`), `,/2`, (`{/2`, `i./1` (`i. # …`), `i./2`), (`=/2`,
  `-:/2`), (`;/2`, `</1`, `>/1`), `":/1`.

### Ch 3

#### Funkcioj

- “verb”s (ordinaraj funkcioj).
- “operators” (funkcioj kiuj komputas funkciojn de funkcioj).
- “adverb”s (unulokaj operatoroj):
  - `(+/) 1 2 3`.
  - “commuting”: `1 (-~) 2` => `2 - 1`.
- “conjunction”s (dulokaj operatoroj):
  - “bonding”:
    - `(1 & -) 2` => `1 - 2`.
    - `(- & 1) 2` => `2 - 1`.
  - “composition”:
    - `((+/) @: (*:)) 1 2 3 4` => `+/ *: 1 2 3 4`.
    - `1 (- @: +) 2` => `-(1 + 2)`.
- “hooks”: `(f g) y` => `y f (g y)`. (`(+ *:) 10` => `10 + (*: 10)`)
- “forks”: `(f g h) y` => `(f y) g (h y)`. (`((+/) % #) 1 2 3` = `2`.)
- `,.`, `,:`.

### Ch 4

#### Funkcioj

- `:/2`:
  - `0 : 0` … `)`.
    - la unua `0` indikas “byte string”, la dua indikas “sekvaj linioj”.
  - `3 : 0` … `)`
    - `3` indikas unuloka.
    - `y` kiel la argumento.
  - `4 : 0` … `)`.
    - `4` indikas duloka.
    - `x`, `y` kiel la argumentoj.
  - `4 : '…'`.
- `!:/2` (<https://www.jsoftware.com/help/dictionary/xmain.htm>):
  - `0 !: 1`.
    - `0 !: 1 < 'path.ijs'`.
- `=.`.
- `if.` … `do.` … `else.` … `end.`.

## Sciaĵoj de aliaj ejoj

- sufikso por dosieroj: `ijs`. [^sufikso]
- ruli kiel skripto, kaj leganti `stdin`. [^ruli]
- dividi liniojn: `<;._1 LF, '…'`. [^dividi-liniojn]
- signo-al-ASCII: `3&u: '…'`. [^signo-al-ASCII]
- `i:/2`. [^cheatsheet]
- `"/2`. [^chat-gpt]

[^sufikso]: https://stackoverflow.com/a/7953354

[^ruli]: https://www.jsoftware.com/docs/help701/user/hashbang.htm

[^dividi-liniojn]: https://stackoverflow.com/a/49101145

[^cheatsheet]: https://sergeyqz.github.io/jcheatsheet/

[^signo-al-ASCII]: en la plej lasta parto de
<https://www.jsoftware.com/help/learning/27.htm>.

[^chat-gpt]: Mi demandis ChatGPT, ke kiel oni “find biggest numbers in each list
of a table”, kaj tiam serĉis la plej eblan funkcion de la ekzemplo en la
_cheatsheet_[^cheatsheet].

## Parto 2

Mi rezignis sovli la problemon sole per J. Mi skribis skripton en JavaScript
(zx) transformante la enigon, kaj tiam pasigis la eligon al la programo en J.
