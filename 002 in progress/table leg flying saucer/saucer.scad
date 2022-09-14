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
shelf_d = 15;
shelf_h = .3; //provides clearance for bearings
saucer_h=8;
loose=.3;

//calculated
saucer_d = rod_diameter + bearing_od;


//generic modules
module _mirror(xyz = [0, 0, 1], duplicate = true) {
    if (duplicate) children();
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

module bearing_negative(){
    difference(){
        //bearing needs space all around
        cylinder(d=bearing_od+loose,h=bearing_width+2*shelf_h, center=true);
        //except in center
        cylinder(d=bearing_id, h=bearing_width+2*shelf_h+.2, center=true);
        //and shelves
        _mirror() _translate(bearing_width/2) cylinder(h=shelf_h+.1, d=shelf_d);
    }

}
module offset(twist) {
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
    offset() %color("red", .7)bearing(center = true);

    difference() {
        union(){

            _translate(5) dome(d=rod_diameter+8,h=rod_diameter/2-3);
            dome(d = saucer_d + shelf_d, h = 9);
            //blobs
            _mirror() offset() _translate(bearing_width/2)hull(){
                translate([-10,0,0]) cylinder(d=.4*bearing_od,h=3);
                scale([1,1,.4])sphere(d=.7*bearing_od);
            }
             rotate([0,0,360/bearing_count/2]) offset() _translate([2,0,2]) sphere(2);

            //bottom

            _mirror(duplicate=false) intersection(){
                dome(d = saucer_d + shelf_d, h = 11);
                cylinder(d=999,h=4,$fn=4);
            }
            r0 = (rod_diameter+2*loose)/2+4;
            r1 = 6;
            intersection(){
                rotate_extrude() translate([r0,0,0]) circle(r1);
                _mirror(duplicate=false) cylinder(d=saucer_d+ shelf_d,h=999);
            }
        }
        offset() bearing_negative();
    }
    %color("green", .7) cylinder(d = rod_diameter, h = rod_length, center = true);
}

difference(){
    saucer();
    cylinder(d=rod_diameter+2*loose,h=rod_length, center=true);

    //_mirror(duplicate=false) cylinder(d=999,h=999,$fn=5);
    cylinder(d=999,h=999,$fn=5);

}

//dome(100,20);