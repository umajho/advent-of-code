#!/usr/bin/env python3

import math
import os

import numpy as np


def get_inputs(is_part_2):
    times = input().split()[1:]
    distances = input().split()[1:]
    if not is_part_2:
        times = map(int, times)
        distances = map(int, distances)
        return list(zip(times, distances))
    else:
        return [[int("".join(times)), int("".join(distances))]]


def calc_ways(td):
    r"""
    ``x(T-x) > D``
    => ``-x^2 + Tx - D > 0``
    """
    [time, distance] = td
    roots = np.roots([-1, time, -distance])
    [begin, end] = sorted(roots)
    if begin == int(begin):
        begin += 1
    if end == int(end):
        end -= 1
    begin, end = int(np.ceil(begin)), int(np.floor(end))
    return end - begin + 1


def main():
    is_part_2 = os.environ.get("PART_2") != None

    inputs = get_inputs(is_part_2)
    together = math.prod(map(calc_ways, inputs))
    print(together)


if __name__ == "__main__":
    main()
