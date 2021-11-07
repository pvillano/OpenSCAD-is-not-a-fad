prototype = true;
print = true;
$fa = .1;
$fs = $preview || !print ? 5 : 1;
use <threads.scad>


//material constants

thin_wall_thickness = .86;
ep = $preview ? .1 : .001;
//design constants

flex_outer_diameter = prototype ? 50 : 150;
h = prototype ? 50 : 15;
tooth_angle = 45;
dr = .5;
dh = dr * PI / tan(tooth_angle);

fiddy = floor(150 / dr / 4/2);
//calculated constants

//shorthand
twt = thin_wall_thickness;
twt2 = 1.67;

screw_diameter = 2 * (fiddy * dr - dh / 2)-.8-2*twt2;
//pure
//tooth angle is approximate
module spike_gear(count, height, dr, dh) {
    r = count * dr;
    function polar(i, r) = [cos(i * 180 / count), sin(i * 180 / count)] * r;
    points = [for (i = [1:count * 2]) ((i % 2) ? polar(i, r + dh / 2) : polar(i, r - dh / 2))];
    linear_extrude(height) {
        polygon(points);
    }
}


module inner_solid(cnt) {
    ScrewHole(outer_diam = screw_diameter, height = h, pitch = 2 * PI * dr, tooth_angle = tooth_angle) {
        spike_gear(cnt, h, dr, dh);
    }
    translate([0, 0, - twt2 + ep]) cylinder(h = twt2, r = cnt * dr + dh / 2 + twt);
}
module outer_flex(cnt) {
    difference() {
        cylinder(h = h, r = cnt * dr + dh / 2 + twt);
        translate([0, 0, - ep]) spike_gear(cnt, h + 2 * ep, dr, dh);
        translate([0, 0, - ep]) cylinder(h = h + ep, r1 = cnt * dr + dh / 2, r2 = cnt * dr - dh / 2);
    }
    difference(){
        ScrewThread(outer_diam = screw_diameter, height = h, pitch = 2 * PI * dr, tooth_angle = tooth_angle);
        translate([0, 0, - ep]) cylinder(h = h + 2*ep, d=screw_diameter-2*dh-2*twt2);
    }
    translate([0, 0, - twt2 + ep]) cylinder(h = twt2, r = cnt * dr + dh / 2 + twt);
}
difference() {
    inner_solid(fiddy);
    if(!print)cube(1000);
}
translate([fiddy*3,0,0]) difference() {
    outer_flex(fiddy + 2);
    if(!print)cube(1000);
}
//inner_solid();



















