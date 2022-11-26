$fa = .01;
$fs = 1;

//measurements
cone_folded_arc_angle = 105;
cone_slant_h = 100;
filter_slant_h = 35;
bottle_id = 25.4;

//design parameters
wumbo = 3;

//calculated
cone_arc_angle = 2 * cone_folded_arc_angle;
cone_arc_length = 2 * PI * cone_arc_angle / 360 * cone_slant_h;
cone_r = (1/(2*PI)) * cone_arc_length;
cone_h = sqrt(cone_slant_h^2 - cone_r^2);
//cone_slope = cone_h/cone_r;

filter_h = filter_slant_h * (cone_h / cone_slant_h);
filter_r = filter_h * (cone_r / cone_h);


module main(){
		//gap
		cylinder(h=wumbo,r=filter_r);
		translate([0,0,wumbo]) cylinder(h=filter_h,r1=filter_r, r2=0);
		//funnel
    translate([0,0,filter_h-cone_h])cylinder(h=cone_h, r1=cone_r, r2 = 0);
		//spout
		cylinder(h=filter_h+wumbo, d=bottle_id);
}

main();
























