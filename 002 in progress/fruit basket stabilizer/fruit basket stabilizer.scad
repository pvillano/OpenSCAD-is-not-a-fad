slop=.1;

thickness = 17.3+slop;
h1 = 13+slop;
h2 = 24+slop;
difference(){
  cube([3*thickness, 3*thickness, h2]);
  translate([thickness,-.1,-.1]) cube([thickness, 3*thickness+.2, h1+.1]);
  translate([-.1,thickness,h1]) cube([3*thickness+.2, thickness, h2-h1+.1]);
  translate([thickness,thickness,-.1]) cube([2*thickness+.1, thickness, h2+.2]);

  hull() translate([thickness,-.1,-.1]) for(i=[0:45])rotate([0,i,0]) cube([thickness, 3*thickness+.2, h1+.1]);
}