$fa = .01 + 0;
$fs = 1;
plexi_w = 444.5; // 17.5*25.4;
plexi_t = 3.2; //25.4/8;

lack_hole_w = 444.5;
lack_hole_h = 400;
lack_w = 550;

available_h = (plexi_w - lack_hole_h) / 2; //22.5, 7/8
available_w = (lack_w - lack_hole_w) / 2;

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}

module main() {
  %translate([available_w, 0, 0]) cube([plexi_w, plexi_t, plexi_w,]);

  difference() {
    //base
    union() {
      cube([available_w, available_w, available_h]);
      translate([0, 0, plexi_w - available_h]) cube([available_w, available_w, available_h]);
    }
    //holes
    translate() mirror2([0, 0, 1]);
  }
}


hinge_h = 19.05;
hinge_w = 15.9;
module hinge() translate([-117.05, -103.527, 0]) import("1603A2_Surface-Mount Hinge with Holes.stl");

main();
translate([available_w - hinge_w / 2, 0, available_h / 2 - hinge_h / 2])mirror([0, 1, 0])hinge();
