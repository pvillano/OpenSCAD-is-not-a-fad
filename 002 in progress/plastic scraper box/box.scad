e = $preview ? .1 : .0001;
t = .6;
slop = .1;

blade = [40, 20, 1.37];
n_blades = 25;
blade_block = [blade.z * n_blades + slop, blade.y + slop, blade.x + slop];

d0 = blade_block; //inner shell inside
d1 = d0 + [2*t,2*t,0]; //inner shell
d2 = d1 + [slop,slop,0]; //outer shell inside
d3 = d2 + [2*t,2*t,4*t]; //outer shell outside

module bottom() {
  difference() {
    cube(d1 - [0,0,slop], center=true);
    cube(d0, center=true);
    translate([0,0,5]) cube(d0, center=true);
  }
  difference() {
    cube(d3, center=true);
    cube(d0, center=true);
    translate([0,0,d3.z/2-t+1]) cube(d3 + [2,2,2], center=true);
  }
}
module top() {
  difference() {
    cube(d3, center=true);
    cube(d2, center=true);
    translate([0,0,d3.z/2+1-t]) cube(d3 + [2,2,2], center=true);
  }
}
module fit_check(){
  intersection(){
    union(){
      bottom();
      mirror([0, 0, 1]) top();
    }
    union(){
      cube([100,1,100], center=true);
      cube([1,100,100], center=true);
    }
  }
}
top();