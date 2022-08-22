$fa=.01;
$fs=.3;

pole_d = 11.5;
pole_w = 22.1+1;
bolt_d = 4.7;
bolthead_d=9.7+.3;
plasticnut_t=5.8-4.2;

block_w = 24.6;
block_l = 34;
block_t1 = 3.8;

hole_to_end=17;
hole_to_shear=15;

new_block_overlap=25.4;

loose=.3;
tight=.1;


module cyl8(h,d,center) rotate([0,0,360/16])cylinder(h=h,d=d/cos(45/2),center=center, $fn=8);

module capsule(w,d,h,center=false){
	dx= w/2-d/2;
	hull(){
		translate([-dx,0,0]) cyl8(h=h,d=d, center=center);
		translate([ dx,0,0]) cyl8(h=h,d=d, center=center);
	}
}
module pole(h=99,center=false){
	capsule(w=pole_w,d=pole_d,h=99);
}

module negative(){
	//hole for pole
	translate([0,hole_to_shear-loose,pole_d/2])
		rotate([-90,0,0])
		rotate([0,0,180])
		capsule(w=pole_w+tight,d=pole_d+tight,h=99);
	//bolt hole
	cyl8(h=99,d=bolt_d+loose, center=true);
	//countersink
	translate([0,0,pole_d+plasticnut_t]) cyl8(d=bolthead_d+loose,h=99);
}


//h = pole_d+plasticnut_t+block_t1;
new_block_h = pole_d+2*block_t1;
new_block_l = hole_to_end + hole_to_shear + new_block_overlap;
new_block_w = pole_w+2*block_t1;

mid_h = (pole_d+tight+new_block_h)/2;
mid_l = (new_block_l+new_block_l)/2;
mid_w = (pole_w+tight+new_block_w)/2;



module part_a() difference(){
	%translate([-new_block_w/2,-hole_to_end,-block_t1]) cube([new_block_w,new_block_l,new_block_h]);
	translate([0,-hole_to_end,new_block_h/2-block_t1])
		rotate([-90,0,0])
		capsule(w=new_block_w,d=new_block_h,h=new_block_l);
		
	translate([0,-hole_to_end-.1,new_block_h/2-block_t1])
		rotate([-90,0,0])
		capsule(w=mid_w,d=mid_h,h=mid_l+.2);
	
	negative();
}

module part_b() difference(){
	%translate([-mid_w/2,-hole_to_end,-block_t1/2]) cube([mid_w,mid_l,mid_h]);
	translate([0,-hole_to_end,new_block_h/2-block_t1])
		rotate([-90,0,0])
		capsule(w=mid_w,d=mid_h,h=mid_l);
		
	translate([0,-hole_to_end-.1,new_block_h/2-block_t1])
		rotate([-90,0,0])
		capsule(w=pole_w+tight,d=pole_d+tight,h=new_block_l+.2);
	
	negative();
}

translate([0,-block_t1-3,hole_to_end]) rotate([90,0,0])part_a();

translate([0,hole_to_end+3,block_t1/2]) part_b();


























