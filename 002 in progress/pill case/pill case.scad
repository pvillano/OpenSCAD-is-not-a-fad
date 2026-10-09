$fa=.01;
$fs=1;

id=20;
od=75;
twt=2;
n=8;
h=20;
ep=.1;

difference(){
  cylinder(h=h,d=od);
  translate([0,0,-ep]) cylinder(h=h+2*ep,d=od-2*twt);
}
difference(){
  cylinder(h=h,d=id+2*twt);
  translate([0,0,-ep]) cylinder(h=h+2*ep,d=id);
}
for(i=[1:n]){
  rotate([0,0,i*360/n])
    translate([id/2,-twt/2,0])
      cube([(od-id)/2,twt,h]);
}
difference(){
  cylinder(h=twt,d=od);
  translate([0,0,-ep]) cylinder(h=twt+2*ep,d=id);
  translate([0,0,-ep]) difference(){
    translate([-od/2,0,0])cube([od,od/2,twt+2*ep]);
    rotate([0,0,360/n]) translate([-od/2,0,0])cube([od,od/2,twt+2*ep]);
  }
}