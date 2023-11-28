$fa = .01;
$fs = .3;


//measured
bitDiameterInches = .251+.1;
nBits = 8; // must be even lol
shankLength = 20;

m3=3+.2;
m3CapD=5.5+.2;
m3CapH=3+.2;
nylockDiameter = 5.5;
nylockHeight = 4+.2;
//designed
twt = 1.2;
//constant
inch = 25.4;
//calculated
bitDiameter = bitDiameterInches * inch;
bitCircumDiameter = bitDiameter / cos(30);
innerCircumference = (bitCircumDiameter + twt) * nBits;
id = innerCircumference / PI;
od = id + shankLength;
h = bitCircumDiameter + 2 * twt;
nylockCircumDiameter= nylockDiameter / cos(30);

difference() {
  //base
  cylinder(d = od, h = h, center = true, $fn=nBits);
  //cap rotating area
  cylinder(d = id, h = m3CapH, center = true);

  cylinder(d = id-m3CapD+m3, h = h/2+.1);
  for (i = [0:nBits - 1]) rotate([0, 0, 360 * i / nBits]){
    translate([id/2,0,0])rotate([0, 90, 0]) cylinder(d = bitCircumDiameter, h = od/2+.1, $fn=6);
    //cap sliding area
    hull(){
      cylinder(d=m3CapD,h=m3CapH, center=true);
      translate([(id+od)/4,0,0])cylinder(d=m3CapD,h=m3CapH, center=true);
    }
    //threads sliding area
    hull(){
      cylinder(d=m3,h=bitCircumDiameter/2+twt+.1);
      translate([(id+od)/4,0,0])cylinder(d=m3,h=bitCircumDiameter/2+twt+.1);
    }
    translate([(id-m3CapD)/2,0,0]) cylinder(d=m3,h=h+.2, center=true);
  }
  //cutaway
  if($preview)cube(99);
}
//preview screw
%translate([(id-m3CapD)/2,0,0]) cylinder(d=m3CapD,h=m3CapH, center=true);
%translate([(id-m3CapD)/2,0,0]) cylinder(d=m3,h=12);

//cap part
translate([0,0,h]) difference(){
  h2=nylockHeight+twt;
  cylinder(d = od, h = h2, $fn=nBits);
  for(dx = [-(id-m3CapD)/2,(id-m3CapD)/2]) translate([dx,0,0]) {
    translate([0,0,-.1]) cylinder(d=m3,h=h2+.2);
    translate([0,0,h2-nylockHeight])cylinder(d=nylockCircumDiameter, h=nylockHeight+.1, $fn=6);
  }
}