unit = .6;
width = 3.75 * 25.4;
pleat_count = 9;
thickness = 5;
cell = thickness + unit;
ideal_pleat_height = ((2 * 25.4) + unit) / pleat_count;
pleat_height = floor(ideal_pleat_height / .6) * .6;
height = pleat_height * pleat_count - unit;

module cx(w = cell) {
  square([0.000001, w]);
}
module cy(w = cell) {
  square([w, 0.000001]);
}
module cz(w = cell) {
  square([w, w]);
}
module greer() {
  translate([-2 * cell, -cell, 0]) square(cell);
  hull() {
    translate([cell, 0, 0])cx(cell);
    translate([-cell, -cell, 0]) cx(cell);
  }
  translate([cell, 0, 0]) square(cell);
}

module reer() {
  render() difference() {
    square([4 * cell - .6, 2 * cell - .6], center = true);
    for (a = [0:45:90]) rotate(a)
      render() offset(delta = .3) greer();
  }
}
module joint() {
  for (i = [0:pleat_count - 1]) translate([0, 0, i * pleat_height]) {
    if (i % 2 == 0) {
      linear_extrude(pleat_height - unit) {
        offset(-.3)greer();
      }
    } else {
      linear_extrude(pleat_height - unit) mirror([0, 1, 0]) {
        offset(-.3)greer();
      }
    }
  }
  linear_extrude(height) {
    reer();
    mirror([0, 1, 0]) reer();
  }
}
module main()
difference() {
  rotate(180)
    translate(-[-2 * cell + .3, cell + .3, 0])
      translate(-[width - 3.5 * cell, cell - .6, height] / 2)union() {
        joint();
        translate([1.5 * cell, .3, 0]) cube([width - 7 * cell, cell - .6, height]);
        translate([cell, -cell + .3, 0]) cube([width / 3 - 3 * cell, cell - .6, height]);
        translate([width - 4 * cell, cell, 0]) joint();
        translate([-2 * cell + .3, cell + .3, 0]) cube([width - 3.5 * cell, cell - .6, height]);
      }
  size = 5.7;
  strs = [
    "Peter (Rocky)Villano",
    "Software Developer",
    "peter@saej.in",
    "574-855-9777",
    "South Bend, Indiana"
    ];
  translate([-(width - 4 * cell) / 2, -cell / 2 + .3 + .4, 0]) rotate([90, 0, 0])linear_extrude(20) for (i = [0:len(strs
  ) - 1]) {
    dh = (-i + len(strs) / 2 - .5) / (len(strs)) * (height - size / 2);
    translate([0, dh, 0]) text(strs[i], size, halign = "left", valign = "center");
  }

}


module outline() offset(delta = -15) offset(delta = 15) projection() main();
translate([0,0,height/2]) main();
linear_extrude(.3) intersection() {
  difference() {
    offset(delta=3) outline();
    offset(delta=-.1) outline();
  }
  union() {
    for (dx = [0:5.1:width])
    translate([2-.57 * width + dx, 0]) square([1, 6 * cell], center = true);
    for (dy = [0:cell:4 * cell])
    translate([0, -1 * cell + dy]) square([1.4 * width, 1], center = true);
  }
}
linear_extrude(.6) difference() {
  offset(5) outline();
  offset(1.2)outline();
}