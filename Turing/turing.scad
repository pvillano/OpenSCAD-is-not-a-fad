//import("turing1.stl");

$fa=.01;
$fs=$preview ? 30 : 3;
x=4;
y=200.4;
z=271;
twt=.454;
module turing(){
    translate([0,-y/2,0])
        cube([x,y,z]);
}

module turning() rotate([0,-60,0])turing();
rotate([0,60,0]) intersection(){
    difference(){
        hull(){
            turning();
            linear_extrude(.1) projection() turning();
        }
        turning();
    }
    union(){
        translate([-z*cos(30)/2,0,0]) difference() {
                scale([1.5,1,1]) cylinder(d=y,h=z);
                translate([0,0,-.2]) scale([1.5,1,1]) cylinder(d=y-10,h=z);
                translate([0,0,.2]) scale([1.5,1,1]) cylinder(d=y-2*twt,h=z);
        }
    translate([-2.5,-y/2,0])
        cube([5,y,.6]);
        
    }
}