w = 200;
h = 6;
d = 3;
linear_extrude(h, twist=180, slices=180)
  square([w,d], center=true);
