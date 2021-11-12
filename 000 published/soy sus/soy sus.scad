debug = false;

$fa = .01;
$fs = $preview || debug ? 3 : 1;


d_outer = 100;
d_inner = 60;
depth=20;

w_img = 1000;

t_min = 3;
module img(){
	if($preview || debug){
		scale([4,4,1]) surface("geekbot9999 cropped negative quarter.png", center = true);
	} else {
		scale([2,2,1]) surface("geekbot9999 cropped negative half.png", center = true);
	}
}
module dish(){
	translate([0,0,depth]) difference(){
		minkowski(){
			cylinder(d=d_inner,h=.01);
			scale([1,1,depth*2/(d_outer-d_inner)]) sphere(d=d_outer-d_inner);
		}
		minkowski(){
			cylinder(d=d_inner,h=.01);
			scale([1,1,depth*2/(d_outer-d_inner)]) sphere(d=d_outer-d_inner-2*t_min);
		}
		cylinder(d=d_outer+1,h=depth+1);
	}
	cylinder(d=d_inner,h=t_min*2, center=true);
}

module sus()
	translate([0,0,0])
	scale(d_inner/w_img)
	mirror([0,0,1])
	img();


difference(){
	dish();
	translate([0,0, t_min+.1]) scale([1,1,.3]) sus();
}