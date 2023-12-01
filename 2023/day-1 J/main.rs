use std::{env, io};

fn main() {
    let is_part_2 = env::var("PART_2").is_ok();
    dbg!(&is_part_2);

    let mut sum = 0;
    for line in io::stdin().lines() {
        let line = line.expect("should be able to read a line");
        let chars: Vec<_> = line.chars().collect();

        let (first_i, mut first) = find_number(&chars, true);
        let (last_i, mut last) = find_number(&chars, false);

        if is_part_2 {
            first = find_english_number(&line[..first_i], true).unwrap_or(first);
            last = find_english_number(&line[(last_i + 1)..], false).unwrap_or(last);
        }

        sum += (first as i32) * 10 + (last as i32);
    }

    println!("{}", sum);
}

fn find_number(chars: &[char], is_from_left: bool) -> (usize, u8) {
    let mut iter: Box<dyn Iterator<Item = (usize, &char)>> = if is_from_left {
        Box::new(chars.iter().enumerate())
    } else {
        Box::new(chars.iter().enumerate().rev())
    };

    iter.find_map(|(i, c)| c.to_string().parse::<u8>().ok().map(|c| (i, c)))
        .unwrap()
}

const ENGLISH_NUMBERS: &[&str] = &[
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
];

fn find_english_number(line: &str, is_from_left: bool) -> Option<u8> {
    let mut outermost: Option<(usize, u8)> = None;

    for (n_minus_1, word) in ENGLISH_NUMBERS.iter().enumerate() {
        let n = (n_minus_1 + 1) as u8;

        let cur_i = if is_from_left {
            line.find(word)
        } else {
            line.rfind(word)
        };
        let Some(cur_i) = cur_i else {
            continue;
        };

        outermost = match outermost {
            None => Some((cur_i, n)),
            last @ Some((last_i, ..)) => {
                if (is_from_left && cur_i < last_i) || (!is_from_left && cur_i > last_i) {
                    Some((cur_i, n))
                } else {
                    last
                }
            }
        };
    }

    outermost.map(|inner| inner.1)
}
