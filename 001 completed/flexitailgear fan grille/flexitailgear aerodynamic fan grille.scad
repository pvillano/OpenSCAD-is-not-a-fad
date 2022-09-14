
$fa = .01;
$fs = .3;

od=20.2+.2;
id=16.6;
twt=.86;
h=3;

r_lip=id*.13;
difference(){
	union(){
		cylinder(h=h,d=id+r_lip*4);
		translate([0,0,h])
			rotate_extrude()
			translate([id/2+r_lip,0,0])
			circle(r=r_lip);
	}
	cylinder(h=h+.1,d=id);
	translate([0,0,-.1]) cylinder(h=h+.1,d=od);
}

translate([0,0,h+r_lip/2]){
	cube([twt,id+2*r_lip,r_lip], center=true);
	cube([id+2*r_lip,twt,r_lip], center=true);
}