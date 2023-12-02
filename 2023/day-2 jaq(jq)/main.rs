use std::{env, io};

fn main() {
    let is_part_2 = env::var("PART_2").is_ok();
    dbg!(&is_part_2);

    let mut sum = 0;
    for line in io::stdin().lines() {
        let line = line.expect("should be able to read a line");

        let (id_part, sets_part) = line.split_at(line.find(": ").unwrap());
        let sets_part = &sets_part[2..];

        let id: u32 = id_part.split_whitespace().last().unwrap().parse().unwrap();

        let requirements = {
            sets_part
                .split("; ")
                .map(|set| {
                    let color_groups = set.split(", ").map(|color_group| {
                        let (n, color) = color_group.split_at(color_group.find(' ').unwrap());
                        let color = &color[1..];
                        (color, n.parse().unwrap())
                    });
                    RGB::from_iter(color_groups)
                })
                .reduce(|acc, set| RGB {
                    r: acc.r.max(set.r),
                    g: acc.g.max(set.g),
                    b: acc.b.max(set.b),
                })
                .unwrap()
        };

        if !is_part_2 {
            if requirements.r <= 12 && requirements.g <= 13 && requirements.b <= 14 {
                sum += id;
            }
        } else {
            sum += requirements.r * requirements.g * requirements.b;
        }
    }

    println!("{}", sum);
}

struct RGB {
    r: u32,
    g: u32,
    b: u32,
}

impl<'a> FromIterator<(&'a str, u32)> for RGB {
    fn from_iter<T: IntoIterator<Item = (&'a str, u32)>>(iter: T) -> Self {
        let mut rgb = RGB { r: 0, g: 0, b: 0 };
        for (item, n) in iter {
            match item {
                "red" => rgb.r += n,
                "green" => rgb.g += n,
                "blue" => rgb.b += n,
                _ => unreachable!(),
            }
        }
        rgb
    }
}
