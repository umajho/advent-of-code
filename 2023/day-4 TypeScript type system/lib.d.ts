import type { List, String } from "ts-toolbelt";
import type { Add } from "ts-arithmetic";

export type LineToCard<Line extends string> = ExtractNumberPair<
  String.Split<Line, ": ">[1]
>;
type ExtractNumberPair<Rest extends string> = ExtractNumberPair_<
  String.Split<Rest, " | ">
>;
type ExtractNumberPair_<Rest extends string[]> = [
  List.UnionOf<List.Filter<String.Split<Rest[0], " ">, "">>,
  List.UnionOf<List.Filter<String.Split<Rest[1], " ">, "">>,
];

type Sum<Points extends number[]> = Points extends
  [infer Head extends number, ...infer Tail extends number[]]
  ? Add<Head, Sum<Tail>>
  : 0;

export type Pow2Table = BuildPow2Table<25>;
type BuildPow2Table<N extends number, R extends number[] = [0, 1]> =
  R["length"] extends N ? R : BuildPow2Table<N, [...R, Double<List.Last<R>>]>;
type Double<X extends number> = Add<X, X>;
