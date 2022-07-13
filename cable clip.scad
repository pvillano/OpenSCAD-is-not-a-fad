$fa = .01;
$fs = $preview ? 5 : .1;

//measurements
diameter = 15;
command_width = 15+2;
command_height = 50+2;

//design parameters
wall_thic = 1.67;
screw_holes=false;
screw_diameter=4;

difference(){
		union(){
				difference(){
						cylinder(h=command_width, d=diameter+2*wall_thic, center=true);
						cylinder(h=command_width+1, d=diameter, center=true);
						translate([0, 0, -100/2]) cube(100);
				}
				translate([(diameter+wall_thic)/2,-command_height/6,0]) cube([wall_thic,command_height,command_width], center=true);
		}
		if(screw_holes){
				for(dy=[-3/6*command_height-screw_diameter/2, command_height/6+screw_diameter/2]){
						translate([0,dy,0])
								rotate([0,90,0])
								cylinder(d=screw_diameter, h=99);
				}
		}
}

