$fa = .01;
$fs = $preview ? 5 : .3;

/*customizer*/

// 1.2 works for layer height .05 .1 .15 .2 .3 .4
layer_height = 1.2;
thin_wall_thickness=.45;
layers_per_step=10;
steps=9;
width = 40;
depth=10;

/*shortcuts*/

twt=thin_wall_thickness;

/*calculated*/
step_height = layers_per_step * layer_height;

module support(){
	translate([0,0,-layer_height/2])
		difference(){
			cube([depth-2*twt,depth-2*twt,layer_height], center=true);
			cube([depth-4*twt,depth-4*twt,layer_height+.2], center=true);
			cube([twt,depth,layer_height+.2], center=true);
			cube([depth,twt,layer_height+.2], center=true);
		}
	}
module step(){
	r=(width/2);
	difference(){
		cube([width,depth,step_height-layer_height]);
		#translate([width/2,-.1,-r/sqrt(2)])
			rotate([-90,0,0])
			cylinder(r=r,h=depth+.2);
	}
}

step();