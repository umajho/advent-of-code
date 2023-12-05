-module(main).
-export([main/1]).

-record(data, {
    seeds = [],
    % source category -> destination category.
    src_to_dst = #{},
    % category -> range mapping list.
    cats = #{}
}).

-record(acc, {
    data = #data{},
    % current category.
    cur_cat = nil
}).

main(_) ->
    IsPartTwo = os:getenv("PART_2") =/= false,

    Data = get_and_parse_lines(IsPartTwo),
    case IsPartTwo of
        false ->
            Locs = lists:map(
                fun(Seed) -> get_till_location("seed", Data, Seed) end,
                Data#data.seeds
            ),
            io:format("~p\n", [lists:min(Locs)]);
        true ->
            SortedRanges = sort_ranges(Data#data.seeds),
            [{N, _} | _] = get_till_location_by_ranges("seed", Data, SortedRanges),
            io:format("~p\n", [N])
    end.

get_till_location("location", _, N) ->
    N;
get_till_location(Cat, Data, N) ->
    Dst = maps:get(Cat, Data#data.src_to_dst),
    NextN = map(maps:get(Cat, Data#data.cats), N),
    get_till_location(Dst, Data, NextN).

get_till_location_by_ranges("location", _, Ranges) ->
    Ranges;
get_till_location_by_ranges(Cat, Data, Ranges) ->
    Dst = maps:get(Cat, Data#data.src_to_dst),
    NextRanges = map_ranges(maps:get(Cat, Data#data.cats), Ranges),
    get_till_location_by_ranges(Dst, Data, NextRanges).

get_and_parse_lines(IsPartTwo) -> get_and_parse_lines(IsPartTwo, #acc{}).

get_and_parse_lines(IsPartTwo, Acc) ->
    case io:get_line("") of
        eof -> Acc#acc.data;
        Line -> get_and_parse_lines(IsPartTwo, parse_line(IsPartTwo, Acc, Line))
    end.

parse_line(IsPartTwo, Acc, Line) ->
    case Line of
        "\n" ->
            Acc;
        "seeds: " ++ SeedsText ->
            SeedTexts = string:split(string:trim(SeedsText), " ", all),
            SeedNums = lists:map(fun list_to_integer/1, SeedTexts),
            Seeds =
                case IsPartTwo of
                    false ->
                        SeedNums;
                    true ->
                        chunks(SeedNums)
                end,
            Data = Acc#acc.data,
            Acc#acc{data = Data#data{seeds = Seeds}};
        [Head | _] when Head >= hd("0") andalso Head =< hd("9") ->
            CurCat = Acc#acc.cur_cat,
            LineSplit = string:split(string:trim(Line), " ", all),
            [DstStart, SrcStart, Len] =
                lists:map(fun list_to_integer/1, LineSplit),
            Data = Acc#acc.data,
            Cats = Data#data.cats,
            RMList = maps:get(CurCat, Cats, {r_m_list, []}),
            NewRMList = insert_range_mapping(RMList, {SrcStart, DstStart, Len}),
            Acc#acc{
                data = Data#data{
                    cats = maps:put(CurCat, NewRMList, Cats)
                }
            };
        _ ->
            [SrcCat, Rest] = string:split(Line, "-to-"),
            [DstCat, ""] = string:split(Rest, " map:\n"),
            Data = Acc#acc.data,
            Acc#acc{
                data = Data#data{
                    src_to_dst = maps:put(SrcCat, DstCat, Data#data.src_to_dst)
                },
                cur_cat = SrcCat
            }
    end.

insert_range_mapping({r_m_list, RMList}, Tuple) ->
    {r_m_list, insert_range_mapping_internal(RMList, Tuple, [])}.

% `r_m_list` signifas “range mapping list”.
insert_range_mapping_internal([], Tuple, Visited) ->
    lists:reverse([Tuple | Visited]);
insert_range_mapping_internal(
    [Head | Tail], {SrcStart, _, _} = Tuple, Visited
) ->
    {HeadSrcStart, _, _} = Head,
    if
        SrcStart > HeadSrcStart ->
            insert_range_mapping_internal(Tail, Tuple, [Head | Visited]);
        SrcStart < HeadSrcStart ->
            lists:reverse([Head, Tuple | Visited]) ++ Tail
    end.

map({r_m_list, RMList}, N) -> map_internal(RMList, N).
map_internal([], N) ->
    N;
map_internal([{SrcStart, DstStart, Len} | Tail], N) ->
    if
        N < SrcStart -> N;
        N < SrcStart + Len -> N - SrcStart + DstStart;
        true -> map_internal(Tail, N)
    end.

chunks(L) -> chunks(L, []).
chunks([], R) -> lists:reverse(R);
chunks([A, B | T], R) -> chunks(T, [{A, B} | R]).

map_ranges({r_m_list, RMList}, Ranges) ->
    ResultRanges = map_ranges_internal(RMList, Ranges, []),
    sort_ranges(ResultRanges).
map_ranges_internal([], Ranges, NewRanges) ->
    Ranges ++ NewRanges;
map_ranges_internal(_, [], NewRanges) ->
    NewRanges;
map_ranges_internal(
    [{SrcStart, DstStart, Len} | RMListTail] = RMList,
    [{RangeStart, RangeLen} | RangesTail] = Ranges,
    NewRanges
) ->
    if
        RangeStart < SrcStart ->
            Diff = SrcStart - RangeStart,
            if
                Diff >= RangeLen ->
                    map_ranges_internal(RMList, RangesTail, NewRanges);
                true ->
                    AdjustedRange = {RangeStart + Diff, RangeLen - Diff},
                    AdjustedRanges = [AdjustedRange | RangesTail],
                    NewRange = {RangeStart, Diff},
                    NextNewRanges = [NewRange | NewRanges],
                    map_ranges_internal(RMList, AdjustedRanges, NextNewRanges)
            end;
        RangeStart >= SrcStart + Len ->
            map_ranges_internal(RMListTail, Ranges, NewRanges);
        true ->
            SrcToDst = DstStart - SrcStart,
            Diff = RangeStart + RangeLen - (SrcStart + Len),
            if
                Diff =< 0 ->
                    NewRange = {RangeStart + SrcToDst, RangeLen},
                    NextNewRanges = [NewRange | NewRanges],
                    NewRMList =
                        if
                            Diff < 0 -> RMList;
                            Diff =:= 0 -> RMListTail
                        end,
                    map_ranges_internal(NewRMList, RangesTail, NextNewRanges);
                true ->
                    NewRangeLen = RangeLen - Diff,
                    NewRange = {RangeStart + SrcToDst, NewRangeLen},
                    NextNewRanges = [NewRange | NewRanges],
                    AdjustedRange = {RangeStart + NewRangeLen, Diff},
                    AdjustedRanges = [AdjustedRange | RangesTail],
                    map_ranges_internal(
                        RMListTail, AdjustedRanges, NextNewRanges
                    )
            end
    end.

sort_ranges(Ranges) ->
    lists:sort(fun({A, _}, {B, _}) -> A =< B end, Ranges).
