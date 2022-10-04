$fa = .01;
$fs = .1;


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


module emboss(
	txt="",
	size=10,
	font="",
	halign="left",
	valign="baseline",
	spacing=1,
	direction="ltr",
	language="en",
	script="latin",
	v_bit_angle=90,
	depth=1,
	fs=.1
){
  assert(v_bit_angle > 0 && v_bit_angle < 180);
	r0 = depth/tan(90-v_bit_angle/2);
	steps=depth/fs;
	for(i=[1:steps]){
		translate([0,0,-i/steps*depth])
			linear_extrude(depth/steps+.05) offset(r=-i/steps*r0)
			text(txt, size=size, font=font, halign=halign, valign=valign, spacing=spacing, direction=direction, language=language, script=script);
	}
}

module letter(l) {
    // Use linear_extrude() to make the letters 3D objects as they
    // are only 2D shapes when only using text()
    emboss(l, size = letter_size, halign = "center", valign = "center", v_bit_angle=120, depth=letter_depth);
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