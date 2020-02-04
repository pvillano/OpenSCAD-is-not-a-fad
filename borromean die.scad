//outside print dimension
outside_diameter = 20;

//thickness of rings
thickness = 1.2;


//default value: 1/sqrt(3)
gap = .577;

//depth of emboss
letter_depth = .5;

o = outside_diameter/2;
letter_size = outside_diameter  - 4*thickness - 2 * gap;


module letter(l) {
    // Use linear_extrude() to make the letters 3D objects as they
    // are only 2D shapes when only using text()
    linear_extrude(height = letter_depth*2, center=true) {
        text(l, size = letter_size, halign = "center", valign = "center", $fn = 16);
    }
}

module ring() {
    difference(){
        cube([
            outside_diameter,
            outside_diameter - 2 * (thickness + gap),
            outside_diameter - 4 * (thickness + gap)
        ], true);
        cube([
            outside_diameter - 2 * thickness,
            outside_diameter - 4 * thickness - 2 * gap,
            outside_diameter - 4 * thickness - 2 * gap,
        ], true);
    }
}

difference(){
    union(){
        difference() {
            rotate([00, 00, 00]) ring();
            translate([o, 0, 0]) rotate([0, 90, 0]) letter("2");
            translate([-o, 0, 0]) rotate([0, -90, 0]) letter("5");
        }
        difference() {
            rotate([90, 00, 90]) ring();
            translate([0, -o, 0]) rotate([90, 0, 0]) letter("1");
            translate([0, o, 0]) rotate([90, 0, 180]) letter("6");
        }

        difference() {
            rotate([90, 90, 00]) ring();
            translate([0, 0, o]) rotate([0, 0, 90])  letter("3");
            translate([0, 0, -o]) rotate([180, 0, -90]) letter("4");
        }
    }
    if($preview){
        translate([0,-outside_diameter,0]) cube([outside_diameter,outside_diameter,outside_diameter]);
    }
}