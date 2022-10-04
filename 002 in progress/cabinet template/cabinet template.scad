$fa=.01; $fs=.1;

hole_spacing_minor=125.1;
hole_spacing_major=131.3;
hole_spacing=(hole_spacing_minor+hole_spacing_major)/2;
screw_od=4;
screw_id=3.4;
in_inches=screw_id/25.4*64;
echo("in_inches", in_inches);
inch=25.4;
//nvm

thickness=1.1;
drawer_h=161.3;
cabinet_x=53;
cabinet_y=135;



drill_d=1/8*inch;
function ceil_to(a,b) = ceil(a/b)*b;
w=ceil_to(hole_spacing, inch);
//difference(){
//  square([w, drawer_h], center=true);
//  for(i=[-1,1]) translate([i*hole_spacing/2,0]) circle(d=drill_d);
//  circle(d=drill_d);
//  translate([0,drawer_h/4])text(str("w=",ceil(hole_spacing/ inch),"\" h=6.35\""/*drawer_h/inch*/), halign="center", valign="center");
//  translate([0,-drawer_h/4])text(str("use 1/8\" bit"), halign="center", valign="center");
//}
rotate(90) difference(){
  square([cabinet_y*2,cabinet_x*2], center=true);
  for(i=[-1,1]) translate([i*hole_spacing/2,0]) circle(d=drill_d);
  translate([0,cabinet_x/2])text(str("for cabinet"), halign="center", valign="center");
  translate([0,-cabinet_x/2])text(str("use 1/8\" bit"), halign="center", valign="center");
}