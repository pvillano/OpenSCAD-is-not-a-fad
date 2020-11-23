$fa = .01;
$fs = $preview ? 1 :.2;

od1 = 28.0;
id1 = 23.5;
h_outer = 16.3;
h_outer_2 =13.9;
h_inner = 10.9;
od2 = 10.5;
id2 = 6.0 + .1;

difference(){
    cylinder(h=h_outer, d=od1);
    cylinder(h=h_outer_2,d=id1);
}
translate([0,0,h_outer_2-h_inner])
difference(){
    cylinder(h=h_inner, d=od2);
    cylinder(h=h_inner, d=id2);
}