$fa = .01;
$fs = 1;

inch = 25.4;

rod_diameter = 22;
paper_towel_height = 11 * inch;
paper_towel_diameter = 150;

magnet_1_dims = [62, 31];
magnet_1_holes = [[magnet_1_dims.x - 17, 7.5], [magnet_1_dims.x - 50.5, 8.5]];
magnet_2_dims = [68, 30];
magnet_2_holes = [[magnet_2_dims.x - 3.5, 7], [magnet_2_dims.x - 65, 6]];
magnet_margin = 1;

magnet_space = [
    max(magnet_1_dims.x, magnet_2_dims.x) + 2 * magnet_margin,
    max(magnet_1_dims.y, magnet_2_dims.y) + 2 * magnet_margin,
  ];

magnet_thickness = max(5, 6);
screw_d = 3;
screw_h = 13;
twt = 2.5;
shadow_line = 1.5;

module magnet_test() {
  difference() {
    linear_extrude(2) square(magnet_space + 2 * twt * [1, 1], center = true);
    // screw holes
    mirror([1,0,0]){
      translate(magnet_1_holes[0] - .5 * magnet_1_dims) cylinder(d = screw_d, h = screw_h);
      translate(magnet_1_holes[1] - .5 * magnet_1_dims) cylinder(d = screw_d, h = screw_h);
      rotate(180) translate(magnet_2_holes[0] - .5 * magnet_2_dims) cylinder(d = screw_d, h = screw_h);
      rotate(180) translate(magnet_2_holes[1] - .5 * magnet_2_dims) cylinder(d = screw_d, h = screw_h);
    }
    // rod test fit
    cylinder(h = magnet_space.y + 2 * twt + .2, d = rod_diameter, center = true);
  }
}

module main() {
  h = 85;
  difference() {
    hull() {
      linear_extrude(magnet_thickness) offset(twt) square(magnet_space, center = true);
      translate([0, 0, h])
        rotate([-90, 0, 0])
          cylinder(h = magnet_space.y/2 + twt, d = rod_diameter + 2 * twt);
    }
    //hole for rod
    translate([0, 0, h])
      rotate([90, 0, 0])
        cylinder(h = magnet_space.y + 2 * twt + .2, d = rod_diameter, center = true);
    //empty space for magnets - shadow line!!!
    translate([0,0,-.1]) linear_extrude(magnet_thickness-shadow_line) square(magnet_space, center = true);
    // screw holes
    mirror([1,0,0]){
      translate(magnet_1_holes[0] - .5 * magnet_1_dims) cylinder(d = screw_d, h = screw_h);
      translate(magnet_1_holes[1] - .5 * magnet_1_dims) cylinder(d = screw_d, h = screw_h);
      rotate(180) translate(magnet_2_holes[0] - .5 * magnet_2_dims) cylinder(d = screw_d, h = screw_h);
      rotate(180) translate(magnet_2_holes[1] - .5 * magnet_2_dims) cylinder(d = screw_d, h = screw_h);
    }
  }

  translate([0, 0, h]) rotate([- 90, 0, 0])%cylinder(h = paper_towel_height, d = paper_towel_diameter);
}
main();