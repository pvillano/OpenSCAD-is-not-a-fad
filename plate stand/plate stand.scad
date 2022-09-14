$fa = .01;
$fs = 1;

//measurements
plate_d1 = 11 * 25.4;
plate_t1= 8; //6
plate_t2 = 30;
plate_d2 = 100;

tilt=10;
thickness=4;

module plate(){
	cylinder(h=plate_t2,d1=plate_d1, d2=plate_d2);
	cylinder(h=plate_t1,d=plate_d1);
}


//rotate([-90 - tilt,0,0]) translate([0,-plate_d1/2,0]) plate();


intersection(){
	difference(){
		rotate([-90 - tilt,0,0])
			translate([0,-plate_d1/2,-thickness])
			cylinder(d=plate_d1+2*thickness,h=plate_t1+2*thickness);
		rotate([-90 - tilt,0,0])
			translate([0,-plate_d1/2,-thickness-.1])
			cylinder(d=plate_d1-2*thickness,h=plate_t1+2*thickness+.2);
		rotate([-90 - tilt,0,0])
			translate([0,-plate_d1/2,0])
			cylinder(d=plate_d1,h=plate_t1+2*thickness+.2);
	}
	#rotate([90,0,0]) cylinder(h=30,d=plate_d1/3, center=true);
}