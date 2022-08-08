$fa =.01;
$fs =.3;

plug_d = 19.8+.1; // I think there's a slight draft angle but whatever
plug_w = 40.5+.1;
plug_h = 50.0+.1;
gap_h=23;
twt = 1.67;
magnet_d = 28.7+.1;
magnet_h = 7.0+.1;
strain_relief_d = 3.6+.1;


lip=1.5;
slope=1.5;

difference(){
	//outer shell
	hull(){
		d=plug_d+2*magnet_h;
		dx = (plug_w - d)/2 + twt;
		translate([-dx,0,0]) cylinder(d=d, h=plug_h+gap_h+twt);
		translate([ dx,0,0]) cylinder(d=d, h=plug_h+gap_h+twt);
	}
	//cord space
	hull(){
		large_d=plug_d+2*magnet_h -2*twt;
		small_d = plug_d - 2 * lip;
		dh=(large_d-small_d)/2/slope;
		large_dx = (plug_w - large_d)/2;
		small_dx = (plug_w - plug_d)/2;
		translate([-large_dx,0,plug_h+dh]) cylinder(d=large_d, h=gap_h-dh);
		translate([ large_dx,0,plug_h+dh]) cylinder(d=large_d, h=gap_h-dh);
		
		translate([-small_dx,0,plug_h-.1]) cylinder(d=small_d, h=gap_h);
		translate([ small_dx,0,plug_h-.1]) cylinder(d=small_d, h=gap_h);
	}
	//plug space
	hull(){
		dx = (plug_w - plug_d)/2;
		translate([-dx,0,-.1]) cylinder(d=plug_d, h=plug_h+.1);
		translate([ dx,0,-.1]) cylinder(d=plug_d, h=plug_h+.1);
	}
	hull(){
		translate([0,-(plug_d+magnet_h)/2,(plug_h+gap_h+twt)/2]) cylinder(d=strain_relief_d,h=plug_h/2);
		translate([0,0,(plug_h+gap_h+twt)/2]) cylinder(d=strain_relief_d,h=plug_h/2);
	}
	translate([0,0,(plug_h+gap_h+twt)/2])rotate([90,0,0]) cylinder(d=magnet_d,h=plug_d);
	
	if($preview) translate([100,0,0])cube(200,center=true);
}
