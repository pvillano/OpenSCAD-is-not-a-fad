$fa = .01;
$fs = $preview ? 1 :.2;

d = 25.2;
h = 32;
t = 8;

screw_d=4.75;
cs_d=8.45;
cs_h = 5;
ep = .1;
squish=2;

sin8 = 1/cos(360/16);

module screw(){
    rotate([-90,360/16,0]) {
        cylinder(d=screw_d*sin8+ep, h=t+ep, center=true, $fn=8);
        translate([0,0,t/2-cs_h/2+ep]) cylinder(d1=screw_d*sin8+ep, d2=cs_d*sin8+ep, h=cs_h, center=true, $fn=8);
    }
};

difference(){
    union(){
        translate([0,t/2,0]) cube([d+2*t+2*h,t,h], center=true);
        hull(){
            translate([0, d/2-squish, 0]) cylinder(d=d+2*t, h=h, center=true);
            translate([0,          0, 0]) cylinder(d=d+2*t, h=h, center=true);
        }
    }
    hull(){
        translate([0, d/2-squish, 0]) cylinder(d=d+ep, h=h+ep, center=true);
        translate([0,          0, 0]) cylinder(d=d+ep, h=h+ep, center=true);
    }
    translate([0, -(d+2*t)/2, 0]) cube(d+2*t, center=true);
    translate([ (d/2+t+h/2), t/2, 0]) screw();
    translate([-(d/2+t+h/2), t/2, 0]) screw();
}