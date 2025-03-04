$fa = .01;
$fs = 1;
union() {
  minkowski() {
    linear_extrude(.01) offset(-1.5) 2d();
    cylinder(r1 = 1.5, r2=0, h = 1.5);
  }
  mirror([0, 0, 1]) linear_extrude(4) 2d();
}



module 2d(hole = true) difference() {
  union() {
    circle(d=29);
    hull() {
      translate([-40, 0, 0]) circle(d=20);
      circle(d=20);
      translate([95, 0, 0]) circle(d = 4);
    }
  }
  if (hole) circle(d=22.1);
}

module 2ad() {
  difference() {
    hull() {
      translate([-40, 0, 0]) circle(14);
      circle(25.4 / 4 + 5);
      translate([80, 0, 0]) circle(d = 3);
    }
    circle(25.4 / 4 + 1);
  }
}