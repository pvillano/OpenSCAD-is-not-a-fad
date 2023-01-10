module emboss_slow(
	txt="",
	size=10,
	font="",
	halign="left",
	valign="baseline",
	spacing=1,
	direction="ltr",
	language="en",
	script="latin",
	thinness=.04,
	v_bit_angle=90,
	depth=1
){
	offset_r = size*thinness;
	depth2 = depth+.1;
	translate([0,0,-depth]) minkowski(){
//		cylinder(r1=0, r2=depth2/tan(90-v_bit_angle),h=depth2);
		cylinder(r1=0, r2=1,h=2);
		linear_extrude(.01) offset(r=-offset_r)
			text(txt, size=size, font=font, halign=halign, valign=valign, spacing=spacing, direction=direction, language=language, script=script);
	}
}

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

difference(){
	mirror([0,0,1]) cube([51,25,2]);
	translate([0,15,0])emboss_slow("I", v_bit_angle=90);
	emboss("YOWSA", v_bit_angle=90);
}