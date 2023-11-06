$fa =.01;
$fs = 1;

inch = 25.4;

rod_diameter = 22;
paper_towel_height = 11 * inch;
paper_towel_diameter = 150;

magnet_1_dims = [62, 31];
magnet_1_holes = [[magnet_1_dims.x - 17, 7.5], [magnet_1_dims.x - 50.5, 8.5]];
magnet_2_dims = [68, 30];
magnet_2_holes = [[magnet_2_dims.x - 3.5, 7], [magnet_2_dims.x - 64.5, 6]];
magnet_margin = 1;
magnet_space = [max(magnet_1_dims.x, magnet_2_dims.x) + 2 * magnet_margin, max(magnet_1_dims.y, magnet_2_dims.y) + 2 *
  magnet_margin];

screw_d = 2.8;

twt = 2;

module magnet_test() {
  linear_extrude(3) difference() {
    square(magnet_space, center = true);
    translate(magnet_1_holes[0]  - .5*magnet_1_dims) circle(d = screw_d);
    translate(magnet_1_holes[1]  - .5*magnet_1_dims) circle(d = screw_d);
    rotate(180)translate(magnet_2_holes[0]  - .5*magnet_2_dims) circle(d = screw_d);
    rotate(180)translate(magnet_2_holes[1]  - .5*magnet_2_dims) circle(d = screw_d);
  }
}



magnet_test();

module main() {
  h = 4 * inch;
  difference() {
    hull() {
      cube([h, inch, 0.01], center = true);
      translate([0, 0, h])
        rotate([90, 0, 0])
          cylinder(h = inch, d = 1.25 * inch, center = true);
    }
    translate([0, 0, h])
      rotate([90, 0, 0])
        cylinder(h = inch + .2, d = rod_diameter, center = true);
    cube([2, inch + .2, h * 2], center = true);
  }

  translate([0, 0, h]) rotate([- 90, 0, 0])%cylinder(h = paper_towel_height, d = paper_towel_diameter);
}
