$fs = 1;
$fa = .01;
use <threads.scad>




SpoolHeight = 70;
SpoolFlangeThickness = 13;
SpoolInnerDiamater = 50;
TowelInnerDiameter = 25;
TowelHeight = 150;

Grip=2.5;

//RodHasFlat = true;

ThreadDiameter = SpoolInnerDiamater-4;

module Core(){
  difference(){
    union(){
      cylinder(h=SpoolHeight, d=SpoolInnerDiamater);
      translate([0,0,SpoolFlangeThickness]) rotate(22.5)cylinder(h=SpoolHeight-2*SpoolFlangeThickness, d=SpoolInnerDiamater+2*Grip);
    }
    if(!$preview) ScrewHole(ThreadDiameter, SpoolHeight, tolerance=0.4);
    cube([SpoolInnerDiamater+2*Grip,Grip,SpoolHeight*2+.2], center=true);
    cube([Grip,SpoolInnerDiamater+2*Grip,SpoolHeight*2+.2], center=true);
    for(i=[0:3]){
      difference(){
        rotate([0,0,45+i*90])
          translate([0,0,SpoolHeight/2])
          rotate([90,0,0])
          linear_extrude(SpoolInnerDiamater+SpoolFlangeThickness, convexity=3)
          text("ABCD"[i], halign = "center", valign = "center", size=SpoolHeight/2);
        cylinder(h=SpoolHeight, d=SpoolInnerDiamater);
      }
    }
  }
}


module Rod(){
  union(){
    cylinder(h=SpoolHeight+TowelHeight,d=TowelInnerDiameter);
    ScrewThread(ThreadDiameter, SpoolHeight, tolerance=0.4);
  }
}

Core();