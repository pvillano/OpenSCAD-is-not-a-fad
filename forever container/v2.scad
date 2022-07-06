prototype = true;
print = true;
$fa = .1;
$fs = $preview || !print ? 5 : 1;
use <threads.scad>

ep = $preview ? .1 : .001;

h = prototype ? 15 : 15;
tooth_angle = 30;
tooth_height = 3;
dh = tooth_height;
dr = dh / PI * tan(tooth_angle);
thread_pitch = .8;
fiddy = 50;
twt = .86;
twt2 = 1.26;
starting_threads=2;

screw_diameter = 2 * (fiddy * dr - dh / 2) - .8 - 2 * twt2;
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
    ScrewHole(outer_diam = screw_diameter, height = h, pitch = thread_pitch, tooth_angle = tooth_angle) {
        spike_gear(cnt, h-starting_threads*thread_pitch, dr, dh);
        //get threads started before adding flex gear
        translate([0,0,h-starting_threads*thread_pitch]) cylinder(r=cnt*dr-dh/2,h=starting_threads*thread_pitch);
    }
    cylinder(h = twt2, r = cnt * dr - dh / 2);
}

module outer_flex(cnt) translate([0,0,twt2-ep]) {
    //flexible part
    difference() {
        cylinder(h = h, r = cnt * dr + dh / 2 + twt);
        translate([0, 0, - ep])
                spike_gear(cnt, h + 2 * ep, dr, dh);
        //don't engage at the bottom where inflexible
        translate([0, 0, - ep]) cylinder(h = h + ep, r1 = cnt * dr + dh / 2, r2 = cnt * dr - dh / 2);
    }
    //center of the container
    difference() {
        ScrewThread(outer_diam = screw_diameter, height = h, pitch = thread_pitch, tooth_angle = tooth_angle);
        translate([0, 0, - ep])
                cylinder(h = h + 2 * ep, d = screw_diameter - 2 * thread_pitch/2/tan(tooth_angle) - 2 * twt2);
    }
    //bottom
    translate([0, 0, - twt2 + ep])
            cylinder(h = twt2, r = cnt * dr + dh / 2 + twt);
}


difference() {
    inner_solid(fiddy);
    if (!print)cube(1000);
}
translate([fiddy * dr*3, 0, 0]) difference() {
    outer_flex(fiddy + 2);
    if (!print)cube(1000);
}
//inner_solid();



















