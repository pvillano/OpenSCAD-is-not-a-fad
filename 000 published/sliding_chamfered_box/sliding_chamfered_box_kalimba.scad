/* Villano OpenSCAD 2021.1 */

use <sliding_chamfered_box.scad>

$fa = .01;
$fs = $preview ? 5 : 1;
//$fn=4;

Head=9;
Interior_Width=175; //[300]
Interior_Depth = 210; //[300]
Interior_Height=60; //[300]
Clearance=.2; //[0:.05:1]


Wall_Thickness=3.37;
w=Interior_Width;
d=Interior_Depth;
h=Interior_Height;
twt=Wall_Thickness;
slop=Clearance;

module carve(depth) minkowski(){
    children();
    rotate([180,0,0])
        cylinder(r=slop,h=depth);
}

module drawer2() difference(){
    
    drawer(w,d,h,twt);
    
    translate([0,0,-h/2+twt/2]) carve(4.5) {
        translate([0,152/2-4.5,0])
            rotate([0,90,0])
            cylinder(d=Head,h=(26.8-2)*2, center=true);//head
        rotate([90,0,0])
            cylinder(d=4,h=152,center=true);//stick
        cylinder(d=25,h=9,center=true); //thumb holes
    }
}

translate([0,-d/2-twt,0]) drawer(w,d,h,twt);
translate([0,d/2+twt,0]) lid(w,d,h,twt,slop);


/*intersection(){
    drawer2();
    cube([(26.8-2)*2+10,152+10,999],center=true);
}*/