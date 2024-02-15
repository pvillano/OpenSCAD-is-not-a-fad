$fa=.01;
$fn=25;

PhoneWidth = 76;
PhoneHeight = 157;
PhoneThickness = 12.4;
CenterOfMassCompensation=[1,2];
t=4;

pw=PhoneWidth+3; //lots of slop
od=PhoneHeight-CenterOfMassCompensation.y+2*t;
oh=pw+2/sqrt(3)*PhoneThickness+2*t;
difference(){
  cylinder(d=od,h=oh, center=true);
  translate(CenterOfMassCompensation) linear_extrude(oh+.2, center=true){
    translate([-PhoneThickness/2,-PhoneWidth/2]) square([od/2,od]); //landscape mode shelf
    translate([PhoneThickness/2,-od/2-5]) square([od/2,od+10]);
    translate([-od/2,od/6]) square([od,od/3]); //chop off top
  }
  g=40;
  translate(CenterOfMassCompensation)  hull(){
    translate([-PhoneThickness/2,-PhoneHeight/2,-pw/2]) cube([od/2,PhoneHeight, pw]);
    translate([-PhoneThickness/2+g/2*sqrt(3),-PhoneHeight/2,-pw/2-g/2]) cube([od/2,PhoneHeight, pw+g]);
  }
}