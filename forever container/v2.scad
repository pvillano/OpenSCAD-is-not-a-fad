prototype = true;
debug=true;

$fa = .1;
$fs = debug || $preview ? 5 : 1;
use <threads.scad>


//material constants

thin_wall_thickness= .86;

//design constants

pitch=prototype ? 5 : 2;
od = prototype ? 50 : 150;
h = prototype ? 50 : 150;
tooth_angle=30;

//calculated constants
num_teeth_inner = round(od*PI/pitch);
outer_radius = od/2;
inner_radius = outer_radius - (od*PI/num_teeth_inner/2)/tan(tooth_angle);

//shorthand
twt = thin_wall_thickness;
	
//tooth angle is approximate
module spike_gear(outer_diam, height, count, tooth_angle=tooth_angle){
	function polar(i, r) = [cos(i*180/count), sin(i*180/count)]*r;
	points = [for (i=[1:count*2]) if (i % 2) polar(i,outer_radius) else polar(i, inner_radius)];
	linear_extrude(height){
		polygon(points);
	}
}

module flexspline(){
	difference(){
		intersection(){
			ScrewThread(outer_diam=od, height=h, pitch=pitch, tooth_angle=tooth_angle, tolerance=0.4);
			spike_gear(od,h,num_teeth_inner);
		}
		translate([0,0,-.1]) cylinder(h=h+.2,d=(inner_radius-twt)*2);
	}
}

flexspline();