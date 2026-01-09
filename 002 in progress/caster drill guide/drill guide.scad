hole_d = 3.2;
dxdy_wrong = [24, 30];
dxdy = [17.0 + 25.2, 33.2 + 28.8] / 2; //[21.1 ,31]
outer_dims = [33, 40];
radius = 25;


module mirror2(xyz) {
  children();
  mirror(xyz) children();
}

linear_extrude(6)
  translate([dxdy.y / 2 - dxdy_wrong.x / 2, dxdy.x / 2 - dxdy_wrong.y / 2]) {
    difference() {
      square([28.5, 29.45] * 2, center = true);
      rotate([0, 0, 90])mirror2([1, 0, 0]) mirror2([0, 1, 0]) translate(dxdy / 2) circle(d = hole_d);
    }
  }

//translate([0, 0, -1]) linear_extrude(1) difference() {
//  square(25 * 2, center = true);
//  circle(10);
//  mirror2([1, 0, 0]) mirror2([0, 1, 0]) translate([24, 30] / 2) circle(d = 4);
//}
