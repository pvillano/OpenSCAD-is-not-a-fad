$fa=.01;
$fn=16;

PhoneWidth = 76;
PhoneHeight = 157;
PhoneThickness = 12.4;
CenterOfMassCompensation=[1,2];
t=PhoneThickness;

od=PhoneHeight+2*t;
oh=PhoneWidth+4*t;
difference(){
  cylinder(d=od,h=oh, center=true);
  translate(CenterOfMassCompensation) linear_extrude(oh+.2, center=true){
    translate([-PhoneThickness/2,-PhoneWidth/2]) square([od/2,od]);
    translate([PhoneThickness/2,-od/2-5]) square([od/2,od+10]);
    translate([-od/2,od/6]) square([od,od/3]); //chop off top
    translate([PhoneThickness/2+t,-od/2]) square([od/2,od]);
  }
  pw=PhoneWidth+3; //lots of slop
  g=40;
  translate(CenterOfMassCompensation)  hull(){
    translate([-PhoneThickness/2,-od/2+1*t,-pw/2]) cube([od/2,od, pw]);
    translate([-PhoneThickness/2+g/2,-od/2+1*t,-pw/2-g/2]) cube([od/2,od, pw+g]);
  }
}