from solid import *
from solid.utils import *

from rocky_common import *


def die(d=16.0, pip_d=3.0, pip_spacing=4.0):
    pip_list = []
    standard_rotations = (
        lambda pip: translate((0, 0, d / 2))(rotate((0, 0, 0))(pip)),
        lambda pip: translate((d / 2, 0, 0))(rotate((0, 90, 0))(pip)),
        lambda pip: translate((0, d / 2, 0))(rotate((90, 0, 180))(pip)),
        lambda pip: translate((0, -d / 2, 0))(rotate((90, 0, 0))(pip)),
        lambda pip: translate((-d / 2, 0, 0))(rotate((0, 90, 180))(pip)),
        lambda pip: translate((0, 0, -d / 2))(rotate((180, 0, 0))(pip)),
    )
    for pips_on_face, rotation in zip(standard_pips, standard_rotations):
        base_pip = cylinder(r=pip_d / 2, h=pip_d)
        for pip_x, pip_y in pips_on_face:
            pip = translate((pip_x * pip_spacing, pip_y * pip_spacing, 0))(base_pip)

            pip_list.append(rotation(pip))

    pips = sum(pip_list)
    base = cube(size=d, center=True)
    return base, pips


def quadruple(obj, spacing):
    return (
            translate((-spacing, spacing, spacing))(obj)
            + translate((-spacing, -spacing, -spacing))(obj)
            + translate((spacing, spacing, -spacing))(obj)
            + translate((spacing, -spacing, spacing))(obj)
    )


def main(od=32, pip_d=3, pip_spacing=4, min_thickness=2):
    body, pips = die(d=od / 2)
    quad_bod = quadruple(body, spacing=od / 4)
    quad_bod = minkowski()(quad_bod, sphere(r=min_thickness / 2))
    line_list = []
    for dimension in range(3):
        for a, b in ((-1, -1), (-1, 1), (1, -1), (1, 1)):
            start = [a * od / 2, b * od / 2]
            end = [a * od / 2, b * od / 2]
            start.insert(dimension, -1 * od / 2)
            end.insert(dimension, 1 * od / 2)
            line_list.append(line(start, end, r=min_thickness / 2))
    lines = sum(line_list)
    final_body = quad_bod - quadruple(pips, spacing=od / 4) + lines
    final_pips = intersection()(hull()(final_body), pips)
    generate_part(final_body, 'd6_quad', .3)
    generate_part(final_body, 'd6_quad_body', .3)
    generate_part(final_pips, 'd6_quad_pips', .3)


if __name__ == '__main__':
    main()
