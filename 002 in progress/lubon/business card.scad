use <lib.scad>;

tail_angle = 50;
foot_angle = 80;

deploy = .5; // [0:.2:1]

unit = .6;
width = 4 * 25.4;
pleat_count = 12;
thickness = 4.5;
cell = thickness + unit;
ideal_height = (thickness+unit)*pleat_count;
ideal_pleat_height = (ideal_height + unit) / pleat_count;
pleat_height = floor(ideal_pleat_height / .6) * .6;
height = pleat_height * pleat_count - unit;

//%cube(70);
//%mirror([1, 0]) render() bridge(90);
//gap(90);
//color("green") rotate(90) bridge(90);
tail_offset = [width, thickness];
module backbone() {
  mirror([1, 0])linear_extrude(height) gap(foot_angle, thickness);
  for (i = [0:pleat_count - 1]) translate([0, 0, i * pleat_height]) {
    if (i % 2 == 0) {
      linear_extrude(pleat_height - unit) {
        bridge(foot_angle, thickness);
      }
    }
  }
  translate(tail_offset) mirror([1, 0])linear_extrude(height) gap(tail_angle, thickness);
  translate(tail_offset) for (i = [0:pleat_count - 1]) translate([0, 0, i * pleat_height]) {
    if (i % 2 == 0) {
      linear_extrude(pleat_height - unit) {
        bridge(tail_angle, thickness);
      }
    }
  }
  translate([thickness*2, 0]) cube([width - thickness * 3, thickness, height]);
}

module tail() {
  translate(tail_offset) rotate([0, 0, -deploy * tail_angle]) {
    linear_extrude(height) gap(tail_angle, thickness);
    mirror([1, 0]) for (i = [0:pleat_count - 1]) translate([0, 0, i * pleat_height]) {
      if (i % 2 == 1) {
        linear_extrude(pleat_height - unit) {
          bridge(tail_angle, thickness);
        }
      }
    }
    translate([-width - 2 * thickness, 0]) cube([width + thickness, thickness, height]);
  }
}

module foot() rotate([0, 0, -deploy * foot_angle]) {
  linear_extrude(height) gap(foot_angle, thickness);
  mirror([1, 0]) for (i = [0:pleat_count - 1]) translate([0, 0, i * pleat_height]) {
    if (i % 2 == 1) {
      linear_extrude(pleat_height - unit) {
        bridge(foot_angle, thickness);
      }
    }
  }
  translate([2*thickness, -thickness]) cube([width / 5, thickness, height]);
}

color("red")backbone();
color("green") tail();
color("blue") foot();


