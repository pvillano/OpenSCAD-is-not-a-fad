from solid import *
from solid.utils import *

from rocky_common import *

resolution = 1


def main(
    n=50, r_minor=15, r_major=20,
):
    Point = sphere(r=1)
    part_list = []
    for k in range(n):
        r_minor_k = r_minor * sqrt(k / n)
        theta_k = 360*k/PHI
        point_list = []
        num_points = int(2 * pi * r_minor / resolution)
        for j in range(num_points + 1):
            theta_j = 360*j/num_points
            # the point walks along the surface of the torus
            point = Point
            point = translate((0, r_minor_k, 0))(point)
            point = rotate((0, 0, theta_j + theta_k))(point)
            point = translate((r_major, 0, 0))(point)
            point = rotate((0, theta_j, 0))(point)
            point_list.append(point)
        part_list.append(pairwise_hull(point_list))

    final_part = union()(*part_list) # - translate((-50,-50,0))(cube((100,100,100)))
    generate_part(final_part, "ring_thing_3", resolution)


if __name__ == "__main__":
    main()
