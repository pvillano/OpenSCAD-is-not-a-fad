h = 50;
bed_dim = 200;
margin = 10;
diameters = (bed_dim - 2 * margin) / 2;

// https://gist.github.com/anoved/9622826?permalink_comment_id=4384183#gistcomment-4384183
module star(p = 5, r1 = 4, r2 = 10) {
  s = [for (i = [0:p * 2])
      [
        (i % 2 == 0 ? r1 : r2) * cos(180 * i / p),
        (i % 2 == 0 ? r1 : r2) * sin(180 * i / p)
      ]
    ];

  polygon(s);
}

module spiral(rotations = 4, d = diameters, fn = 90) {
  d = d * rotations/(rotations+.5);
  n = 360 * rotations;
  d_inner = d / (rotations) / 2 / 2/2;
  angle_step = 360 / fn;
  union() for (i = [0:angle_step:n - angle_step]) {
    hull() {
      rotate(i) translate([i * d / n / 2 + d_inner, 0]) circle(d_inner);
      rotate(i + angle_step) translate([(i + angle_step) * d / n / 2 + d_inner, 0]) circle(d_inner);
    }
  }
}

$fa = .01;
$fs = 1;

linear_extrude(h) {
  dx = bed_dim / 4;
  translate([-dx, -dx]){
    difference(){
      circle(d = diameters);
      spiral(d=diameters-5);
    }
  }
  translate([-dx, dx]) circle(d=diameters, $fn=3);
  translate([dx, -dx]) star(7, diameters / 2, 8.0);
  translate([dx, dx]) offset(diameters / 4) square(diameters / 2, center = true);
}
