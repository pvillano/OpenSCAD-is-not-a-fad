$fa = .01;
$fs = .3;


//measured
bitDiameterInches = .251;
nBits = 8; // must be even lol
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
innerCircumference = (bitCircumDiameter + twt) * nBits;
id = innerCircumference / PI;
od = id + 2*shankLength+2*twt;
h = bitCircumDiameter + 2 * twt;

difference() {
  //base
  cylinder(d = od, h = h, center = true, $fn=nBits);
  //cap rotating area
  cylinder(d = id, h = m3CapH, center = true);

  cylinder(d = id-m3CapD+m3, h = h/2+.1);
  for (i = [0:nBits - 1]) rotate([0, 0, 360 * i / nBits]){
    translate([id/2+twt,0,0]) rotate([0, 90, 0])cylinder(d = bitCircumDiameter, h = shankLength+.1, $fn=6);
    //cap sliding area
      cube([od,m3CapD,m3CapH],center=true);
    //threads sliding area
    hull(){
      translate([-m3/2,-m3/2,0]) cube([m3,m3,bitCircumDiameter/2+twt+.1]);
      translate([(id+od)/4,0,0])cylinder(d=m3,h=bitCircumDiameter/2+twt+.1);
    }
  }
  //cutaway
  if($preview)cube(99);
}
//preview screw
%translate([(id-m3CapD)/2,0,0]) cylinder(d=m3CapD,h=m3CapH, center=true);
%translate([(id-m3CapD)/2,0,0]) cylinder(d=m3,h=12);

//cap part
translate([0,0,h/2+.2]) difference(){
  //base with shadow line
  union(){
    translate([0,0,.5])cylinder(d = od, h = insertHeight-.5, $fn=nBits);
    cylinder(d = od-1, h = insertHeight, $fn=nBits);
  }
  for(dx = [-(id-m3CapD)/2,(id-m3CapD)/2]) translate([dx,0,0]) {
    translate([0,0,-.1]) cylinder(d=insertDiameter,h=insertHeight+.2);
  }
}