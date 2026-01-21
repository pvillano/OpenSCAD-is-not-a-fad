r=26;
slop=.15;
wall_thickness=1;
//from https://thangs.com/designer/varmfskii/3d-model/d120-876447
module a() import("d120.stl");
module b() hull() a();

//translate([0,0,h]) %a();

//holder
difference(){
  linear_extrude(r-slop) offset(wall_thickness) projection() b();
  translate([0,0,r]) scale((r+slop/2)/(r)) b();
}
//top half
translate([0,0,r]) render() difference(){
  scale(1) a();
  mirror([0,0,1]) linear_extrude(r) projection() b();
}
//bottom half
translate([200 - 2*r,-200+2*r,0]) rotate([180,0,0]) render() difference(){
  a();
  linear_extrude(r) projection() b();
}
