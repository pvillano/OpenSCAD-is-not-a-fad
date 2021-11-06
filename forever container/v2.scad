prototype = true;

$fa = .1;
$fs = $preview ? 5 : 1;
use <threads.scad>


//material constants

thin_wall_thickness = .86;

//design constants

pitch = prototype ? 5 : 2;
flex_outer_diameter = prototype ? 50 : 150;
h = prototype ? 10 : 15;
//tooth_angle = 45;
dr = 1;
dh = dr*PI;
//calculated constants

//shorthand
twt = thin_wall_thickness;

//pure
//tooth angle is approximate
module spike_gear(count, height, dr, dh) {
    r=count*dr;
    function polar(i, r) = [cos(i * 180 / count), sin(i * 180 / count)] * r;
    points = [for (i = [1:count * 2]) ((i % 2) ? polar(i, r+dh/2) : polar(i, r-dh/2))];
    linear_extrude(height) {
        polygon(points);
    }
}

fiddy=floor(150/dr/4);
module inner_solid() {
    spike_gear(fiddy, h, dr, dh);
}
module outer_flex(cnt){
    difference(){
        cylinder(h=h, r=cnt*dr+dh/2+twt);
        translate([0,0,-.1]) spike_gear(cnt, h+.2, dr, dh);
    }
}
//inner_solid();
for(i=[1,2]) rotate([0,0,45+90*i]) translate([2*(fiddy+5)*dr,0,0]) outer_flex(fiddy+i);