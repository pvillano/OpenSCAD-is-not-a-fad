$fa =.01;
$fs = .3;
w = 20;
h=10;
base_thickness=.55;
wall_thickness=1.28;
k = 4.67553009360455;
e = -1.5;
s = 92.5;//k * w + e;

linear_extrude(h+base_thickness){
  difference(){
    offset(wall_thickness) square(s, center=true);
    square(s, center=true);
  }
}

difference(){
  linear_extrude(base_thickness)
    offset(wall_thickness)
    square(s, center=true);
  translate([0,0, base_thickness-.3])
    linear_extrude(base_thickness)
    text(str(s), 10, halign="center", valign="center");
  }
