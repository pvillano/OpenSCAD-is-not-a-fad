import random
from collections import namedtuple
from math import cos, sin

import tqdm as tqdm
from solid import *
from solid.utils import *

from rocky_common import generate_part

PHI = (1 + sqrt(5)) / 2

Point = namedtuple("Point", ["x", "y", "z"])


def distance(p1: Point, p2: Point):
    return sqrt(abs(p1.x - p2.x) ** 1 + abs(p1.y - p2.y) ** 1)


def argmin(iterable, key=None):
    pass


if __name__ == '__main__':
    random.seed("Rocky Villano 2020")
    # parameters
    num_points = 1000
    radius = 40  # mm
    spacing_factor = .7
    # calculated parameters
    height = radius / 4
    point_radius = spacing_factor * radius / sqrt(num_points)
    # dr = radius / num_points
    # dh = height / num_points

    point_list = []

    mold = 0
    for i in tqdm.tqdm(range(1, num_points)):
        r = sqrt(i) * radius / sqrt(num_points)
        h = sqrt(1 - (i / num_points) ** 4) * height
        while True:
            theta = random.uniform(0, 2 * pi)
            point = Point(r * cos(2 * pi * theta), r * sin(2 * pi * theta), h)
            nearest = min(point_list, key=lambda p: distance(p, point)) if point_list else point
            intersects_point = [distance(point,p) < 2 * point_radius for p in point_list]
            if intersects_point.count(True) < 2:
                break
        point_list.append(point)
        mold += hull()(
            translate(point)(sphere(r=point_radius)),
            translate((point.x, point.y, 0))(sphere(r=point_radius)),
            translate(nearest)(sphere(r=point_radius)),
            translate((nearest.x, nearest.y, 0))(sphere(r=point_radius)),
        )

    mold -= translate((0, 0, -radius))(cylinder(2 * radius, radius))
    generate_part(mold, "vase_mold", 1)
