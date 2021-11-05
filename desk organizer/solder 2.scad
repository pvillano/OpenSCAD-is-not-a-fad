
/*
	split in halves to be printed on their side and magneted together
*/

use <basemodule.scad>

$fa = .01;
$fs = $preview ? 1 : .1;

d1 = 55.5;
d2 = 19.8;
h = 28;
h_magnet=2.8+.1;
d_magnet = 8+.2;

twt = 1.67; //thin wall thickness
margin=5;
k = h/2+margin;

eff=26.67;
difference(){
	translate([0, 25.4/2, - 25.4 / 2]) base(1, .5, center = true);
	translate([0,0,eff]) //k
		rotate([90,0,0])
		cylinder(d=d1+2*margin,h=h+2*margin, center=true);
}


difference(){
	union(){
		translate([0,25.4,eff+d2/2-margin])
			rotate([90,0,0])
			cylinder(h=25.4,d=d2-2*margin);
		hull() {
			translate([0,25.4,eff+d2/2-margin])
				rotate([90,0,0])
				cylinder(h=25.4-k,d=d2-2*margin);
			translate([-25.4,k,-.1]) cube([25.4*2,25.4-k,.1]);
		}
	}
	translate([0,0,eff+d2/2-margin])
		rotate([-90,0,0])
		translate([0,0,-.1]) cylinder(h=h_magnet+.1,d=d_magnet);
}





if($preview) #translate([0,0,eff]) //k
	rotate([90,0,0])
	difference(){
		cylinder(d=d1,h=h, center=true);
		cylinder(d=d2+.2,h=h+2, center=true);
	}