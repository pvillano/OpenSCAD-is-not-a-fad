
use <basemodule.scad>

$fa = .01;
$fs = $preview ? 1 : .1;

twt = 1.67; //thin wall thickness

thickness_snips = 7.3 + .3;
width_snips = 23;

thickness_pliers = 6.7 + .2;
width_pliers = 22;

difference(){
	base(1, 2, center = true);
	translate([25.4/2,0,0])
		cube([thickness_snips,width_snips,26], center=true);
	translate([-25.4/2,0,-25.4/4])
		hull(){
			translate([0,(width_pliers-thickness_pliers)/2,0])
				cylinder(h=25.4,d=thickness_pliers);
			translate([0,-(width_pliers-thickness_pliers)/2,0])
				cylinder(h=25.4,d=thickness_pliers);
		}
}