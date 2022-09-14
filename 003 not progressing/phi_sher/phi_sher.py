from collections import namedtuple
from math import cos, sin

import tqdm as tqdm
from solid import *
from solid.utils import *

from rocky_common import generate_part, phi

Point = namedtuple("Point", ["x", "y", "z"])


def distance(p1: Point, p2: Point):
    return sqrt(abs(p1.x - p2.x) ** 1 + abs(p1.y - p2.y) ** 1)


def argmin(iterable, key=None):
    pass


if __name__ == '__main__':
    # parameters
    num_points = 1000
    radius = 40  # mm
    spacing_factor = .5
    # calculated parameters
    height = 5
    point_radius = spacing_factor * radius / sqrt(num_points)

    point_list = []

    mold = 0
    for i in range(1, num_points, 3):
        r = sqrt(i) * radius / sqrt(num_points)
        h = sqrt(1 - (i / num_points) ** 4) * height
        theta = phi * 2 * pi * i
        point = Point(r * cos(2 * pi * theta), r * sin(2 * pi * theta), h)
        point_list.append(point)
    for point in point_list:
        nearest_two = sorted(point_list, key=lambda p: distance(p, point))[1:5]
        for nearest in nearest_two:
            mold += hull()(
                translate(point)(sphere(r=point_radius)),
                translate((point.x, point.y, 0))(sphere(r=point_radius)),
                translate(nearest)(sphere(r=point_radius)),
                translate((nearest.x, nearest.y, 0))(sphere(r=point_radius)),
            )
    generate_part(mold, "phi_sher", 1)
