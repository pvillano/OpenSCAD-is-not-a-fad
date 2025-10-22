$fa=.01+0;
$fs=1+0;
/* [Base ring dimensions] */
id = 35;
od = 65;
h_base = 2;
/* [Design parameters] */
d=200;

intersection(){
  //print volume
  translate([0,0,-h_base]) cylinder(d=205,h=205);
  union(){
    //base ring
    translate([0, 0, -h_base / 2]) difference() {
      cylinder(d = od, h = h_base, center = true);
      cylinder(d = id, h = h_base + .2, center = true);
    }
    //ice cream
    translate([0,0,d/sqrt(2)-od/2]) sphere(d=d);
    //cone
    cylinder(d1=0+od,d2=d/sqrt(2),h=d/2/sqrt(2)-od/2);
  }
}
