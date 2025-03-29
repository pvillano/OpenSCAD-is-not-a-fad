
/* [Design Parameters] */
label_height = 11;
wall_thickness = 2.41;
/* [Measurements] */

d1 = 45.5;
d2 = 45;

/* [Derived] */
od1 = d1 + 2 * wall_thickness;
od2 = d2 + 2 * wall_thickness;
difference(){
  cylinder(d1=od1, d2=od2, h=label_height, center=true);
  cylinder(d1=d1, d2=d2, h=label_height+.2, center=true);
}

$fa = .01;
$fs = .3;