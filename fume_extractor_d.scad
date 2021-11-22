$fa = .01;
$fs = $preview ? 5 : .1;

fan_xy = 120.15 + .1;
fan_z = 25.3 + .1;
//filter_xy = 120;
filter_z = 10;
screw_spacing = 104.8;
screw_d = 4.7;
hole_d = 125.5;
thickness_xy=2.41;
thickness_z=2.4;

m4_d = 3.7;
m4_l = 4.0;

o_width= thickness_xy*4+fan_xy+filter_z*2;
o_height=o_width;
overlap=5;

module base() difference(){
	//outside
	cube([o_width,o_width,o_height],center=true);
	translate([0,0,thickness_z])
		cube([fan_xy,fan_xy,o_height],center=true);
	//filter slots
	for(i=[1:4])
		rotate([0,0,90*i])
		translate([o_width/2-filter_z/2-thickness_xy,0,0])
		cube([filter_z,fan_xy,fan_xy], center=true);
	//windows xyz
	cube([fan_xy-2*overlap,o_width+.2,fan_xy-2*overlap], center=true);
	cube([o_width+.2,fan_xy-2*overlap,fan_xy-2*overlap], center=true);
	translate([0,0, -o_height/2+thickness_z/2])
		cube([fan_xy-2*overlap,fan_xy-2*overlap,thickness_z+.1], center=true);

}



module pressfit(){
	difference(){
		cube([fan_xy-.1, fan_xy-.1, thickness_z], center=true);
		cube([fan_xy-2*overlap, fan_xy-2*overlap, thickness_z+.2], center=true);
	}
}

module bottom(){
	difference(){
		translate([0,0,-fan_xy/2+overlap])
			base();
		translate([0,0,15])
			cube([o_width+.2,o_width+.2,30], center=true);
	for(i=[1:4])
		rotate([0,0,90*i])
		translate([(o_width+fan_xy)/4,(o_width+fan_xy)/4,-10])
			cylinder(h=10+.1,d=m4_d);
	}
}

module top(){ //7.4 mm tall
	difference(){
		translate([0,0,-fan_xy/2+overlap])
			base();
		translate([0,0,-o_width/2-.1])
			cube([o_width+.2,o_width+.2,o_width+.2], center=true);
		translate([0,0,o_width/2 + overlap+thickness_z])
			cube([o_width+.2,o_width+.2,o_width], center=true);
		for(i=[1:4])
			rotate([0,0,90*i])
			translate([(o_width+fan_xy)/4,(o_width+fan_xy)/4,0])
		{
				translate([0,0,-.1]) cylinder(d=m4_l,h=15);
		}
	}
}


module hood() {
	difference(){
		union(){
		translate([0,0,-thickness_z/2]) 
			cube([fan_xy+2*thickness_xy, fan_xy+2*thickness_xy, fan_z+thickness_z], center=true);
		translate([0,0,-(fan_z+thickness_z)/2]) 
			cube([o_width, o_width, thickness_z], center=true);
		}
		//space for fan
		cube([fan_xy, fan_xy, fan_z], center=true);
		//bottom air hole
		translate([0,0,-fan_z/2-thickness_z/2]) intersection(){
			cylinder(h=thickness_z+.2,d=hole_d, center=true);
			cube([fan_xy, fan_xy, thickness_z+.2], center=true);
		}
		//screw holes
		for(i=[1:4])
			rotate([0,0,90*i])
			translate([(o_width+fan_xy)/4,(o_width+fan_xy)/4,-fan_z/2])
		{
				cylinder(d=m4_l,h=5, center=true);
		}
		//cable hole
		translate([fan_xy/2-22,fan_xy/2-15,-fan_z/2-thickness_z])
			cube([4,30,4]);
	}
	scale=200/fan_xy;
	d=57;
	translate([0,0,fan_z/2]) difference(){
		linear_extrude(d,scale=(fan_xy*scale+thickness_xy*2)/(fan_xy+thickness_xy*2))
			square(fan_xy+thickness_xy*2, center=true);
		linear_extrude(d,scale=scale) square(fan_xy, center=true);
	}
}
c=-fan_z/2-thickness_z-7.4;
translate([0,0,c-1]) top();
translate([0,0,c-2]) bottom();
hood();





















