r=11;
slop=.15;
wall_thickness=1;
$fn=12;
//from https://thangs.com/designer/varmfskii/3d-model/d120-876447
module a() sphere(10);
module b() hull() a();

//translate([0,0,h]) %a();

//holder
difference(){
  linear_extrude(r-.4) offset(wall_thickness) projection() b();
  //die with slop
  translate([0,0,r]) scale((r+slop/2)/(r)) b();
}
//top half
translate([0,0,r]) render() difference(){
  scale(1) a();
  mirror([0,0,1]) linear_extrude(r) projection() b();
}
//cone of go away
translate([200/2,200-2*r,0]) render() difference(){
  cylinder(r1=r,r2=r/2,h=r);
  cylinder(r1=r-.6,r2=r/2-.6,h=r);
}
//bottom half
translate([200 - 2*r,0,0]) rotate([180,0,0]) render() difference(){
  a();
  linear_extrude(r) offset(.1) projection() b();
}
