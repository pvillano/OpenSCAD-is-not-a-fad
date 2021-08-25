$fa = .01;
$fs = $preview ? 5 : .1;

diameter = 15;
wall_thic = 1.67;

command_width = 15+2;
command_height = 50+2;

difference(){
    cylinder(h=command_width, d=diameter+2*wall_thic, center=true);
    cylinder(h=command_width+1, d=diameter, center=true);
    translate([0, 0, -100/2]) cube(100);
}
translate([(diameter+wall_thic)/2,-command_height/6,0]) cube([wall_thic,command_height,command_width], center=true);
