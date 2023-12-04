import type { INPUT } from "./input";

import type { List, String, Union } from "ts-toolbelt";
import type { Add } from "ts-arithmetic";

import type { LineToCard, Pow2Table } from "./lib";

type Lines = String.Split<INPUT, "\n">;

type Result = ReduceLinesToPointsSum<Lines>;

type ReduceLinesToPointsSum<Lines extends string[], Acc extends number = 0> =
  Lines extends [infer Head extends string, ...infer Tail extends string[]]
    ? ReduceLinesToPointsSum<Tail, Add<Acc, CardToPoint<LineToCard<Head>>>>
    : Acc;

type CardToPoint<Card extends [number, number]> = Pow2Table[
  List.Length<
    Union.ListOf<Card[0] & Card[1]>
  >
];
