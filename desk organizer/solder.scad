
/*
	split in halves to be printed on their side and magneted together
*/

use <basemodule.scad>

$fa = .01;
$fs = $preview ? 5 : .3;

d1 = 55.5;
d2 = 19.8;
h = 28;
twt = 1.67; //thin wall thickness

meh = 20;
moh = 3;

difference() {
    union() {
        translate([0, 0, - 25.4 / 2]) base(1, 1, center = true);
        minkowski() {
            rotate([0, 90, 0])
                cylinder(d = d2, h = h, center = true);
            translate([0,0,-d2/2]) cylinder(h = meh+d2/2, d1 = 6, d2 = twt);
        }
    }
    #translate([0,0,meh])
        rotate([0, 90, 0])
        cylinder(d = d1+moh, h = h, center = true);
}

translate([h/2,0,meh])
    rotate([0,-90,0])
    cylinder(d1=d2,d2=.1,h=d2/3);

translate([-h/2,0,meh])
    rotate([0,90,0])
    cylinder(d1=d2,d2=.1,h=d2/3);