from solid import *
from solid.utils import *


def line(a, b, r=1.0):
    return hull()(
        translate(a)(sphere(r=r)),
        translate(b)(sphere(r=r))
    )


def mix(p1, p2, a):
    if len(p1) != len(p2):
        raise IndexError()
    return [(x * (1-a)) + (y * a) for x, y in zip(p1, p2)]


def pairwise_hull(objs):
    return sum(hull()(a,b) for a,b in zip(objs, objs[1:]))


a0 = [ 1,  0, -sqrt(.5)]
a1 = [ 0,  1,  sqrt(.5)]
b0 = [-1,  0, -sqrt(.5)]
b1 = [ 0, -1,  sqrt(.5)]

def d4_twist():
    out = []
    thickness = 6
    size = 20
    minscale = 1
    for i in range(int(size/minscale) + 1):
        i = i/int(size/minscale)
        out.append(line(mix(a0, a1, i),mix(b0, b1, i), thickness/size))

    out = scale([size/2] * 3)(pairwise_hull(out))

    scad_render_to_file(out, 'd4_twist.scad', file_header=f'$fa = .01;\n$fs = {minscale};\n')


if __name__ == '__main__':
    d4_twist()