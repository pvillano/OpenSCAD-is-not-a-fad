from math import cos, sin

from solid import *
from solid.utils import *

from rocky_common import *


def rotate_list(l):
    l.append(l.pop(0))


def rotate_around_z(p, a):
    return [
        p[0] * cos(radians(a)) - p[1] * sin(radians(a)),
        p[0] * sin(radians(a)) + p[1] * cos(radians(a)),
        p[2],
    ]


def map_point(x0y0, x0y1, x1y0, x1y1, x, y):
    x = (x * .7 + 1) / 2
    y = (y * .7 + 1) / 2
    p0 = mix(x0y0, x1y0, x)
    p1 = mix(x0y1, x1y1, x)
    p2 = mix(p0, p1, y)
    return p2


def map_to_face(point, face, points):
    args = [points[vertex] for vertex in face]
    args += point
    return map_point(*args)


def main(
        p=None,
        angle=30,
        sep=2.2):
    if p is None:
        p = [9, 0, 3]
    p2 = list(p)
    p2[2] += sep
    points = [
        [0, 0, 0],
        p,
        rotate_around_z(p, 120),
        rotate_around_z(p, 240),
        [0, 0, 2 * p[2] + sep],
        rotate_around_z(p2, angle),
        rotate_around_z(p2, 120 + angle),
        rotate_around_z(p2, 240 + angle),
    ]
    faces = [
        [0, 1, 2, 5]
    ]
    for i, p in enumerate(points):
        print(p)

    body = hull()(*[translate(p)(sphere(r=.1)) for p in points])

    middle = map_to_face((0, 0), faces[0], points)
    print(middle)
    body += color(Red)(translate(middle)(sphere(r=1)))

    generate_part(body, 'skewb', .3)


if __name__ == '__main__':
    main()
