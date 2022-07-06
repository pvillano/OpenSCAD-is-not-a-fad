$fa = .01;
$fs = $preview ? 5 : 1;

ThinWallThickness = 1.27;
TubeInnerDiameter = 26.3-.2;
TubeOuterDiameter = 30.7;
TubeLength = 204;
gutter = 10;
Pitch = 4;
split=true;

module split(sep=6){
	difference(){
		union(){
			translate([sep/2,0,0])
				rotate([-90,0,0])
				children();
				
			translate([-sep/2,0,0])
				rotate([-90,0,0])
				rotate([0,0,180])
				children();
		}
		translate([0,0,-9999/2])
			cube(9999,center=true);
	}	
}

split(TubeInnerDiameter+6)
	cylinder(h=TubeLength-2*gutter,d=TubeInnerDiameter);

for(i=[-1,1])
translate([i*(TubeOuterDiameter/2+6),-(TubeOuterDiameter/2+6),0]){
	difference(){
		cylinder(h=gutter+ThinWallThickness,d=TubeInnerDiameter);
		cylinder(h=gutter+ThinWallThickness+1,d=TubeInnerDiameter-2*ThinWallThickness);
	}
	cylinder(h=ThinWallThickness,d=TubeOuterDiameter);
}