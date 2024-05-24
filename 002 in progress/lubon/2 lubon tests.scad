motion_range = 80;
bridge_angle = lookup(motion_range, [
    [0, 0],
    [10, 36],
    [30, 45],
    [60, 56],
    [90, 65.70485],
    [120, 75]
  ]);

module circular_pattern(n) {
  for (i = [0:n - 1]) {
    rotate(i * 360 / (n)) children();
  }
}

module bridge(bridge_angle) {
  l = 20 / cos(bridge_angle) - 10 * tan(bridge_angle);
  circular_pattern(2){
    translate([5 / cos(bridge_angle), 0]) square(10);
    translate([0, -10])
      rotate(-bridge_angle)
        translate([-5, l / 2])
          rotate(bridge_angle)
            square([10, 10]);
  }
  rotate(-bridge_angle) square([10, l], center = true);
}
module gap(motion_range, bridge_angle) {
  mirror([1, 0]) difference() {
    bridge();
    offset(delta = .3);
    for (z = [0, motion_range / 2, motion_range]) {
      rotate(-z)mirror([1, 0])bridge();
    }
  }
}
%mirror([1, 0]) render() bridge();
gap();
color("green") rotate(motion_range) bridge();