$fa = .01;
$fs = $preview ? 1 :.2;


slop = .1;
card_width = 63.09 + slop;
card_height = 88.15 + slop;

height = 121.00;
depth = 36.25;
width = 167.3;
instr_gap = 4.25;

bottom_thickness = .9; // for 3 layers at .3mm
shell_thickness = 2.01; // for 4 walls at .3mm layer height

i_width = width - 2 * shell_thickness;
i_height = height - 2 * shell_thickness;
i_depth = depth - bottom_thickness;

dx = (i_width - 2 * card_width) / 7;
dy = (i_height - card_height)/2;
dz = (i_depth - instr_gap) / 3;

difference(){
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
    
    translate([i_width/2,i_height/2,i_depth - instr_gap])
        rotate([0,0,90])
            linear_extrude(height=1.2, center=true, convexity=10)
                text(
                    "Property of Peter Villano",
                    font="Georgia:style=Bold",
                    size=6,
                    halign="center",
                    valign="center"
                );
    
}