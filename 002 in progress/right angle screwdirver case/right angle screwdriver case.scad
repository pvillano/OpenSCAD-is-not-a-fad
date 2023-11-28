$fa = .01;
$fs = .3;


//measured
bitDiameterInches = .251;
nBits = 7;
shankLength = 20;

m3=3+.2;
m3CapD=5.5+.2;
m3CapH=3+.2;
insertDiameter = 4;
insertHeight = 3;
//designed
twt = 1.2;
//constant
inch = 25.4;
//calculated
bitDiameter = bitDiameterInches * inch;
bitCircumDiameter = bitDiameter / cos(30);
id = bitCircumDiameter / sin(180/nBits);
od = id + 2*shankLength+2*twt;
h = bitDiameter + 2 * twt;

difference() {
  //base
  cylinder(d = od, h = h, center = true, $fn=nBits);
  //rotating area
  cylinder(d = id, h = bitDiameter, center = true);

  cylinder(d = od/4, h = h/2+.1);
  for (i = [0:nBits - 1]) rotate([0, 0, 360 * i / nBits]){
    rotate([90, 0, 90]) cylinder(d = bitCircumDiameter, h = od/2*1.1, $fn=6);
    translate([0,-m3/2,0]) cube([od/4,m3,h]);
  }
  %translate([id/2,0,0]) rotate([90, 0, 90]) cylinder(d = bitCircumDiameter-.1, h = shankLength+.1, $fn=6);
  //cutaway
  if($preview)cube(99);
}