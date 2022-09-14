
$fa = .1;
$fs = $preview ? 5 : 1;
use <threads.scad>

iw = 77 + 30;
ih = 37;
il = 57;
twt=1.67;
d=20;
//ScrewHole(outer_diam = d, height = 70){
//    translate([0,0,il/2]) cylinder(d=d+2*twt,h=7);
//     rotate([90,0,0])  difference() {
//        cube([iw + 2 * twt, il + 2 * twt, ih + 2 * twt], center = true);
//        translate([0, 0, twt])cube([iw, il, ih + 2 * twt], center = true);
//    }
//}

translate([-80,0,0]){
    ScrewThread(d,20);cylinder(d=d*1.5,h=3,$fn=6);
}