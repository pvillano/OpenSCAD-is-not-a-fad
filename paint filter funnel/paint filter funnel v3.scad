/*

* should 

*/

fancycap = false;
//todo: bonus X000 micron (X mm) filter for big chunks

$fa = .01;
$fs = 1; //5->28s, 4->16s,3->???,2->29s,1->121s

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

module mirror2(xyz){
	children();
	mirror(xyz) children();
}
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

module funnel(neg=false){
	if(!neg){
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
			//spout cut
			translate([twt,0,cone_h+flow_gap]) hull(){
				translate([ cone_r,-50,-cone_h]) cube(100);
				translate([-cone_r,-50, cone_h]) cube(100);
			}
		}
	} else {
		//flow gap
		cylinder(h=cone_h-filter_h+flow_gap+.1,r=filter_r);
		#translate([0,0,flow_gap+cone_h-filter_h]) cylinder(h=filter_h,r1=filter_r, r2 = 0);
		//funnel
		translate([0,0,-.1]) cylinder(h=cone_h, r1=cone_r, r2 = 0);
		//spout
		cylinder(h=flow_gap+cone_h+99+.1, d=spout_id);
		//translate([0,0,cone_h]) rotate([30,0,0]) translate([0,0,50]) cube(100, center=true);
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

module hyperboloid3(h, r0, r1, thickness, num_legs, percent=0.25){
	assert(r1>=r0);
	
//	// reparamaterized such that f(..., t=1) = [_,_,h]
//	function rule_line_point (alpha,a,b,c,h) = [a*cos(alpha),b*sin(alpha),0] +
//		(h/c)*[-a*sin(alpha),b*cos(alpha),c];
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
	arc_length = 2*PI*r1/num_legs*percent;
//	theta_count = max(ceil(arc_length/$fs), 4);
//	r_count = max(ceil(thickness/$fs), 4);
	theta_count = 5;
	r_count = 3;


	/*
	line exists between (a,0,0) and (a,a,c), f(t)=(a,at,tc)
	at hight h, t=h/c, point is (a,ah/c,h)
	new angle is atan((ah/c)/a)
	=atan(h/c)
	= atan(h/(a/unslope))
	= h * unslope / a
	= h * sqrt(....) / h / a
	= sqrt(...)/a
	= sqrt(r1-r0)/r0
	... this doesn't depend on h, which makes sense because it should be scale invariant(?)(???)

	(sanity check) new radius is
	sqrt(a^2+(ah/c)^2))
	= sqrt(a^2+(a*h*unslope/a)
	= sqrt(a^2+(h*unslope)^2)
	= sqrt(r0^2+(r1^2-r0^2)))
	= r1
	 */
	theta_offset = atan(h/c);

	function point_pair(r_, theta_) = [
		[r0-thickness*r_/(r_count-1),arc_length*theta_/(theta_count-1)-arc_length/2,0],
		[r1-thickness*r_/(r_count-1),arc_length*theta_/(theta_count-1)+theta_offset-arc_length/2,h]
	];
	function cyl_to_cart(r,theta,z) = [r*cos(theta), r*sin(theta), z];

	//looks clockwise from the top
	points_cyl = concat(
		[ for (r_ = [0:r_count-2],    theta_=[0]                 ) each point_pair(r_, theta_) ], //in
		[ for (r_ = [r_count-1],      theta_=[0:theta_count-2]   ) each point_pair(r_, theta_) ], //ccw
		[ for (r_ = [r_count-1:-1:0], theta_=[theta_count-1]     ) each point_pair(r_, theta_) ], //out
		[ for (r_ = [0],              theta_=[theta_count-2:-1:1]) each point_pair(r_, theta_) ]  //cw
	);
	points_cart = [for (p = points_cyl) cyl_to_cart(p.x, p.y, p.z)];

	PHI=1.618;
	function rainbow(i)=[sin(360*(i-1/3))/2+.5,sin(360*i)/2+.5,sin(360*(i+1/3))/2+.5];
	function rainbarf(i) = [sin(360*i/PHI)/2+.5,sin(360*i)/2+.5,sin(360*i*PHI)/2+.5];

//	//debug order of points
//	for(i=[0:len(points_cart)-1]) let (p=points_cart[i]){
//		color(rainbow(i/len(points_cart))) translate(p) rotate([0,0,i])cube();
//		color(rainbow(i/len(points_cart))) translate([i,i,i]) cube();
//	}
//	//debug faces
//	for(i=[0:2:len(points_cart)]) let ( pp= [ for (j=[i:i+3]) points_cart[j%len(points_cart)]]){
//		color(rainbow(i/(len(points_cart)))) hull(){
//			for(p=pp) translate(p) cube();
//		}
//		color(rainbow(i/len(points_cart))) translate([i,i,i]) cube();
//	}

	mirror2([0,1,0]) for(ti=[0:num_legs]){
		rotate([0,0,360*ti/num_legs]) for(i=[0:2:len(points_cart)]) let ( pp= [ for (j=[i:i+3]) points_cart[j%len(points_cart)]]){
			hull(){
				for(p=pp) translate(p) cube();
			}
		}
	}
	%hyperboloid2(h, r0,r1);
}


module main(){
	difference(){
		union(){
			translate([0,0,cone_h+flow_gap]) mirror([0,0,1]) funnel();
			translate([0,0,1])hyperboloid3(cone_h+flow_gap-2,cap_od/2-1,cone_r,5,5);
		}
		translate([0,0,cone_h+flow_gap]) mirror([0,0,1]) funnel(neg=true);
	}
	difference(){
		cap();
		//todo hardcoded
		cylinder(r=25.5-5,h=5);
	}
}

main();