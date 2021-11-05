use <basemodule.scad>

$fa = .01;
$fs = $preview ? 5 : .3;

w_ruler = 25.4 + .3;
t_ruler = 25.4 / 32 + .2;
difference() {
    base(1, 1, center = true);
    translate([0, 0, 25.4/2+.1])
        rotate([180, 0, 45]) {
            hull() {
                translate([w_ruler / 2, 0, 0]) cylinder(d1 = 25.4 / 4, d2 = t_ruler, h = 25.4 * 3 / 4 + .1);
                translate([- w_ruler / 2, 0, 0]) cylinder(d1 = 25.4 / 4, d2 = t_ruler, h = 25.4 * 3 / 4 + .1);
            }
            hull() {
                translate([w_ruler / 2, 0, 0]) cylinder(d1 = 25.4 / 2, d2 = t_ruler, h = 25.4 / 4 + .1);
                translate([- w_ruler / 2, 0, 0]) cylinder(d1 = 25.4 / 2, d2 = t_ruler, h = 25.4/ 4 + .1);
            }
        }
}