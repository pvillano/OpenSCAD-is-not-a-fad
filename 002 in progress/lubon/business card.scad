use <lib.scad>;

unit = .6;
width = 3.75 * 25.4;
pleat_count = 9;
thickness = 5;
cell = thickness + unit;
ideal_pleat_height = ((2 * 25.4) + unit) / pleat_count;
pleat_height = floor(ideal_pleat_height / .6) * .6;
height = pleat_height * pleat_count - unit;

//%mirror([1, 0]) render() bridge(90);
//gap(90);
//color("green") rotate(90) bridge(90);

module backbone(){
  mirror([1,0])linear_extrude(height) gap(90, thickness);
  for (i = [0:pleat_count - 1]) translate([0, 0, i * pleat_height]) {
    if (i % 2 == 0) {
      linear_extrude(pleat_height - unit) {
        bridge(90,thickness);
      }
    }
  }
  translate([10,0]) cube([width,thickness,height]);
}

backbone();