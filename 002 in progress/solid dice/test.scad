r = 10;
cut = 13;
slop = .15;
wall_thickness = 1;
module a() sphere(10, $fn = 12);
module b() hull() a();

//translate([0,0,h]) %a();

module base_shadow() {
  difference() {
    offset(wall_thickness) circle(r=r);
    //expansion gaps
    square([.6, 2 * r + 2 * wall_thickness], center = true);
    square([2 * r + 2 * wall_thickness, .6], center = true);
    //core
    circle(r = r / 2);
  }
}

//holder
render() difference() {
  union() {
    //base cylinder
    linear_extrude(cut) base_shadow();
    //rings
    for (a = [0:3]) rotate([0, 0, a * 90])  {
      //rings of flexture
      translate([r, r, 0]) difference() {
        cylinder(r = r - .3, h = 10);
        cylinder(r = r - .9, h = 10);
      }
      //support gussets
      hull(){
        translate([r+(r-.6)*sqrt(.5),r+(r-.6)*sqrt(.5)]){
          cylinder(d=.6,h=10);
          translate(1.5*[r,r])cylinder(d=8,h=1);
        }

      }
      //skirt
      linear_extrude(1) difference(){
        square(7*r,center=true);
        square(4*r+5,center=true);
      }
    }
  }
  //die with slop
  translate([0, 0, r]) scale((r + slop / 2) / (r)) b();
  linear_extrude(.2) offset(-.6) base_shadow();
}
//holder cones



//top half
*translate([0, 0, r]) render() difference() {
  scale(1) a();
  mirror([0, 0, 1]) linear_extrude(r) projection() b();
}
//bottom half
translate([200 - 2 * r, 0, 0]) rotate([180, 0, 0]) render() difference() {
  a();
  linear_extrude(r) offset(.1) projection() b();
}
