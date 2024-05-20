// It's gonna be a phone stand

unit = .6;
width = 3.5 * 25.4;
height = 83 * unit;
cell = 3;


module pairwise_hull() {
  if ($children > 1) {
    for (i = [0:1:$children - 2]) {
      hull() {
        children(i);
        children(i + 1);
      }
    }
  } else {
    children();
  }
}
module cx(w = 10) {
  square([0.000001, w]);
}
module cy(w = 10) {
  square([w, 0.000001]);
}
module cz(w = 10) {
  square([w, w]);
}
module greer() {
  translate([-20, -10, 0]) square(10);
  hull() {
    translate([10, 0, 0])cx(10);
    translate([-10, -10, 0]) cx(10);
  }
  translate([10, 0, 0]) square(10);
}

module reer() {
  render() difference() {
    square([40, 20], center = true);
    for (a = [0:45:90]) rotate(a)
      render() offset(delta = .3) greer();
  }
}
module joint() {
  linear_extrude(10 - .6) {
    offset(-.3)greer();
  }
  color("green")translate([0, 0, 10]) linear_extrude(10 - .6) mirror([0, 1, 0]) {
    offset(-.3)greer();
  }
}
mirror([0, 0, 1]) {
  joint();
  translate([-30, -10, 0]) joint();
  translate([-30, 10, 0]) mirror([0, 1, 0]) joint();
}