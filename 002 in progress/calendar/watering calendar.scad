$fa = .01;
$fs = 1;

depth = 1;
width = 50;
fontsize = .8 * width;
monthsize = .23 * width;
slop = 2;
chamfer = .2;
ep = .1;
/*
# note that 30, 31 == 03, 13 => only worry about 01..29
# 11,22 => 1 and 2 on each die
# 01...08 => 0 must be opposite of eight numbers => 0 must be on two dice
# leaves 6 spots for 3...9 => 6 must also be 9

from itertools import product, chain

a, b = [0, 1, 2, 3, 4, 5], [0, 1, 2, 6, 7, 8, 9]
assert len(set(chain.from_iterable([10 * i + j, 10 * j + i] for i, j in product(a, b))).intersection(range(31))) == 31

*/


module gizmo() {
  color([1, 0, 0]) cube([10, 1, 1]);
  color([0, 1, 0]) cube([1, 10, 1]);
  color([0, 0, 1]) cube([1, 1, 10]);
}

module rotate_to(xyz, a = 0) {
  xyz = xyz / norm(xyz);
  perp = cross([0, 0, 1], xyz);
  angle = acos(xyz * [0, 0, 1]);
  //normally undefined
  rotate(angle, xyz == [0, 0, -1] ? [1, 0, 0] :  perp)
    rotate(a)
      children();
}

module octahedron(r) {
  scale(r) polyhedron(
  points = [
      [0, 0, 1],
      [1, 0, 0],
      [0, 1, 0],
      [-1, 0, 0],
      [0, -1, 0],
      [0, 0, -1],
    ],
  faces = [
      [0, 1, 2],
      [0, 2, 3],
      [0, 3, 4],
      [0, 4, 1],
      [5, 2, 1],
      [5, 3, 2],
      [5, 4, 3],
      [5, 1, 4],
    ]
  );
}

module gube() {
  cube(width, center = true);
  //  minkowski() {
  //    cube(width - chamfer * 2, center = true);
  //    octahedron(chamfer);
  //  }
}

module number(i, xyz, a = 0) {
  rotate_to(xyz, a)
  translate([0, 0, width / 2 - depth + .01])
    linear_extrude(depth)
      text(str(i), fontsize, "Arial:style=Bold", halign = "center", valign = "center");
}

module month(m, xyz, first_half = true, a = 0) {
  halign = first_half ? "right": "left";
  dx = first_half ? width / 2 : -width / 2;
  rotate_to(xyz, a)
  translate([0, 0, width / 2 - depth + .01])
    linear_extrude(depth)
      translate([dx, 0, 0])
        //rotate([0,0,first_half? 0 : 180])
        translate([0, -width / 4 - monthsize / 2, 0])
          text(m, monthsize, "Arial:style=Bold", halign = halign, valign = "baseline");

}

module main(d = 40) {
  orientations = [
      [-1, 0, 0],
      [1, 0, 0],
      [0, -1, 0],
      [0, 1, 0],
      [0, 0, -1],
      [0, 0, 1],
    ];
  translate([-d, -d, 0]) rotate([-90, 0, 0])difference() {
    color("white") gube();
    color("black") for (i = [0:5]) {
      number([0, 5, 1, 4, 2, 3][i], orientations[i]);
    }
  }

  translate([d, -d, 0]) difference() {
    color("white") gube();
    color("black") for (i = [0:5]) {
      number([0, 8, 1, 7, 2, 6][i], orientations[i]);
    }
  }

  mont = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec",
    ];

  translate([-d, d, 0]) difference() {
    color("white") gube();
    color("black") for (i = [0:11]) {
      month(mont[i], orientations[i % 6], true, i < 6 ? 0 : 180);
    }
  }

  onths = [
    "",
    "uary",
    "ruary",
    "ch",
    "il",
    "e",
    "",
    "y",
    "ussy",
    "ust",
    "ember",
    "ober",
    ];

  translate([d, d, 0]) difference() {
    color("white") gube();
    color("black") for (i = [0:11]) {
      month(onths[i], orientations[i % 6], false, i < 6 ? 0 : 180);
    }
  }
}
t = 5;

module holder() {
  difference() {
    union() {
      //rotate([0, -30, 0]) translate([0,0,-.75*width]) cube([width + 2 * t, width * 2 + 2 * t, width/2 + t], center = true);
      color("red") cube([width + 2 * t, width * 2 + 2 * t, width * 2 + 2 * t]);
    }
    //hollow
    color("red") translate((t - slop / 2) * [1, 1, 1])
      cube([width + slop, width * 2 + slop, width * 2 + slop]);
    //front window
    color("red") translate([width, t, t] - (slop / 2) * [1, 1, 1])
      cube([width + slop, 2 * width + slop, 1.5 * width]);
    //back window
//    translate([width, t, t] - (slop / 2) * [1, 1, 1])
//      cube([width + slop, 2 * width + slop, 1.5 * width]);

    color("white") translate([2*t + width-depth, t + width, 1.5*t + 1.875 * width])
      rotate([90, 0, 90])
        linear_extrude(7)text("We were last", 10, "Arial:style=Bold", halign = "center", valign = "center");
    color("white") translate([2*t + width-depth, t + width, 1.5*t + 1.625 * width])
      rotate([90, 0, 90])
        linear_extrude(7)text("watered on...", 10, "Arial:style=Bold", halign = "center", valign = "center");
  }
}

module preview() {
  translate([width / 2 + t, width + t, width + t])rotate([90, 0, 90]) main(width / 2 + slop / 4);
  holder();
}

preview();
