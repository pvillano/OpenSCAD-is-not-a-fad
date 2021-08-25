$fa = .01;
$fs = $preview ? 5 : .1;

w=15;
h=10;

for(i=[1:4]){
    dx=w*i/sqrt(2)*.9;
    translate([dx,dx,0])
        cylinder(d=w,h=i);
}