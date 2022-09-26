module space_out_children(v=[20,0,0]){
	for(idx=[0:$children-1]){
		translate(v*idx) children(idx);
	}
}

	space_out_children(){
		rotate([acos(1/sqrt(3)),0,0]) rotate([0,0,45])cube(size=10,center=true);
		cylinder(h=10*sqrt(3)/2,r1=10*sqrt(3/2)/2,r2=0, center=true, $fn=360);
	}