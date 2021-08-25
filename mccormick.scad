$fa = .01;
$fs = $preview ? 1 : .3;

id=35;
od=45;
h=20;
cutout=.9;
chamfer=3;
slop=.1;

difference(){
    minkowski(){
        cube([od-2*chamfer,od-2*chamfer,h-2*chamfer], center=true);
        cylinder(h=2*chamfer,r=chamfer,center=true);
    }
    cylinder(h=h+.2, d=id, center=true);
    #translate([0,od/4+.1,0])
        cube([id*cutout,od/2,h+.2], center=true);
    translate([0,od/4+.1,.1])
        cube([od+.2,od/2,h/3+.2], center=true);
    difference(){
        translate([0,0,h*2/3]) minkowski(){
            cube([od-2*chamfer,od-2*chamfer,h-2*chamfer], center=true);
            cylinder(h=2*chamfer,r=chamfer+.1,center=true);
        }
        translate([0,-od/4-.1,h/3])
            cube([id*cutout-2*slop,od/2,h+.2], center=true);
    }
}