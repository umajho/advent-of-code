import type { INPUT } from "./input";

import type { List, String, Union } from "ts-toolbelt";
import type { Add } from "ts-arithmetic";

import type { LineToCard } from "./lib";

type Lines = String.Split<INPUT, "\n">;

type Result = ReduceLinesToCardCount<Lines>;

type ReduceLinesToCardCount<
  Lines extends string[],
  Visited extends number = 0,
  ToVisit extends number[] = [1],
> = ToVisit extends
  [infer Visiting extends number, ...infer ToVisitTail extends number[]]
  ? (Lines extends [infer Head extends string, ...infer Tail extends string[]]
    ? ReduceLinesToCardCount<
      Tail,
      Add<Visited, Visiting>,
      IncNextNWithX<MatchingNumber<LineToCard<Head>>, Visiting, ToVisitTail>
    >
    : never)
  : (Lines["length"] extends 0 ? Visited
    : ReduceLinesToCardCount<Lines, Visited>);

type MatchingNumber<Card extends [number, number]> = List.Length<
  Union.ListOf<Card[0] & Card[1]>
>;

type IncNextNWithX<
  N extends number,
  X extends number,
  List extends number[],
  R extends number[] = [],
> = R["length"] extends N ? [...R, ...List]
  : IncNextNWithX_<N, X, Next<List>, R>;
type IncNextNWithX_<
  N extends number,
  X extends number,
  Next extends [number, number[]],
  R extends number[] = [],
> = IncNextNWithX<N, X, Next[1], [...R, Add<Next[0], X>]>;

type Next<List extends number[]> = List extends
  [infer Head extends number, ...infer Tail extends number[]] ? [Head, Tail]
  : [1, []];
