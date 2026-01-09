hole_d = 4;
dxdy = [24,30];
outer_dims = [33,40];
radius = 25;


module mirror2(xyz){
  children();
  mirror(xyz) children();
}

linear_extrude(1) difference(){
  square(radius*2, center=true);
  mirror2([1,0,0]) mirror2([0,1,0]) translate(dxdy/2) circle(d=hole_d);
}
