$fa=.01;
$fs=1;

od=190;
h=40;
epsilon=.2;
difference(){
  cylinder(d1=od,d2=0,h=h);
  for(i=[0,90,180]) rotate([0,0,i])
  translate([-epsilon/2,-epsilon/2,-.1]) cube([od/2+epsilon+.1,epsilon,h+.2]);
}
