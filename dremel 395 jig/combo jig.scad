use <threads.scad>

//constants
$fa = .01;
$fs = $preview ? 3 : 1;
inch = 25.4;

//measurements
body_d = 46.3;//ste perimeters to very slow!!!
pipe_d = 1.98 * inch;
thread_h = 10;
thread_d = 20;
thread_safe_space = 2;
grip_d = 46.3;

//params
ground_clearance = inch / 4;
stick_out = 1.5 * inch; // from base of bushing
base_l = 2.5 * inch;
base_t = .25 * inch;
bushing_d = 20 + 2 * 1.26;
body_blob_h = 33;
safe_base_h= (body_d-body_blob_h)/2;

//utils

module rotate_about(angle_v, location) {
    translate(- location)
        rotate(angle_v)
            translate(location)
                children();
}

module bushing() rotate([0, 0, 90])difference() {
    union() {
        cylinder(d = bushing_d, h = thread_h);
        //%cube([15, 5, 5]);
        %union() {
            cylinder(h = stick_out);
            cylinder(d = 10, h = 32);
            translate([0, 0, stick_out]) cylinder(d = inch, h = 1);
        }
    }
    ScrewHole(outer_diam = 20, pitch = 2, tolerance = 0, height = 14, position = [0, 0, - 2]);
}

module thingy() {
    translate([0, pipe_d / 2 + 5, pipe_d / 2]) difference() {
        rotate([0, 90, 0]) bushing();
        translate([- .1, - 99 / 2, 0]) cube(99);
    }
    difference() {
        union() {
            cube([base_l, pipe_d / 2 + base_t, pipe_d / 2 + base_t]);
            intersection() {
                cube([base_l, pipe_d / 2 + base_t, 2 / 3 * pipe_d + base_t]);
                translate([stick_out, 0, pipe_d / 2]) rotate([0, 90, 0]) cylinder(d = pipe_d + 2 * base_t, h = base_l);
            }

        }
        translate([- .1, 0, pipe_d / 2]) rotate([0, 90, 0]) cylinder(d = pipe_d, h = 999);
        translate([- .1, pipe_d / 2 + 5, pipe_d / 2]) rotate([0, 90, 0]) cylinder(d = bushing_d - 2, h = thread_h);
        translate([- .1, pipe_d / 2 + 5, pipe_d / 2]) rotate([0, 90, 0]) cylinder(d = thread_d - 2, h = stick_out);
        translate([stick_out, pipe_d / 2 + 5, pipe_d / 2]) rotate([0, 90, 0]) cylinder(d = inch, h = 4, center = true);
        translate([stick_out, pipe_d / 2 + 5, pipe_d / 2+inch/2]) cube([4,inch,inch], center=true);

    }
    difference(){
        translate([0,pipe_d/2-bushing_d/2+5,0]) cube([thread_h, bushing_d, pipe_d / 2]);
        translate([- .1, pipe_d / 2 + 5, pipe_d / 2]) rotate([0, 90, 0]) cylinder(d = bushing_d - 2, h = thread_h+.2);

    }
}

module dremel_flatter(){
    difference(){
        translate([0,-grip_d/2,0])cube([85,grip_d, safe_base_h]);
        translate([-.1,0,pipe_d / 2])rotate([0, 90, 0])  cylinder(d = grip_d, h = 85+.2);
    }
}

//dremel_flatter();
thingy();