d1 = 6.5+1;
d2 = 32+2;

angle = atan2(50,250);

foot_h = 17;
zip_thickness = 2;
zip_width=3;
zip_path_r = 15;

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
    difference(){
        union(){
            cylinder(d=55, h=foot_h);
        }
        translate([0,0,d2/2+foot_h-d1]) rotate([90,0,0]) ring();

        translate([0,0,foot_h]) rotate([90,0,90]) difference(){
            cube([2*zip_path_r,999,zip_width], center=true);
            cylinder(r=zip_path_r-zip_thickness, h=zip_width+2, center=true);
        }
    }
}


main();