$fa = .01;
$fs = 1;

w_img=183;
w_actual = 160;
r = 7;
twt=1.67;
bh = 1.6;

module img(){
scale(w_actual/w_img)
translate([-w_img/2,-82,0])
import("kn95.png.svg");
}
difference(){
	translate([-3,0,-bh -.001]) rotate([0,0,4.6]){
		linear_extrude(200) difference(){
			offset(r=r+twt) img();
			offset(r=r) img();
		}

		linear_extrude(bh) offset(r=r+twt) img();
	}
	linear_extrude(5)hull(){
		translate([-3,0,-bh]) rotate([0,0,4.6]) offset(r=r) img();
		translate([300,0,-bh]) rotate([0,0,4.6]) offset(r=r) img();
	}
	#translate([85,8,0]) sphere(12);
}