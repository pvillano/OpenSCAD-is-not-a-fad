$fa = .01;
$fs =.5;
ep=.01;
h=12;
d2=30.0+.2;
d1=30.6+.2;
twt=1.24;
inch=25.4;
difference(){
    mirror([0,0,1]) cylinder(h=h+1.2,d1=d1+twt*2,d2=inch*1.5);
    translate([0,0,ep]) mirror([0,0,1]) cylinder(h=h+ep,d1=d1,d2=d2);
}