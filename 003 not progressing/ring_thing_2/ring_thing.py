from solid import *
from solid.utils import *

from rocky_common import *

resolution = .3
r0 = 20
r1 = .9


def make_torus(offset, angle, number):
    base_ring = translate((offset, 0, 0))(
        rotate((angle, 0, 0))(torus(r0, r1, resolution))
    )
    part_list = []
    for i in range(number):
        part_list.append(rotate((0, 0, 360 * i / number))(base_ring))
    return union()(*part_list)


def main():
    part_list = []
    part_list.append(make_torus(0,0,1))
    part_list.append(make_torus(2,360/r0/pi, 5))
    part_list.append(make_torus(4,360/r0/pi*2, 9))
    part_list.append(make_torus(6,360/r0/pi*3, 12))
    part_list.append(make_torus(8,360/r0/pi*4, 14))
    part_list.append(make_torus(10,360/r0/pi*5, 15))
    part_list.append(make_torus(12,360/r0/pi*6, 14))
    part_list.append(make_torus(14,360/r0/pi*7, 12))
    part_list.append(make_torus(16,360/r0/pi*8, 9))
    part_list.append(make_torus(18,360/r0/pi*9, 5))
    # part_list.append(make_torus(20,360/r0/pi*10, 1))
    part = union()(*part_list)
    final_part = difference()(part, translate([0,-50,0])(cube([100,100,100], True)))
    generate_part(final_part, "ring_thing_2", resolution)


if __name__ == "__main__":
    main()
