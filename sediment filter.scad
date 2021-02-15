// for #6 filter

$fa = .01;
$fs = $preview ? 5 : 1;

//filter measurements
base = 60;
base_width = 1;
slant_height = 150; // of the "whole cone"
slant_height_paper = 105;
angle=75*2; // if the cone was unrolled
//calculations
circumference = slant_height * 2 * PI * angle / 360;
radius = circumference / (2 * PI);
//height = sqrt(slant_height^2-radius^2)*slant_height_paper/slant_height;
height=95;
echo("radius is: ", radius, "height is", height);
//the one customization parameter
thickness = 5;

module filter(){
    hull(){
        cube([base,base_width,.001], center=true);
        translate([0,0,height]) cylinder(h=.001, r=radius);
    }
}

difference(){
    union(){
        minkowski(){
            translate([0,0,-thickness-.01]) cylinder(h=thickness, r=thickness);
            filter();
        }
        cylinder(h=thickness, r=radius);
    }
    filter();
    if($preview){
        translate([0,-1000,-500]) cube(1000);
    }
    translate([0,0,-thickness*2]) cylinder(h=thickness*2,r=radius);
}