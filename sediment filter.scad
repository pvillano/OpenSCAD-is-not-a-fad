// for #6 filter

$fa = .01;
$fs = $preview ? 5 : 1;

base = 60;
base_width = 1;

slant_height = 150;
slant_height_paper = 105;
angle=75*2;
circumference = slant_height * 2 * PI * angle / 360;
radius = circumference / (2 * PI);
echo("radius is: ", radius, "height is", height);

height = sqrt(slant_height^2-radius^2)*slant_height_paper/slant_height;
difference(){
    hull(){
        translate([0,0,-1]) cylinder(h=.001, r=radius*1.5);
        translate([0,0,height]) cylinder(h=.001, r=radius);
    }
    hull(){
        cube([base,base_width,.001], center=true);
        translate([0,0,height]) cylinder(h=1, r=radius);
    }
}