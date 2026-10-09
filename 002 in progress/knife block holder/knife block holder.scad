ep = $preview ? .1 : .01;
$fa = .01;
$fs = .5;
/* [Measured Dimensions] */
sharpener_dimensions = [203.5, 70, 7.8];

/* [Design Dimensions] */
side_wall_thickness = 3;
elevation = 45;
incline = 75;
margin = 50;
bed_size = [200, 200];
overlap = .8; // [0:1:.1]
thumb_hole = 25;

module cube_xy(xyz) {
  linear_extrude(xyz.z)
    square(xyz.xy, center = true);
}

difference() {
  union() {
    hull() {
      translate([0, 0, -(1 - overlap) * sharpener_dimensions.z])
        cube_xy(sharpener_dimensions + side_wall_thickness * [2, 2, 0]);
      translate([0, 0, -elevation])
        cube_xy([sharpener_dimensions.x, sharpener_dimensions.y, ep]
          + side_wall_thickness * [2, 2, 0]
          + cos(incline) * elevation * [2, 2, 0]);
    }
  }
  //block
  cube_xy(sharpener_dimensions);
  // thumb holes
  for (t = [0:3]) {
    ij = [[1, 0], [0, 1], [-1, 0], [0, -1],][t];
    translate([ij.x * sharpener_dimensions.x / 2, ij.y * sharpener_dimensions.y / 2, 0]) {
      sphere(d = thumb_hole);
      rotate([90, 0, 90 * t + 90]) cylinder(d = thumb_hole, h = 20);
      cylinder(d = thumb_hole, h = 20);
      rotate([90, 0, 90 * t + 90]) translate([0, thumb_hole / 2, thumb_hole / 2]) cube(thumb_hole, center = true);
    }
  }

}