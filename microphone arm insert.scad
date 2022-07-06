debug = false;
$fa = .01;
$fs = $preview || debug ? 3 : .1;



for(i=[0:3]){
	slop=i*.05;
	id = 12.33+slop;
	od1= 15.3-slop;
	od2 = id+2*2.25;
	h1=33;
	h2= 2.00;


	translate([i*od2*1.5,0,0]) difference(){
		union(){
			cylinder(h=h1, d1=od1, d2=od1-.2);
			mirror([0,0,1]) cylinder(h=h2, d=od2);
		}
		translate([0,0,-h2-.1]) cylinder(h=h1+h2+.2,d=id);
		translate([0,0,h1-1]) for(j=[0:i])
			rotate(j*30) cube([od2,1,2]);
	}
}