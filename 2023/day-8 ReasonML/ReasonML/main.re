exception Unreachable;

module StringMap = Map.Make(String);

type instruction =
  | L
  | R;

let get_next_node = (inst, (l, r)) => inst == L ? l : r;

type input = {
  instructions: list(instruction),
  node_map: StringMap.t((string, string)),
  starting_nodes: option(list(string)),
};

let char_to_instruction =
  fun
  | 'L' => L
  | 'R' => R
  | _ => raise(Unreachable);

let read_and_parse_lines = (is_part_2: bool): input => {
  let instructions =
    read_line()  //
    |> String.to_seq
    |> List.of_seq
    |> List.map(char_to_instruction);

  if (read_line() != "") {
    raise(Unreachable);
  };

  let node_map = ref(StringMap.empty);
  let starting_nodes = ref([]);
  let should_break = ref(false);
  while (! should_break^) {
    switch (read_line()) {
    | line =>
      let src = String.sub(line, 0, 3);
      let l = String.sub(line, 7, 3);
      let r = String.sub(line, 12, 3);
      node_map := node_map^ |> StringMap.add(src, (l, r));
      if (is_part_2 && String.ends_with(src, ~suffix="A")) {
        starting_nodes := [src, ...starting_nodes^];
      };
    | exception End_of_file => should_break := true
    };
  };

  {
    instructions,
    node_map: node_map^,
    starting_nodes: !is_part_2 ? None : Some(starting_nodes^),
  };
};

let rec walk =
        (
          node_map: StringMap.t((string, string)),
          instructions: Seq.t(instruction),
          ~node: string="AAA",
          ~step: int=0,
          (),
        ) => {
  let (inst, tail) = instructions |> Seq.uncons |> Option.get;
  let step = step + 1;
  switch (node_map |> StringMap.find(node) |> get_next_node(inst)) {
  | "ZZZ" => step
  | node => walk(node_map, tail, ~node, ~step, ())
  };
};

type period = {end_intervals: list(int)};

let rec calc_period =
        (
          node_map: StringMap.t((string, string)),
          instructions: array(instruction),
          node: string,
          ~step: int=0,
          ~end_interval: int=0,
          ~end_intervals: list(int)=[],
          ~visited: Hashtbl.t((int, string), unit)=Hashtbl.create(1000),
          (),
        )
        : period => {
  let n = Int.rem(step, Array.length(instructions));
  let inst = instructions[n];
  let step = step + 1;
  let node = node_map |> StringMap.find(node) |> get_next_node(inst);
  let is_end = String.ends_with(node, ~suffix="Z");
  let (end_interval, end_intervals) =
    is_end
      ? (0, [end_interval + 1, ...end_intervals])
      : (end_interval + 1, end_intervals);

  if (Option.is_none(Hashtbl.find_opt(visited, (n, node)))) {
    Hashtbl.add(visited, (n, node), ());
    calc_period(
      node_map,
      instructions,
      node,
      ~step,
      ~end_interval,
      ~end_intervals,
      ~visited,
      (),
    );
  } else {
    {end_intervals: List.rev(end_intervals)};
  };
};

let rec gcd = (a, b) =>
  switch (a, b) {
  | (a, 0) => a
  | _ => gcd(b, Int.rem(a, b))
  };

let lcm = (a, b) => a * b / gcd(a, b);

let lcm_list =
  fun
  | [] => raise(Unreachable)
  | ([head, ...tail]: list(int)) =>
    tail |> List.fold_left((acc, x) => lcm(acc, x), head);

let main = () => {
  let is_part_2 =
    switch (Sys.getenv("PART_2")) {
    | _ => true
    | exception Not_found => false
    };

  let input = read_and_parse_lines(is_part_2);

  if (!is_part_2) {
    let instructions = Seq.cycle(List.to_seq(input.instructions));
    let steps = walk(input.node_map, instructions, ());
    print_int(steps);
  } else {
    let instructions = Array.of_list(input.instructions);
    let periodical_end_intervals =
      input.starting_nodes
      |> Option.get
      |> List.map(node => {
           calc_period(input.node_map, instructions, node, ()).end_intervals
         });
    let are_all_len_1 =
      periodical_end_intervals
      |> List.filter(is => List.length(is) != 1)
      |> List.is_empty;

    if (are_all_len_1) {
      let l = periodical_end_intervals |> List.map(List.hd);
      print_int(lcm_list(l));
    } else {
      print_endline("¯\_(ツ)_/¯");
      raise(Unreachable);
    };
  };
};

main();
