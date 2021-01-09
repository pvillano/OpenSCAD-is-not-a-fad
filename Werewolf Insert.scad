$fa = .01;
$fs = $preview ? 1 :.5;

TEST = false;

slop = 1.0;
card_width = 63.09 + 2*slop;
card_height = 88.15 + 2*slop;

height = 126.00;
depth = 36.25;
width = 167.3;
instr_gap = 4.25;

bottom_thickness = 2.1; // for 14 layers at .15mm
shell_thickness = 2.54; // for 6 walls at .15mm layer height

i_width = width - 2 * shell_thickness;
i_height = height - 2 * shell_thickness;
i_depth = depth - bottom_thickness;

dx = (i_width - 2 * card_width - shell_thickness) / 4;
dy = (i_height - card_height)/2;
dz = (i_depth - instr_gap) / 3;

if(!TEST) difference(){
    translate([-shell_thickness, -shell_thickness, -bottom_thickness]) cube([width, height, depth]);
    
    for(i = [0,1,2]){
        translate([i*dx,i*dy,i*dz])
            cube([card_width, card_height, depth]);
    }
    
    translate([i_width-card_width, i_height-card_height]){
        for(i = [0,1,2]){
            translate([-i*dx,-i*dy,i*dz]) cube([card_width, card_height, depth]);
        }
    }
    
    translate([0,0,i_depth - instr_gap]) cube([i_width, i_height, i_depth]);
    
    translate([card_width/2,card_height, -.9]) cylinder(d=20,h=depth);
    translate([i_width-card_width/2,i_height-card_height, -.9]) cylinder(d=20,h=depth);
    
    translate([i_width/2,i_height/2,-bottom_thickness])
        rotate([180,0,90])
            linear_extrude(height=1.2, center=true, convexity=10)
                text(
                    "Property of Peter Villano",
                    font="Georgia:style=Bold",
                    size=6,
                    halign="center",
                    valign="center"
                );
} else difference(){
    cube([width, height, depth]);
    translate([card_height,shell_thickness/2,0]) rotate([0,0,45]) cube([card_width, card_height, depth]);
}