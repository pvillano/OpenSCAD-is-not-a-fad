use <threads.scad>

$fa = .01;
$fs = 1;
filter_diameter = 52;
rim_thickness = 2;
bridge_thickness=5;
inter_nostril_distance = 15;
face_width = 138;
brow_raise=5;
//module ScrewHole(outer_diam, height, position=[0,0,0], rotation=[0,0,0], pitch=0, tooth_angle=30, tolerance=0.4, tooth_height=0) {
id = filter_diameter;
od = filter_diameter + rim_thickness;
ind = inter_nostril_distance;

module true_mirror(xyz) {
    children();
    mirror(xyz) children();
}

difference() {
    union() {
        ipd_ish=(od + rim_thickness + ind) / 2;
        true_mirror([1,0,0]){
            //rims
            translate([ipd_ish, 0, 0])
                cylinder(d = od + rim_thickness, h = 2);
            //end pieces --> temples
            translate([ipd_ish, brow_raise, 0])
                linear_extrude(rim_thickness) square([face_width / 2-ipd_ish, bridge_thickness]);
        }
        //nose bridge
        difference() {
            cylinder(d = ind + 2 * (bridge_thickness+rim_thickness)/2, h = 2);
            translate([0, 0, - .01])cylinder(d = ind, h = 2.02);
            translate([0, - ind]) cube(ind * 2, center = true);
        }
    }
    true_mirror([1,0,0]){
        translate([(od + rim_thickness + ind) / 2, 0, - .01])
            ScrewHole(outer_diam = id, height = 2.02, pitch = .75);
    }
}

true_mirror([1,0,0]){
    translate([face_width/2,brow_raise,0])
        cube([rim_thickness,bridge_thickness/3,10]);
    translate([face_width/2,brow_raise+2/3*bridge_thickness,0])
        cube([rim_thickness,bridge_thickness/3,10]);
}