from math import cos, sin

from solid import *
from solid.utils import *

from rocky_common import generate_part, line, torus


def cyl_to_cartesian(r, theta, z):
    return r * cos(theta), r * sin(theta), z


if __name__ == '__main__':
    height = 40  # mm
    num_struts = 11  # mm
    resolution = .3  # mm
    thickness = 1.5  # mm
    twist = 4  # struts
    top_radius = height / 5
    bottom_radius = height / 3
    lattice = True

    strut_r = thickness / 2

    part = (torus(bottom_radius, strut_r, resolution)
            + translate((0, 0, height))(torus(top_radius, strut_r, resolution)))

    for i in range(num_struts):
        theta_one = i * 2 * pi / num_struts
        theta_two = (i+twist) * 2 * pi / num_struts
        start_pt = cyl_to_cartesian(top_radius, theta_one, height)
        end_pt = cyl_to_cartesian(bottom_radius, theta_two, 0)
        part += line(start_pt, end_pt, strut_r)
        if lattice:
            theta_three = (i-twist) * 2 * pi / num_struts
            end_pt = cyl_to_cartesian(bottom_radius, theta_three, 0)
            part += line(start_pt, end_pt, strut_r)

    generate_part(part, "hyperbolic_paraboloid", resolution)
