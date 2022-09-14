t_wood = 20.12;
width = 25.4;

thickness = 1.67;


translate([-width, 0, 0]) cube([width, thickness, width]);
difference(){
	hull(){
		translate([0, t_wood, 0]) cube([thickness, thickness, width]);
		cube([t_wood+thickness, thickness, width]);
	}
	translate([thickness,-.1,-.1]){
		cube([999,t_wood-.1,width+.2]);
	}
}