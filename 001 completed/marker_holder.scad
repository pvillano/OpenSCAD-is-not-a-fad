// design choices

$fa = .01;
$fs = $preview ? 3: 1;


num_markers = 2;
angle_from_wall = 30;
stick_out = 33;



d_marker = 18.5;
h_marker = 120.2;
d_cap_rest_hole = 14.1;
h_cap_rest_hole = 6.1;
flange_thickness = .95;
num_flanges = 8;
flange_from_center=4.5;

module marker(){
    difference(){
        cylinder(d=d_marker, h=h_marker);
        cylinder(d=d_cap_rest_hole, h=2*h_cap_rest_hole, center=true);
    }
    difference(){
        for(i = [1:num_flanges]){
            rotate([0,0,i*360/num_flanges])
                translate([0,-flange_thickness/2,0])
                    cube([d_cap_rest_hole/2, flange_thickness, h_cap_rest_hole]);
        }
        cylinder(r=flange_from_center, h=2*h_cap_rest_hole, center=true);
    }
}
difference(){
    union(){
        translate([0,0,-d_marker/2])
            rotate([180+angle_from_wall,0,0])
                translate([0,0,-stick_out])
                    marker();
        scale([1,.5,2.6]){
            sphere(d=33);
        }
    }
    translate([-500,0,-500]) cube([1000,1000,1000]);
}
