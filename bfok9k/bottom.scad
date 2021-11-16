// non-design measurements
key_spacing = 19.05;
key_cutout_w = .551 * 25.4;

slop = .2;
wall_thicc = 1.67;
pcb_thickness = 1.62+slop;

inner_w = 9 * key_spacing;
inner_l = 6 * key_spacing;
delta_y = 15; //bottom of pcb to edge of keycaps
solder_gap = 6.5;
inner_h = delta_y + solder_gap;

supp_offset = 15;
supp_width = 21 - 15;
difference() {
    union() {
        difference() {
            translate([- wall_thicc-slop, - wall_thicc-slop, - pcb_thickness])
                cube([key_spacing * 9 + 2 * (wall_thicc+slop), key_spacing * 6 + 2 * (wall_thicc+slop), inner_h + pcb_thickness]);
            translate([-slop, -slop, 0])
            cube([key_spacing * 9+2*slop, key_spacing * 6+2*slop, inner_h + .1]);
        }
        for (i = [0:4]) {
            translate([0, supp_offset + key_spacing * i, -pcb_thickness])
                cube([key_spacing * 9, supp_width, solder_gap+pcb_thickness]);
        }

        for(x=[- wall_thicc-slop,key_spacing*9+ wall_thicc+slop],y=[- wall_thicc-slop,key_spacing*6+ wall_thicc+slop]){
            translate([x,y,-pcb_thickness])
                cylinder(h=.2,d=30);
        }
    }
    //jack hole`
    translate([53.2 - slop, - wall_thicc - slop - .1, 0])
        cube([8 + 2 * slop, wall_thicc + .2, pcb_thickness+solder_gap+slop]);
    //buttons hole`
    translate([inner_w - 18 + slop, - wall_thicc - slop  - .1, 0])
        mirror([1, 0, 0])
            cube([43 + 2 * slop, wall_thicc + .2, solder_gap+pcb_thickness+slop]);
    // daughter board
    translate([inner_w - 18 + slop, - wall_thicc - slop  - .1, 0])
        mirror([1, 0, 0])
            cube([30 + 2 * slop,  35, solder_gap+pcb_thickness+slop]);
    //logo window
    translate([inner_w / 2, inner_l / 2, - pcb_thickness - .1]) {
        cube([key_spacing * 3, key_spacing, 20], center = true);
    }
    for (i = [0,1,3,4]) {
        translate([wall_thicc, supp_offset + key_spacing * i+wall_thicc, -pcb_thickness-.1])
            cube([key_spacing * 9-2*wall_thicc, supp_width-2*wall_thicc, solder_gap+.1]);
    }
}