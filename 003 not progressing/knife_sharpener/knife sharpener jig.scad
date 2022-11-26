$fa=.01;
$fs=.5;

bullseye_d=31.7+.1;
bullseye_h=7.1+.1;

twt=1.67;
angle=15;
offset_percent=75;

difference(){
	k=200;
	translate([0,0,-k])cylinder(h=bullseye_h+twt+k,d=bullseye_d+2*twt);
	cylinder(h=bullseye_h,d=bullseye_d);
	cylinder(h=bullseye_h+twt+.1,d=bullseye_d-2*twt);
	translate([-offset_percent/200*(bullseye_d+2*twt),0,0])
	rotate([0,90+angle,0]){
		translate([0,-999/2,0]) cube(999);
		translate([5,-999/2,-999/2]) cube(999);
	}	
	
	translate([0,0,-99]) cylinder(h=100,d=bullseye_d);
	
}