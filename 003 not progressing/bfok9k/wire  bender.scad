hole_spacing=6.9;
diode_width=3.2;
diode_d=1.7;
wire_d = .5;

slop=.2;
thickness=20;
l_inner=60;

difference(){
	translate([-thickness/4,0,0])
		cube([l_inner+thickness/2,hole_spacing,thickness],center=true);
	//diode
	hull(){
		cube([l_inner+.1,diode_width+slop,diode_d+slop],center=true);
		cube([l_inner+.1,diode_width+diode_d+slop,slop],center=true);
	}
	//wire
	cube([l_inner+.1,hole_spacing+.1,wire_d+slop],center=true);
}