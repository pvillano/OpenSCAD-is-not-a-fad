from math import sin

from solid import *
from solid.utils import *

from rocky_common import *

resolution = 1



def main():
    fillament_d = 1.75
    thickness = fillament_d * 3
    width = 40
    a=pi/3

    slop = .1
    cyl = cylinder(h=width, d=thickness/sin(a), segments=6, center=True)
    cyl = rotate([90,0,0])(cyl)
    card_deck = hull()(
        translate([-(width+thickness/sin(a))/2,0,0])(cyl),
        translate([(width+thickness/sin(a))/2,0,0])(cyl),
    )

    cross = union()(
        card_deck,
        rotate([0,0,90])(card_deck)
    )

    neg_cyl = cube([thickness/sin(a) + slop, width/8 + slop, thickness/sin(a) + slop], center=True)
    neg_cyl = translate([(width+thickness/sin(a))/2,0,0])(neg_cyl)

    half_pos_x_holes = union()(
        translate([0, -width / 16, 0])(neg_cyl),
        translate([0, -3 * width / 16, 0])(neg_cyl),
        translate([0, -5 * width / 16, 0])(neg_cyl),
    )
    pos_x_holes = union()(
        half_pos_x_holes,
        translate([0, width / 2, 0])(half_pos_x_holes)
    )
    x_holes = union()(
        pos_x_holes,
        rotate([0, 0, 180])(pos_x_holes)
    )

    half_pos_y_holes = union()(
        translate([0, -width / 16, 0])(neg_cyl),
        # translate([0, -3 * width / 16, 0])(neg_cyl),
        translate([0, -5 * width / 16, 0])(neg_cyl),
        translate([0, -7 * width / 16, 0])(neg_cyl),
    )
    pos_y_holes = union()(
        half_pos_y_holes,
        translate([0, width / 2, 0])(half_pos_y_holes)
    )
    y_holes = union()(
        pos_y_holes,
        rotate([0, 0, 180])(pos_y_holes)
    )

    y_holes = rotate([0,0,90])(y_holes)


    strut_hole = cylinder(h=width + slop, d=2.5, center=True, segments=8)
    strut_hole = rotate([90, 360/16, 0])(strut_hole)
    strut_hole = translate([(width+thickness/sin(a))/2,0,0])(strut_hole)
    strut_holes = union()(
        strut_hole,
        rotate([0,0,90])(strut_hole),
        rotate([0,0,180])(strut_hole),
        rotate([0,0,270])(strut_hole),
    )
    final_part = cross - x_holes - y_holes - strut_holes

    generate_part(final_part, "tile_toy", resolution)

if __name__ == '__main__':
    main()
