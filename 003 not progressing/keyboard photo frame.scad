inch = 25.4;
key_spacing = 19.05;
key_cutout_w = .551 * inch;
hole_thickness = 1.62;
hole_border = (key_spacing-key_cutout_w)/2;
key_height = 8.30;
large_cutout = key_cutout_w+2;
labrge_hole_border = (key_spacing-large_cutout)/2;

w_inner = 4*inch;
h_inner = 6 * inch;
border = 2;

module key_hole(){
	//small, through
	translate([hole_border,hole_border,-.1])
		cube([key_cutout_w, key_cutout_w, hole_thickness+.2]);
	//big, elevated
	translate([labrge_hole_border,labrge_hole_border, hole_thickness])
		cube([large_cutout, large_cutout, key_height+.1]);
}

module frame(){
	iw = ceil((w_inner+2*hole_border) /key_spacing);
	ih = ceil((h_inner+2*hole_border)/key_spacing);
	w = iw + 2 *  border;
	h = ih + 2 *  border;
	
	
	translate([w*key_spacing/2, h*key_spacing/2,0])
		% cube([w_inner,h_inner,1], center=true);
	
	difference(){
		//base
		translate([-hole_border,-hole_border,0])
			cube([w*key_spacing+2*hole_border,h*key_spacing+2*hole_border,key_height]);
		//through cutout
		translate([border*key_spacing+hole_border, border*key_spacing+hole_border, -.1])
			cube([iw*key_spacing-2*hole_border, ih*key_spacing-2*hole_border, key_height+.2]);
		//wider cutout
		translate([border*key_spacing+labrge_hole_border, border*key_spacing+labrge_hole_border,hole_thickness])
			cube([iw*key_spacing-2*labrge_hole_border, ih*key_spacing-2*labrge_hole_border, key_height+.2]);
		for(i=[0:w-1], j=[0:h-1]){
			translate([i*key_spacing,j*key_spacing,0])
				key_hole();
		}
	}
}

if(!$preview){
	mirror([0,0,1]) frame();
} else {
	frame();
}