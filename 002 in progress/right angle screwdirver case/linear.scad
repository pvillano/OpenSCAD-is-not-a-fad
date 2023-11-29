$fa=.01;
$fs=.3;

//measured
bitDiameterInches = .25;
shankLength = 15;
//designed
twt = 1.2;
length = 80;
nBits = 7;
angle = 45;
//constant
inch = 25.4;
//calculated
bitDiameter = bitDiameterInches * inch;
bitCircumDiameter = bitDiameter / cos(30) -.125; //friction fit
dx = length / nBits+1;
height = shankLength * (1+cos(angle) * .8)/2;
difference() {
  intersection() {
    hull() {
      for (i = [0, nBits - 1]) {
        translate([dx * i, 0, 0])rotate([0, angle, 0]) cylinder(d = bitCircumDiameter + 2 * twt, h = shankLength*2, center = true);
      }
    }
    //cube([length*3,bitCircumDiameter + 2 * twt,shankLength*cos(angle)-sin(angle)*bitCircumDiameter], center=true);
    //cube([length*3,bitCircumDiameter + 2 * twt,shankLength*cos(angle)], center=true);
    cube([length*3,bitCircumDiameter + 2 * twt,7], center=true);
  }
  for (i = [0:nBits - 1]) {
    translate([dx * i, 0, 0])rotate([0, angle, 0]) cylinder(d = bitCircumDiameter, h = shankLength*2,center =
    true);
  }
}
%rotate([0, angle, 0]) cylinder(d = bitCircumDiameter, h = 20, $fn = 6, center = true);
%translate([dx, 0, 0]) rotate([0, angle, 0]) cylinder(d = bitCircumDiameter, h = 20, $fn = 6, center = true);