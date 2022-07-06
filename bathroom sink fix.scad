wood = 19.19+.1;
twt=1.67;
difference(){
	union(){
		translate([-twt,-twt,0])
			cube([20,wood+2*twt, 20]);
	}
	#translate([0,0,-.1])cube([20, wood, 21]);
}