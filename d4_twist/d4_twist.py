from solid import *
from solid.utils import *

from rocky_common import *


a0 = (1.0, 0.0, -sqrt(0.5))
a1 = (0.0, 1.0, sqrt(0.5))
b0 = (-1.0, 0.0, -sqrt(0.5))
b1 = (0.0, -1.0, sqrt(0.5))


def d4_twist():
    out = []
    thickness = 3
    size = 20
    minscale = 0.05
    for i in range(int(1 / minscale) + 1):
        i = i / int(1 / minscale)
        out.append(line(mix(a0, a1, i), mix(b0, b1, i), thickness / size))

    body = scale((size / 2,) * 3)(pairwise_hull(out))
    pip_r = 1.001 * thickness / size
    pip_sphere = sphere(r=pip_r)

    def pip_line(a, b):
        return line(
            mix(a, b, 1.0 * pip_r), mix(a, b, 1.5 * pip_r), r=pip_r, capped=False
        )

    pips = color("red")(
        scale((size / 2,) * 3)(
            translate(a0)(pip_sphere)
            + pip_line(b0, a0)
            + pip_line(b0, b1)
            + pip_line(b1, a1)
            + pip_line(b1, b0)
            + translate(b1)(pip_sphere)
        )
    )

    generate_part(rotate([54.75, 0, 0])(body + pips), "d4_twist", .05)
    generate_part(rotate([54.75, 0, 0])(body - pips), "d4_twist_body", .05)
    generate_part(rotate([54.75, 0, 0])(pips), "d4_twist_pips", .05)


if __name__ == "__main__":
    d4_twist()
