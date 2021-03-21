$fa = .01;
$fs = $preview ? 5 : .1;

fan_xy = 120.15 + .1;
fan_z = 25.3 + .1;
//filter_xy = 120;
filter_z = 10;
screw_spacing = 104.8;
screw_d = 4.7;
hole_d = 125.5;
thickness_xy=2.41;
thickness_z=2.4;
rotate([0,0,0]) difference(){
    cube([fan_xy+2*thickness_xy, fan_xy+2*thickness_xy, fan_z+filter_z+thickness_z], center=true);
    intersection(){
        cylinder(h=999,d=hole_d,center=true);
        cube(fan_xy, center=true);
    }
    #translate([0,0,-fan_xy/2+(fan_z+filter_z+thickness_z)/2-thickness_z]){
        cube(fan_xy, center=true);
    }
    for(i=[1,2,3,4]){
        rotate([0,0,90*i])
            translate([screw_spacing/2, screw_spacing/2, 0])
                cylinder(h=fan_z+filter_z+thickness_z, d=screw_d);
    }
}
