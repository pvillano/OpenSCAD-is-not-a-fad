which = "preview"; // ["preview","top","bottom", "render"]

//exact maximum radius of the dice
r = 10;
//% up the die to cut
cut_height = .7; //[0:.01:1.0]
slop = .15; //[0:.01:.3]
max_overhang_deg = 30; //[0:90]
wall_thickness = 1;
bridge_width = 7;
box_width = 60;

module a() sphere(10, $fn = 12);
module b() hull() a();

module mirror2(xyz) {
  children();
  mirror(xyz) children();
}

module top_half() {

  //cup;
  difference() {
    union() {
      //conic part
      intersection() {
        cylinder(
        r1 = r * tan(max_overhang_deg / 2) + wall_thickness,
        r2 = r / sin(max_overhang_deg) + wall_thickness,
        h = r);
        cylinder(r = r + wall_thickness, h = r * 2 * cut_height);
      }
      //cylindrical part
      if (cut_height > .5)
        translate([0, 0, r])
          cylinder(r = r + wall_thickness, h = r * 2 * (cut_height - .5));

      //bridges
      mirror2([1, 0, 0])
      translate([0, 0, r * 2 * cut_height])
        mirror([0, 0, 1])
          linear_extrude(.2)
            hull()
              mirror2([1, 1, 0])
              translate([-box_width / 2, -box_width / 2])
                square(sqrt(.5) * bridge_width);
      //anchors
      mirror2([1, 0, 0]) rotate(45) linear_extrude(.2) square([1.2, 2 * r + 4], center = true);
    }
    //cup
    translate([0, 0, r]) b();

    //cuts
    linear_extrude(r * 2 * cut_height + .1) {
      mirror2([1, 1, 0]) square([1.2, 2 * r + 2 * wall_thickness + .2], center = true);
    }
  }

  //%translate([0, 0, r]) sphere(r = r);

  difference() {
    linear_extrude(2 * r * cut_height) {
      square(box_width, center = true);
    }
    translate([0, 0, .2]) linear_extrude(2 * r * cut_height) {
      square(box_width - 2 * wall_thickness, center = true);
    }
    cylinder(r = r, h = 2, center = true);
  }

  //top half
  render() difference() {
    translate([0, 0, r]) a();
    linear_extrude(r * 2 * cut_height + .4) projection() b();
  }
}

module bottom_half() {
  //bottom half
  rotate([0, 180, 0])render() difference() {
    translate([0, 0, r - (2 * r * cut_height + .4)]) a();
    linear_extrude(r * 2 * (1 - cut_height)) offset(.1) projection() b();
  }
}

if (which == "top") {
  top_half();
} else if (which == "bottom") {
  bottom_half();
} else if (which == "preview") {
  top_half();
  translate([box_width / 2 + r + 10, 0, 0]) bottom_half();
} else {
  translate([box_width / 2, 200 - box_width / 2.0]) top_half();
  translate([200 - r, 200-r, 0]) bottom_half();
}
