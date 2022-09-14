
$fa=.1;
$fs= $preview ? 10: 1;
d=150;
l=50;
t1=15;
//t2=2.49;
t2= 2.49/2;
roundr = 2.49/2;
a=220;

rotate([0,0,-a/2%90]) minkowski(){
	union(){
		rotate_extrude(angle=a) translate([d/2,0,0]) square([t2,t1]);
		translate([d/2,0,0]) mirror([0,1,0]) cube([t2,l,t1]);
		rotate([0,0,a]) translate([d/2,0,0])cube([t2,l,t1]);
	}
	union(){
		cylinder(d1=roundr,d2=0,h=roundr);
		mirror([0,0,1]) cylinder(d1=roundr,d2=0,h=roundr);
	}
}
