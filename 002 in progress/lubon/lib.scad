function find_bridge_angle (motion_range) = lookup(motion_range, [
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

module bridge(motion_range, thickness=10) {
  bridge_angle = find_bridge_angle(motion_range);
  l = 2*thickness / cos(bridge_angle) - thickness * tan(bridge_angle);
  circular_pattern(2){
    translate([thickness / 2 / cos(bridge_angle), 0]) square(thickness);
    translate([0, -thickness])
      rotate(-bridge_angle)
        translate([-thickness/2, l / 2])
          rotate(bridge_angle)
            square([thickness, thickness]);
  }
  rotate(-bridge_angle) square([thickness, l], center = true);
}
module gap(motion_range, thickness) {
  bridge_angle = find_bridge_angle(motion_range);
  mirror([1, 0]) difference() {
    bridge(motion_range, thickness);
    offset(delta = .3);
    for (z = [0, motion_range / 2, motion_range]) {
      rotate(-z)mirror([1, 0])bridge(motion_range, thickness);
    }
  }
}