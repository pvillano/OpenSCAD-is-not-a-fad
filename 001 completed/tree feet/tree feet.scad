$fa=.01;
$fs=1;


d1 = 6.5+1;
d2 = 32+2;

angle = atan2(50,250);

foot_h = 15;
zip_thickness = 1+.5;
zip_width=2.5+.5;
zip_path_d = 15;
chamfer=4;

module torus(major_r, minor_r){
    rotate_extrude() translate([major_r,0,0]) circle(r=minor_r);
}

module ring(){
    //%cylinder(d=d2,h=d1, center=true);
    torus(d2/2-d1/2, d1/2);
    cylinder(d=d2-d1,h=d1, center=true);
    rotate([90,0,-90-angle]){
        translate([d2/2-d1/2,0,0])cylinder(d=d1,h=99);
        translate([0,0,99/2]) cube([d2-d1,d1,99], center=true);
    }
}
module main(){
    foot_stick_in = .7*d1;
    difference(){
        hull(){

            cylinder(d=55, h=foot_h-chamfer);
            cylinder(d=55-2*chamfer, h=foot_h);
        }
        translate([0,0,d2/2+foot_h-foot_stick_in]) rotate([90,0,0]) ring();

        #translate([0,0,foot_h-zip_path_d/2+d1-foot_stick_in]) rotate([90,0,90]) difference(){
            cube([zip_path_d+2*zip_thickness,zip_path_d+2*zip_thickness+99,zip_width], center=true);
            cylinder(d=zip_path_d, h=zip_width+2, center=true);
        }
        translate([0,zip_path_d/2+zip_thickness,-1]) cylinder(d1=15,d2=0,h=2/3*foot_h);
    }
}


main();