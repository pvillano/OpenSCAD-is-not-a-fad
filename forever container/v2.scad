prototype = true;
debug = true;

$fa = .1;
$fs = debug || $preview ? 5 : 1;
use <threads.scad>


//material constants

thin_wall_thickness = .86;

//design constants

pitch = prototype ? 5 : 2;
flex_outer_diameter = prototype ? 50 : 150;
h = prototype ? 50 : 150;
tooth_angle = 45;

//calculated constants
num_teeth_inner = round(flex_outer_diameter * PI / pitch);
num_teeth_outer = round(num_teeth_inner * 1.1);
flex_outer_radius = flex_outer_diameter / 2;
flex_inner_radius = flex_outer_radius - (flex_outer_diameter * PI / num_teeth_inner / 2) / tan(tooth_angle);

//shorthand
twt = thin_wall_thickness;

//pure
//tooth angle is approximate
module spike_gear(outer_r, inner_r, height, count) {
    function polar(i, r) = [cos(i * 180 / count), sin(i * 180 / count)] * r;
    points = [for (i = [1:count * 2]) ((i % 2) ? polar(i, outer_r) : polar(i, inner_r))];
    linear_extrude(height) {
        polygon(points);
    }
}

module flexspline() {
    difference() {
        intersection() {
            ScrewThread(outer_diam = flex_outer_diameter, height = h, pitch = pitch, tooth_angle = tooth_angle,
            tolerance = 0.4);
            spike_gear(flex_outer_radius, flex_inner_radius, h, num_teeth_inner);
        }
        translate([0, 0, - .1]) cylinder(h = h + .2, d = (flex_inner_radius - twt) * 2);
    }
}



module circularspline() {
    circular_inner_radius = num_teeth_outer / num_teeth_inner * flex_inner_radius;
    circular_outer_radius = circular_inner_radius + (circular_inner_radius * 2 * PI / num_teeth_outer / 2) / tan(tooth_angle);
    difference() {
        cylinder(h = h, r = circular_outer_radius + 2 );
        intersection() {
            translate([0, 0, - .1]) ScrewThread(outer_diam = circular_outer_radius * 2, height = h + .2, pitch = pitch,
            tooth_angle =
            tooth_angle, tolerance = 0.4);
            translate([0, 0, - .1]) spike_gear(circular_outer_radius, circular_inner_radius, h + .2, num_teeth_outer);
        }
    }
}



translate([-flex_outer_diameter, -flex_outer_diameter,0]) flexspline();

translate([flex_outer_diameter, flex_outer_diameter,0]) circularspline();