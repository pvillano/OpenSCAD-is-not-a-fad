$fa = .01;
$fs = $preview ? 5 : .1;

diameter = 15;
wall_thic = 1.67;
d_outer= diameter+2*wall_thic;

command_width = 15+2;
command_height = 50+2;

module hook(h=command_width, center=true) difference(){
    cylinder(h=h, d=d_outer, center=center);
    translate([0,0,-.1]) cylinder(h=h+.2, d=diameter, center=center);
    translate([0, 0, -100/2]) cube(100);
}
//translate([(diameter+wall_thic)/2,-command_height/6,0]) cube([wall_thic,command_height,command_width], center=true);



cable_curve = 50;
cube_w = (cable_curve + command_width*2) * sqrt(2);
difference(){
    intersection(){
        union(){
            //hooks
            translate([-d_outer/2,0,cable_curve])
                hook(50, center=false);
            translate([-cable_curve,0,d_outer/2])
                rotate([-90,0,90])
                hook(50, center=false);
            //shell
            difference(){
                translate([-cube_w/2,0,cube_w/2])
                    cube(cube_w, center=true);
                translate([-cube_w/2-wall_thic,cube_w/2-diameter/2,cube_w/2+wall_thic])
                    cube(cube_w, center=true);
                dx_hole=cube_w*.193+wall_thic;
            }
            intersection(){
                rotate([0,45,0])
                    cube(d_outer*sqrt(2), center=true);
                translate([-cube_w/2,0,cube_w/2])
                    cube(cube_w, center=true);
            }
        }
        rotate([0,45,0])
            cube([cube_w,d_outer, cube_w], center=true);
    }
    #rotate([0,-45,0])
        cylinder(h=30,d=4);
}