$fa =.01;
$fs=.1;
hs=[1,1.5,2];
for(i=[0:len(hs)-1]) let(h=hs[i]) translate([i*20,0,0]) difference(){
    cylinder(h = h, d = 14);
    translate([0,0,-.1]) cylinder(h = h+.2, d = 4);
}