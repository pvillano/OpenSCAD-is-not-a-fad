
debug=false;

// non-design measurements
key_spacing = 19.05;
key_cutout_w = .551 * 25.4;

slop = .2;
wall_thicc = 1.67;
pcb_thickness = 1.62 + slop;

inner_w = 9 * key_spacing;
inner_l = 6 * key_spacing;
delta_y = 15; //bottom of pcb to edge of keycaps
solder_gap = 6.5 - pcb_thickness - pcb_thickness + .2;
inner_h = delta_y + solder_gap;
w=inner_w+2*(wall_thicc+slop);
l=inner_l+2*(wall_thicc+slop);
h=inner_h + pcb_thickness;
supp_offset = 15;
supp_width = 21 - supp_offset;

depth=wall_thicc-.45;

module img(){
	if($preview){
		scale([13426/135,402/(4-1),depth/100]) surface("metamorphosis-straightened-widecrop100.png", center = true, invert=false);
	} else {
		scale([13462/1346,402/(40-1),depth/100]) surface("metamorphosis-straightened-widecrop10-levels.png", center = true, invert=false);
	}
}

module base() difference() {
    union() {
        //basic body
        difference() {
            translate([- wall_thicc - slop, - wall_thicc - slop, - pcb_thickness])
                cube([w, l, h]);
            translate([- slop, - slop, 0])
                cube([key_spacing * 9 + 2 * slop, key_spacing * 6 + 2 * slop, inner_h + .1]);
        }
        //supports
        for (i = [0:4]) {
            translate([0, supp_offset + key_spacing * i, - pcb_thickness])
                cube([key_spacing * 9, supp_width, solder_gap + pcb_thickness]);
        }

        //brim
        if(false) for (x = [- wall_thicc - slop, key_spacing * 9 + wall_thicc + slop], y = [- wall_thicc - slop, key_spacing * 6 +
            wall_thicc + slop]) {
            translate([x, y, - pcb_thickness])
                cylinder(h = .2, d = 30);
        }
    }
        cube([8 + 2 * slop, wall_thicc + .2, pcb_thickness + solder_gap + slop]);
    //buttons hole`
    translate([inner_w - 18 + slop, - wall_thicc - slop - .1, solder_gap-slop])
        mirror([1, 0, 0])
            cube([42 + 2 * slop, wall_thicc + .2, pcb_thickness + 2*slop]);
    // daughter board
    translate([inner_w - 18 + slop, - wall_thicc - slop - .1, - pcb_thickness + .2])
        mirror([1, 0, 0])
            cube([19 + 2 * slop, 35, solder_gap + pcb_thickness + slop]);
    // reset button
    translate([inner_w - 47.3 + 7.4 + slop, - wall_thicc - slop - .1, solder_gap])
        mirror([1, 0, 0])
            cube([7.4 + 2 * slop, wall_thicc + .2, 6 + slop]);
    //logo window
    translate([inner_w / 2, inner_l / 2, - pcb_thickness - .1]) {
        cube([39+4, 6+4, 20], center = true);
    }
    //
    for (i = [0, 1, 3, 4]) {
        translate([wall_thicc, supp_offset + key_spacing * i + wall_thicc, - pcb_thickness - .1])
            cube([key_spacing * 9 - 2 * wall_thicc, supp_width - 2 * wall_thicc, solder_gap + .1]);
    }
}

difference(){
	rotate([0,0,180]) translate([wall_thicc+slop-w/2,wall_thicc+slop-l/2,pcb_thickness-h/2]) base();
	rotate([0,0,-90]){
		translate([l/2,0,0])
			rotate([90,0,-90])
			scale([h/402,h/402,1]) img();
		translate([w/2+l/2,-w/2,0])
			rotate([90,0,180])
			scale([h/402,h/402,1]) img();
		translate([w/2+l/2,w/2,0])
			rotate([90,0,0])
			scale([h/402,h/402,1]) img();
	}
}