from solid import *
from solid.utils import *

from rocky_common import *


a0 = (1.0, 0.0, -sqrt(.5))
a1 = (0.0, 1.0, sqrt(.5))
b0 = (-1.0, 0.0, -sqrt(.5))
b1 = (0.0, -1.0, sqrt(.5))


def d4_twist():
    out = []
    thickness = 3
    size = 20
    minscale = .05
    for i in range(int(1 / minscale) + 1):
        i = i / int(1 / minscale)
        out.append(line(mix(a0, a1, i), mix(b0, b1, i), thickness / size))

    body = scale((size / 2,) * 3)(pairwise_hull(out))
    pip_r = 1.1 * thickness / size
    pip_sphere = sphere(r=pip_r)

    def pip_line(a, b):
        return line(mix(a, b, .5 * pip_r), mix(a, b, 1.0 * pip_r), r=pip_r, capped=False)

    pips = color('red')(scale((size / 2,) * 3)(
        translate(a0)(pip_sphere)
        + pip_line(a1, a0)
        + pip_line(a1, b1)
        + pip_line(b1, a1)
        + pip_line(b1, b0)
        + translate(b1)(pip_sphere)
    ))

    out = (body - pips) + pips

    scad_render_to_file(body + pips, 'd4_twist.scad', file_header=f'$fa = .01;\n$fs = {minscale};\n')
    scad_render_to_file(body - pips, 'd4_twist_body.scad', file_header=f'$fa = .01;\n$fs = {minscale};\n')
    scad_render_to_file(pips, 'd4_twist_pips.scad', file_header=f'$fa = .01;\n$fs = {minscale};\n')


if __name__ == '__main__':
    d4_twist()
