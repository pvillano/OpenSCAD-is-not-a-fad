/*

* should 

*/

fancycap = false;
//todo: bonus X000 micron (X mm) filter for big chunks

$fa = .01;
$fs = 5;

//measurements
cone_folded_arc_angle = 105;
cone_slant_h = 120;
filter_slant_h = 43;

//design parameters
thin_wall_thickness = 2;
flow_gap = 3;
spout_id = 10;
cap_od = 52.6;

//shorthand
twt=thin_wall_thickness;

//calculated
cone_arc_angle = 2 * cone_folded_arc_angle;
cone_arc_length = 2 * PI * cone_arc_angle / 360 * cone_slant_h;
cone_r = (1/(2*PI)) * cone_arc_length;
cone_h = sqrt(cone_slant_h^2 - cone_r^2);
//cone_slope = cone_h/cone_r;

filter_h = filter_slant_h * (cone_h / cone_slant_h);
filter_r = filter_h * (cone_r / cone_h);


//todon't: this is good enough
module cap(fancy=!$preview){
	//from https://www.printables.com/model/215011-soda-bottle-funnel-cap-for-siraya-tech-resin-1-kg/files
	// if substituting your own,
	// position it so that the imaginary lip of the bottle
  // is	on the xy plane and centered around the z axis
	x_min=-13.59;
	y_min=-7.58;
	z_min=-.175;
	d = 54.53;
	d_narrow = cap_od;
	if(fancy){
		rotate([90,0,0])
			translate([x_min-.5*d,y_min,z_min-.5*d])
				import("basic_cap.stl", convexity=20);
	} else {
		difference(){
			translate([0,0,-19]) cylinder(h=21,d=d_narrow);
			translate([0,0,-20+.1])cylinder(h=20,r=25.5);
		}
	}
	

}

module funnel(){
	difference(){
		union(){
			//flow gap
			cylinder(h=cone_h-filter_h+flow_gap,r=filter_r+twt);
			translate([0,0,flow_gap+cone_h-filter_h]) cylinder(h=filter_h,r1=filter_r+twt, r2= twt);
			//funnel
			cylinder(h=cone_h, r1=cone_r + twt, r2 = twt);
			//spout
			cylinder(h=flow_gap+cone_h+99, d=spout_id+2*twt);
		}
		union(){
			//flow gap
			cylinder(h=cone_h-filter_h+flow_gap+.1,r=filter_r);
			#translate([0,0,flow_gap+cone_h-filter_h]) cylinder(h=filter_h,r1=filter_r, r2 = 0);
			//funnel
			translate([0,0,-.1]) cylinder(h=cone_h, r1=cone_r, r2 = 0);
			//spout
			cylinder(h=flow_gap+cone_h+99+.1, d=spout_id);
			
			translate([twt,0,cone_h+flow_gap]) hull(){
				translate([ cone_r,-50,-cone_h]) cube(100);
				translate([-cone_r,-50, cone_h]) cube(100);
			}
			//translate([0,0,cone_h]) rotate([30,0,0]) translate([0,0,50]) cube(100, center=true);
		}
	}
}

module hyperboloid(h, r0=cap_od/2, slope=cone_h/cone_r){
	/*
		xx/aa+yy/bb-zz/cc=1, asymptotic to xx/aa+yy/bb-zz/cc=0
		
		r^2/a^2-z^2/c^2=1; asymptotic to r^2/a^2-z^2/c^2=0;
		 asymptotic to r^2/a^2=z^2/c^2; or z/r=+/- c/a
		 
		 parametrezation over z
		 rr/aa=1+zz/cc
		 rr=aa+aazz/cc
		 r=sqrt(aa+aazz/cc)
		 
		 r=sqrt(r0^2+slope^-2*z^2)
	*/
	n=max(3,ceil(h*sqrt(1+slope^-2)/$fs));
	points = [[0,0],for(i=[0:n]) [sqrt(r0^2+(1/slope*h*i/n)^2),h*i/n],[0,h]];
	rotate_extrude() polygon(points);
}

module hyperboloid2(h, r0=cap_od/2, r1){
	/*
	r1=sqrt(r0^2+unslope^2*h^2)
	r1^2=r0^2+unslope^2*h^2
	(r1^2-r0^2)/h^2=unslope^2
	*/
	unslope=sqrt(r1^2-r0^2)/h;
	n=max(3,ceil(h*sqrt(1+unslope^2)/$fs));
	points = [[0,0],for(i=[0:n]) [sqrt(r0^2+(unslope*h*i/n)^2),h*i/n],[0,h]];
	rotate_extrude() polygon(points);
}

module hyperboloid3(h, r0, r1, thickness, num_legs, percent=.25){
	assert(r1>=r0);
	
	// reparamaterized such that f(..., t=1) = [_,_,h]
	function rule_line_point (alpha,a,b,c,h) = [a*cos(alpha),b*sin(alpha),0] +
		(h/c)*[-a*sin(alpha),b*cos(alpha),c];
	function inset_xy (point, inset) = 
		point - concat(inset * point.xy, [0]) / norm(point.xy);
	//function reversed(list) = [for (i=[1:len(list)]) list[len(list)-i]];
	
	
	
	unslope=sqrt(r1^2-r0^2)/h;
	
	a = r0;
	b = r0;
	c = a/unslope;
	
	/*
	ok so I want the 
	*/
	r_count = ceil(2*PI*r1/$fs/num_legs*percent);
	alpha_range = 360/num_legs*percent;
	
	//SCREAMING TODO
	//constantly vary inset from 0 to 1 to get side saddle. urgh
	
	
	points = [ for(alpha=[0:r_count-1],h=[0,h]) 
		each [
			rule_line_point(alpha/(r_count-1)*alpha_range,a,b,c,h),
			inset_xy(rule_line_point(alpha/(r_count-1)*alpha_range,a,b,c,h), thickness)
		]
	];
	polyhedron(points,faces);
	echo(points);
	for(i = [0:3]) translate(points[i])
		color(["red","green","blue","yellow"][i]) cube(2,center=true);
	for(p=points) translate(p) cube(1);
	
	faces = [[0,1,3,2],len(points)*[1,1,1,1] - [1,2,4,3]];
	echo(faces);
	cube();
}

!hyperboloid3(cone_h+flow_gap,cap_od/2,cone_r,5,5);

module main(){
	translate([0,0,cone_h+flow_gap]) mirror([0,0,1]) funnel();
	difference(){
		cap();
		//todo hardcoded
		cylinder(r=25.5-5,h=5);
	}
	%hyperboloid2(cone_h+flow_gap,cap_od/2,cone_r);
	%hyperboloid3(cone_h+flow_gap,cap_od/2,cone_r,5,5);
}

main();




echo([1,2,3]-[1]);












