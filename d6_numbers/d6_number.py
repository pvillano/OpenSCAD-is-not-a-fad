from solid import *
from solid.utils import *

from rocky_common import *

numbers = """
_x_ xxx xxx x_x xxx xxx xxx xxx xxx
xx_ __x __x x_x x__ x__ __x x_x x_x
_x_ xxx xxx xxx xxx xxx _x_ xxx xxx
_x_ x__ __x __x __x x_x x__ x_x __x
xxx xxx xxx __x xxx xxx x__ xxx xxx
"""
d = 16  # mm
standard_rotations = (
    lambda pip: translate((0, 0, d / 2))(rotate((0, 0, 0))(pip)),#
    lambda pip: translate((d / 2, 0, 0))(rotate((90, 0, 90))(pip)),#
    lambda pip: translate((0, d / 2, 0))(rotate((-90, 90,0))(pip)),#
    lambda pip: translate((0, -d / 2, 0))(rotate((90, -90, 0))(pip)),
    lambda pip: translate((-d / 2, 0, 0))(rotate((90, 0, -90))(pip)),
    lambda pip: translate((0, 0, -d / 2))(rotate((180, 0, 0))(pip)),#
)


def parse_numbers(numbers=numbers):
    lines = numbers.strip().split("\n")
    splitlines = [line.split(" ") for line in lines]

    numbers = []
    for num in range(6):
        col = []
        for x in range(3):
            row = []
            for y in range(5):
                row.append(splitlines[y][num][x] == "x")
            col.append(row)
        numbers.append(col)
    return numbers


def print_letter(letter):
    pixel = translate([0,0,-d/20])(cube([d / 5, d / 5, d / 10], center=True))
    items = []
    for x_idx, col in enumerate(letter):
        for y_idx, t_or_f in enumerate(col):
            if t_or_f:
                x = (x_idx - (len(letter) // 2)) * d / 5
                y = ((len(col) // 2) - y_idx) * d / 5
                items.append(translate([x,y,0])(pixel))
    return union()(items)



parsed_numbers = parse_numbers(numbers)

numbers_3d = []

for number, rotation in zip(parse_numbers(), standard_rotations):
    number = print_letter(number)
    numbers_3d.append(rotation(number))

numbers_part = union()(numbers_3d)
negative_space = difference()(cube([d,d,d], center=True), numbers_part)
generate_part(numbers_part, "d6_numbers")
generate_part(negative_space, "d6_numbers_negative")
