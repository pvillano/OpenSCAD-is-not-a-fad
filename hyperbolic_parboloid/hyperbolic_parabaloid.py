from math import cos, sin

from solid import *
from solid.utils import *

from rocky_common import generate_part, pairwise_hull, line


def cyl_to_cartesian(r, theta, z):
    return r * cos(theta), r * sin(theta), z


def torus(major_r, minor_r, resolution):
    # TODO: replace this with a rotate-extrude
    point = sphere(minor_r)
    num_torus_segments = int(2 * pi * max(major_r, minor_r) / resolution)
    torus_list = []
    for i in range(num_torus_segments + 1):
        theta = 2 * pi * i / num_torus_segments
        torus_list.append(translate(cyl_to_cartesian(major_r, theta, 0))(point))
    return pairwise_hull(torus_list)


if __name__ == '__main__':
    height = 30  # mm
    num_struts = 12  # mm
    resolution = 1  # mm
    thickness = 2  # mm
    twist = 5  # struts
    top_radius = height / 3
    bottom_radius = height / 2
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
