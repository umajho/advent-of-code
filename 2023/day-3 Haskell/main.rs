use std::{collections::HashSet, env, io};

struct Symbol {
    char: char,
    row: usize,
    col: usize,
}

#[derive(Clone, Copy, PartialEq, Eq, Hash)]
struct NumId(usize);
impl NumId {
    fn value(&self) -> usize {
        self.0
    }
}

type Lines = Vec<Line>;
type Line = Vec<Option<NumId>>;

fn main() {
    let is_part_2 = env::var("PART_2").is_ok();
    dbg!(&is_part_2);

    let mut numbers: Vec<u32> = Vec::new();
    let mut symbols: Vec<Symbol> = Vec::new();
    let mut lines_out: Lines = Vec::new();

    for (row, line) in io::stdin().lines().enumerate() {
        let line = line.expect("should be able to read a line");

        let mut line_out: Line = Vec::new();
        let mut is_last_num = false;
        for (col, char) in line.chars().enumerate() {
            let is_cur_num = char.is_ascii_digit();
            if is_cur_num {
                let cur_num = char.to_digit(10).unwrap();
                if is_last_num {
                    let last_num = numbers.last_mut().unwrap();
                    *last_num = (*last_num) * 10 + cur_num;
                } else {
                    numbers.push(cur_num);
                    is_last_num = true;
                }
                line_out.push(Some(NumId(numbers.len() - 1)))
            } else {
                is_last_num = false;
                if char != '.' {
                    symbols.push(Symbol { char, row, col })
                }
                line_out.push(None);
            }
        }

        lines_out.push(line_out);
    }

    if !is_part_2 {
        let ids = symbols
            .into_iter()
            .map(|sym| get_adjacent_num_ids(&lines_out, sym))
            .reduce(|mut acc, x| {
                acc.extend(x);
                acc
            })
            .unwrap();

        let sum: u32 = ids.into_iter().map(|id| numbers[id.value()]).sum();

        println!("{}", sum)
    } else {
        let gear_ids = symbols
            .into_iter()
            .filter(|sym| sym.char == '*')
            .map(|sym| get_adjacent_num_ids(&lines_out, sym))
            .filter(|ids| ids.len() == 2);

        let sum: u32 = gear_ids
            .map(|ids| ids.into_iter().collect::<Vec<_>>())
            .map(|ids| numbers[ids[0].value()] * numbers[ids[1].value()])
            .sum();

        println!("{}", sum)
    }
}

fn get_adjacent_num_ids(lines: &Lines, sym: Symbol) -> HashSet<NumId> {
    let Symbol { row, col, .. } = sym;

    let mut ids: HashSet<NumId> = HashSet::new();

    let row_start = if row == 0 { 0 } else { row - 1 };
    let row_end = if row == lines.len() - 1 { row } else { row + 1 };

    for row in row_start..=row_end {
        let line = &lines[row];
        let col_start = if col == 0 { 0 } else { col - 1 };
        let col_end = if col == line.len() - 1 { col } else { col + 1 };

        for col in col_start..=col_end {
            if let Some(id) = line[col] {
                ids.insert(id);
            }
        }
    }

    ids
}
