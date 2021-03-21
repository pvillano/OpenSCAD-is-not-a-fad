$fa = .01;
$fs = $preview ? .2 : .05;

r1 = 1.0;
r2 = 1.3333;
r3 = 1.6666;
r4 = 1.9999;
width = 30;
height = 10;
hull(){
    translate([ (width/2-r1), (width/2-r1),0]) cylinder(h=height, r=r1);
    translate([ (width/2-r2),-(width/2-r2),0]) cylinder(h=height, r=r2);
    translate([-(width/2-r3),-(width/2-r3),0]) cylinder(h=height, r=r3);
    translate([-(width/2-r4), (width/2-r4),0]) cylinder(h=height, r=r4);
}