$fa = .01;
$fs = .5;

circle_od = 189;//42 * sqrt(20);
h = 5;

module main() {

  render() intersection()
    {

      import("gf-rebuilt-baseplate-6x6-Thin-c09b9.stl");
      cylinder(d = circle_od, h = h);
    }
  render() difference() {
    cylinder(d = circle_od, h = h);
    translate([0, 0, 1.05])cylinder(d = circle_od - 4.3, h = h);
    cylinder(d2 = circle_od + .2, d1 = circle_od - 2 * h, h = h + .1);
    cylinder(d2 = circle_od - 4.3, d1 = circle_od - 4.3 - 2.1, h = 1.05);
    cylinder(d = circle_od - 5.7, h = h);
  }
}

intersection(){
  main();
//  union(){
//    cube([200, 10, 10], center = true);
//    cube([10, 200, 10], center = true);
//  }
}
