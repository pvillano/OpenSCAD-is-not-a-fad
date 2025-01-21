$fs = 1;
$fa =.01;

od = 200;
t =6;

module main() {
//  %cylinder(d1=od, d2=0, h=od);
//  rotate_extrude()!
  union(){
    hull(){
      square([od-3*t,t]);
      translate([0,t])square([od-2*t,t]);
    }
    hull(){
      translate([0,2*t]) square([od-2*t,t]);
      translate([0,3*t]) square([od-t,t]);
    }
    translate([od-1.5*t,3.5*t]) circle(d=t*sqrt(2));
  }
}
difference(){
  union(){
    translate([od-.5*t,2.5*t]) circle(d=t*sqrt(2));
    hull(){
      w=10;
      translate([0,2*t]) square([od,t]);
      translate([0,-w]) square([od-w-2*t, t]);
    }
  }
  #main();
}