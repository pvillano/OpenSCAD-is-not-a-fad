/*

* should 

*/


//todo: bonus X000 micron (X mm) filter for big chunks

$fa = .01;
$fs = 5;

//measurements
cone_folded_arc_angle = 105;
cone_slant_h = 120;
filter_slant_h = 43;

//design parameters
thin_wall_thickness = 2;
pour_hole_d = 44;
pour_hole_margin = 4;

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

filter_r_safe = min(filter_r, .5 * pour_hole_d - pour_hole_margin);

//todon't: this is good enough
module cap(){
	//from https://www.printables.com/model/215011-soda-bottle-funnel-cap-for-siraya-tech-resin-1-kg/files
	// if substituting your own,
	// position it so that the imaginary lip of the bottle
  // is	on the xy plane and centered around the z axis
	x_min=-13.59;
	y_min=-7.58;
	z_min=-.175;
	d = 54.53;
	if($preview){
		difference(){
			translate([0,0,-19]) cylinder(h=21,d=d);
			mirror([0,0,1]) cylinder(h=20,d=d-8);
		}
	} else {
		rotate([90,0,0]) translate([x_min-.5*d,y_min,z_min-.5*d]) import("basic_cap.stl");
	}
	

}


module decorative_web(h,r1, r2, count, offset_count, thickness,center=false){
	//
	phase_shift = 360 * offset_count/count;
	translate([0,0, center ? -h/2: 0])
		for(i=[0:count-1])
	{
		theta=360*i/count;
			
		hull(){
			rotate([0,0,theta]) translate([r1,0,0]) sphere(d=thickness, $fn=8);
			rotate([0,0,theta+phase_shift]) translate([r2,0,h]) cube(thickness, center=true);
		}
		hull(){
			rotate([0,0,theta]) translate([r1,0,0]) sphere(d=thickness);
			rotate([0,0,theta-phase_shift]) translate([r2,0,h]) cube(thickness, center=true);
		}
		hull(){
			rotate([0,0,theta]) translate([r1,0,0]) sphere(d=thickness);
			rotate([0,0,theta-phase_shift]) translate([r2,0,h]) cube(thickness, center=true);
		}
	}
}


module funnel(){
	 difference(){
		union(){
			//fat part
			cylinder(h=cone_h, r1=cone_r+twt,r2=twt);
			//skinny part
			//translate([0,0,cone_h-filter_h])
				//cylinder(h=filter_h,r1=filter_r+twt, r2=filter_r_safe+twt);
			decorative_web(h=cone_h, r2=pour_hole_d/2+twt,r1=cone_r+twt,count=10,offset_count=2,thickness=3);
		}
		//fat negative
		translate([0,0,-.1]) cylinder(h=cone_h+.1, r1=cone_r,r2=0);
		//skinny negative
			translate([0,0,cone_h-filter_h])
				cylinder(h=filter_h+.01,r1=filter_r, r2=filter_r_safe);
		
		///translate([0,0,cone_h-filter_h]) cylinder(h=filter_h,r=filter_r_safe);
	}
	//%translate([0,0,cone_h-filter_h]) cylinder(h=filter_h,r=filter_r);
}
module main(){
	translate([0,0,cone_h]) mirror([0,0,1]) funnel();
	difference(){
		cap();
		cylinder(d=pour_hole_d,h=99, center=true);
	}

}

main();
























