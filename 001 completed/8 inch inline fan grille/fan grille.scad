$fa = .01;
$fs = $preview ? 10 : 1;

twt = 3.30;
h1=20;
h2=10;
d0=199;
d1=d0+twt*2;

difference(){
    cylinder(h=h1+h2,d=d1);
    translate([0,0,h2])
        cylinder(h=h1+.1,d=d0);
}