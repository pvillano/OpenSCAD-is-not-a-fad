//constants

$fa = .01;
$fs = $preview ? 3 : 1;
todo = $preview ? 1 : undef;

//measurements
rod_diameter = 50.8;
//bearing_od = 22;
bearing_od = 24;
bearing_id = 8;
bearing_width = 7;
thread_pitch = 5;
rod_length = 600; //about 24 inches

//parameters
bearing_count = 7;
shelf_d = 11;
shelf_h = 1; //provides clearance for bearings
saucer_h=8;
loose=.3;

//calculated
saucer_d = rod_diameter + bearing_od;


//generic modules
module _mirror(xyz = [0, 0, 1], duplilcate = true) {
    if (duplilcate) children();
    mirror(xyz) children();
}

module _translate(xyz = [0, 0, 0]) {
    if (is_num(xyz)) {
        translate([0, 0, xyz]) children();
    }
    else {
        translate(xyz) children();
    }
}

module dome(d,h){
    assert(h<d/2);
    //https://www.wolframalpha.com/input?i=d%3D2*r*sin%28t%29%2C+h%3Dr%281-cos%28t%29%29+solve+for+t
    t = 2*atan2(2*h, d);
    r=(d*d+4*h*h)/(8*h);
    assert(2*r>d);
    intersection(){
        _translate(h-r) sphere(r=r, $fn=PI*d/$fs);
        cylinder(d=d, h=h);
    }
}

module bearing(od = bearing_od, id = bearing_id, width = bearing_width, center = false) {
    difference() {
        cylinder(d = od, h = width, center = center);
        translate([0, 0, (center? 0: - .1)]) cylinder(d = id, h = width + .2, center = center);
    }
}

//module bearing_negative(){
//    difference(){
//        cylinder(d=bearing_od+loose,h=bearing_width+2*shelf_h, center=true);
//        cylinder();
//    }
//
//}
module offset() {
    twist = atan2(thread_pitch, rod_diameter * PI);
    for (i = [0:bearing_count - 1]) {
        azimuth = i * 360 / bearing_count;
        rotate([0, 0, azimuth])
            translate([bearing_od / 2 + rod_diameter / 2, 0, 0])
                rotate([twist, 0, 0])
                    children();
    }
}
//bearing();
module saucer(pos = true) {
    //stubs for bearings
    offset() {
        %color("red", .7)bearing(center = true);
        if (pos) cylinder(d = bearing_id, h = bearing_width + .2, center = true);
        mirror([0, 0, 1]) translate([0, 0, bearing_width / 2]) cylinder(d = shelf_d, h = shelf_h+2*loose);
    }
    difference() {
        mirror([0, 0, 1]) cylinder(d = saucer_d + shelf_d, h = saucer_h);
        mirror([0, 0, 1]) _translate(- .1) cylinder(d = saucer_d - shelf_d, h = saucer_h+.2);
        offset() cylinder(d=bearing_od+loose,h=bearing_width+2*shelf_h+2*loose, center=true);
    }

    translate([0,0,-saucer_h]) mirror([0, 0, 1]) dome(d = saucer_d + shelf_d, h = 11);

    %color("green", .7) cylinder(d = rod_diameter, h = rod_length, center = true);
}

difference(){
    saucer();
    cylinder(d=rod_diameter+2*loose,h=rod_length, center=true);
}


//dome(100,20);