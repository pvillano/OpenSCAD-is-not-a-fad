$fa = .01;
$fs = $preview ? 5 : .1;


w1 = 16.8;
w2 = 27.8;
l_major = 75.3;
l_minor = 65.4;
l_inner = 16.0;
h = 4.15;
dx = 44.5;

r_round = .5;
d_round = 2 * r_round;
module pos() {
    hull() {
        translate([0, (w1 - r_round) / 2, 0]) cylinder(h = h, r = r_round);
        translate([0, - (w1 - r_round) / 2, 0]) cylinder(h = h, r = r_round);
        translate([l_minor - r_round, (w1 - r_round) / 2, 0]) cylinder(h = h, r = r_round);
        translate([l_major - r_round, - (w1 - r_round) / 2, 0]) cylinder(h = h, r = r_round);
    }
    translate([dx, - w2 / 2, 0]) minkowski() {
        cube([l_inner - d_round, w2 - d_round, h - .1]);
        cylinder(h = .1, r = r_round);
    }
}

difference() {
    pos();
    translate([0, 0, - .1]) scale([0, 0, 1.1]) {

    }
}