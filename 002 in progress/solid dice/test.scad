which = "preview"; // ["preview","top","bottom", "render"]

//exact maximum radius of the dice
r = 10;
//% up the die to cut
cut_height = .7; //[0:.01:1.0]
slop = .15; //[0:.01:.3]
max_overhang_deg = 30; //[0:90]
wall_thickness = 1.25;
bridge_width = 7;
box_width = 60;
extrusion_width = 1.25;
gap=1.5;

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

      //anchors
      mirror2([1, 1, 0]) linear_extrude(2*r*cut_height) square([gap+2*extrusion_width, box_width], center = true);
    }
    //cup
    translate([0, 0, r]) b();

    //cuts
    linear_extrude(r * 2 * cut_height + .1) {
      mirror2([1, 1, 0]) square([gap, box_width], center = true);
    }
  }

  //%translate([0, 0, r]) sphere(r = r);

  //box part
  difference() {
    linear_extrude(2 * r * cut_height) {
      square(box_width, center = true);
    }
    //main cavity
    translate([0, 0, .2]) linear_extrude(2 * r * cut_height) {
      square(box_width - 2 * wall_thickness, center = true);
    }

    //rib clearance
    mirror2([1,1,0]) linear_extrude(.3) square([box_width-2*wall_thickness, 3*gap+2*extrusion_width], center=true);
    //thingy enforcerclearance
    mirror2([1,1,0]) linear_extrude(2*r*cut_height) square([box_width-2*extrusion_width, gap], center=true);
    //center hole
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

render() if (which == "top") {
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
