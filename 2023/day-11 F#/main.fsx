#!/usr/bin/env dotnet fsi

type Coord = (int64 * int64)

let readLine () =
    match System.Console.ReadLine() with
    | null -> None
    | line -> Some(line)

let parseLine (rowNum: int64) (line: string) : seq<Coord> =
    Seq.toList line
    |> Seq.indexed
    |> Seq.choose (function
        | (colNum, '#') -> Some((rowNum, colNum))
        | _ -> None)

let readAndParseInput () =
    let rec reduce_ (acc: seq<Coord>) rowNum =
        match readLine () with
        | None -> acc
        | Some(line) -> reduce_ (Seq.append (parseLine rowNum line) acc) (rowNum + 1L)

    reduce_ List.empty 0

let findEmptyLines (input: seq<Coord>) (extractor: Coord -> int64) =
    let totalLines = (input |> Seq.map extractor |> Seq.max) + int64 (1)
    let nonEmptyLines = Set(input |> Seq.map extractor)

    { 0L .. (totalLines - 1L) }
    |> Seq.filter (fun (r) -> not (Set.contains r nonEmptyLines))
    |> Set

let findEmptyRows (input: seq<Coord>) = findEmptyLines input (fun (r, _) -> r)
let findEmptyCols (input: seq<Coord>) = findEmptyLines input (fun (_, c) -> c)

let minExclToMaxExcl (a: int64) (b: int64) =
    { ((min a b) + 1L) .. ((max a b) - 1L) }

let calculateDistance
    (factor: int64)
    ((ar, ac): Coord)
    ((br, bc): Coord)
    (emptyRows: Set<int64>)
    (emptyCols: Set<int64>)
    =
    let expandedRows =
        Seq.length ((minExclToMaxExcl ar br) |> Seq.filter (fun r -> (Set.contains r emptyRows)))
        |> int64

    let expandedCols =
        Seq.length ((minExclToMaxExcl ac bc) |> Seq.filter (fun c -> (Set.contains c emptyCols)))
        |> int64

    (abs (ar - br))
    + (abs (ac - bc))
    + ((expandedRows + expandedCols) * (factor - 1L))

let calculateSum (factor: int64) (input: seq<Coord>) (emptyRows: Set<int64>) (emptyCols: Set<int64>) =
    let calculateSum' (one: Coord) (others: list<Coord>) =
        others
        |> Seq.map (fun other -> calculateDistance factor one other emptyRows emptyCols)
        |> Seq.sum

    let rec reduce_ (acc: int64) (input: list<Coord>) =
        match input with
        | (head :: tail) -> (reduce_ (acc + (calculateSum' head tail)) tail)
        | [] -> acc

    reduce_ 0 (Seq.toList input)

let main =
    let isPart2 = (System.Environment.GetEnvironmentVariable "PART_2" <> null)
    let factor = if not isPart2 then 2L else 1000000L

    let input = readAndParseInput ()
    let emptyRows = findEmptyRows input
    let emptyCols = findEmptyCols input
    let sum = calculateSum factor input emptyRows emptyCols

    System.Console.WriteLine $"{sum}"

main
