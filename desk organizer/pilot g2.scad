use <basemodule.scad>

$fa = .01;
$fs = $preview ? 5 : .3;

d_pen=10.9;

difference() {
    base(1, 1, center = true);
    translate([0, 0, 25.4/2+.1]) rotate([180, 0, 0]) {
            for(i=[-1:1], j=[-1:1])
                translate([i*25.4*.6, j*25.4*.6, 0])
                    cylinder(d = d_pen, h = 25.4 * 3 / 4 + .1);
        }
}