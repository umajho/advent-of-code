# `"Game n"` => `n`.
def extract_game_number: split(" ") | .[1] | tonumber;

# `"3 blue"` => `{ blue: 3 }`.
def extract_color_group: split(" ") | {(.[1]): (.[0] | tonumber)};

# `"3 blue, 4 red"` => `{ blue: 3, red: 4 }`.
def extract_set: 
  split(", ")
  | map(extract_color_group)
  | (reduce .[] as $in ({}; . + $in));

# (`[{ blue: 3, red: 4 }, { red: 1, green: 2, blue: 6 }, { green: 2 }]`, "red") => `[4, 1]`
def with_only($name): map(select(.[$name])) | map(.[$name]);

def with_max_of($name): with_only($name) | max;

def extract_game:
  split("; ")
  | map(extract_set)
  | {
    red: with_max_of("red"),
    green: with_max_of("green"),
    blue: with_max_of("blue")
  };

def is_ok: [.red <= 12, .green <= 13, .blue <= 14] | all;

def calculate_game_requirements:
  split(": ")
  | [
    (.[0] | extract_game_number), 
    (.[1] | extract_game)
  ];

[ inputs | calculate_game_requirements ]
  | if $ENV.PART_2 then
      map(.[1] | (.red * .green * .blue)) | add
    else
      map(select(.[1] | is_ok) | .[0]) | add
    end