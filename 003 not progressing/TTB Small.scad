

cards_x = 2.5*25.4+1;
cards_y = 3.5*25.4+1;
cards_z=20+3;
twt = 1.67;
d_token = 30;
burrito_x = 135;
burrito_y = 120;
burrito_z = 55;
module voids(){
	translate([0,0,0])
	translate([0,0,(burrito_z+twt)/2])
		cube([burrito_x, burrito_y, burrito_z], center=true);
	translate([-(cards_x+twt)/2,0,-(cards_z+twt)/2])
		cube([cards_x, cards_y, cards_z], center=true);
	translate([(cards_x+twt)/2,0,-(cards_z+twt)/2])
		cube([cards_x, cards_y, cards_z], center=true);
}



cube([burrito_x+2*twt, burrito_y+2*twt, twt + .02], center=true);
difference(convexity=20){
	minkowski(convexity=20){
		voids();
		cube([2*twt,2*twt,.01], center=true);
	}
	minkowski(convexity=20){
		voids();
		cube([.01,.01,.02], center=true);
	}
}


translate([100,0,0]) cylinder(d=d_token,h=3);