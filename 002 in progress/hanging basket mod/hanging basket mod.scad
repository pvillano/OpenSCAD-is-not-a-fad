$fa =.01;
$fs=.1;

basketDepth =40;
basketWidth = 100;
basketHeight=100;
clipHeight = 40;
clipThickness=4;
clipOverhang=5;
thinWallThickness=3.5;

twt=thinWallThickness;

difference(){
  union(){
    cube([basketWidth, basketDepth, basketHeight]);
    translate([0,-clipThickness,basketHeight-clipOverhang-twt])
      cube([basketWidth, clipThickness+2*twt, clipOverhang+twt]);
  }

  translate([twt,twt,twt]) cube([basketWidth, basketDepth, basketHeight]-twt*[2,2,0]);
  translate([0,0,basketHeight-clipHeight-twt])
    cube([basketWidth, clipThickness, clipHeight]);
}
%difference(){
}