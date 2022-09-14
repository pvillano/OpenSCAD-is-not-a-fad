/*
	split in halves to be printed on their side and magneted together
*/

use <LockedForge.scad>

$fa = .01;
$fs = $preview ? 1 : .3;

d1 = 55.5;
d2 = 19.8;
h = 28;
h_magnet = 2.8 + .1;
d_magnet = 8 + .2;

twt = 1.67; //thin wall thickness
margin = 5;
k = h / 2 + margin;

eff = 26.67;
difference() {
    translate([0, 25.4 / 2, - 25.4 / 4]) cube([2 * 25.4, 25.4, 25.4 / 2], center = true);
    //base(1, .5, center = true);
    translate([0, 0, eff]) //k
        rotate([90, 0, 0])
            cylinder(d = d1 + 2 * margin, h = h + 2 * margin, center = true);
    translate([-25.4,0,-25.4/2]) top_holes(2,1, d=3.8);
}


translate([0, 25.4, eff + d2 / 2 - margin])
    rotate([90, 0, 0])
        cylinder(h = 25.4, d = d2 - 2 * margin);
hull() {
    translate([0, 25.4, eff + d2 / 2 - margin])
        rotate([90, 0, 0])
            cylinder(h = 25.4 - k, d = d2 - 2 * margin);
    translate([- 25.4, k, - .1]) cube([25.4 * 2, 25.4 - k, .1]);
}
%translate([0, 0, eff]) //k
    rotate([90, 0, 0])
        difference() {
            cylinder(d = d1, h = h, center = true);
            cylinder(d = d2 + .2, h = h + 2, center = true);
        }