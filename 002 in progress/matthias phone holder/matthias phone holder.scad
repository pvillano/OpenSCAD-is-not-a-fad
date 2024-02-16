$fa=.01+0;

PhoneWidth = 76;
PhoneHeight = 157;
PhoneThickness = 12.4;
t=4;

fn=25;
center_adjust=28;//hack because math is hard
arc_start_adjust=5; //[-50:50]
$fn=fn;
pw=PhoneWidth+3; //lots of slop
od=PhoneHeight+2*t;
oh=pw+2/sqrt(3)*PhoneThickness+2*t;

module mirror2(xyz){
  children();
  mirror(xyz) children();
}


module v0() difference(){
  union(){
    intersection(){
       //coney bits
      gg = od/(2*sqrt(3)) - .1;
      rotate([0,0,arc_start_adjust*360/100/fn]) mirror2([0,0,1]) translate([0,0,-oh/2])cylinder(d1=od, d2=od-2*sqrt(3)*gg,h=gg);
      //top slope
      mirror2([0,0,1]) hull(){
        translate([0,0,oh/2])linear_extrude(.01, center=true) hull(){
          translate([0,-(5/6)*od,0]) square(od);
          translate([-od/2,-od,0])square(od);
        }
        translate([0,0,-oh/2])linear_extrude(.01, center=true) offset(delta=-1*oh) hull(){
          translate([0,-1/6*od,0]) mirror([0,1,0]) square(od);
          translate([-od/2,-od,0]) mirror([0,1,0]) square(od);
        }
      }
    }
    intersection(){
      rotate([0,0,arc_start_adjust*360/100/fn]) cylinder(d=od,h=oh, center=true);
      translate([0,-center_adjust-od/2,0]) cube([PhoneThickness+2*t,od,oh], center=true);
    }
  }
  linear_extrude(oh+.2, center=true){
    translate([-PhoneThickness/2,-PhoneWidth/2]) square([od/2,od]); //landscape mode shelf
    translate([PhoneThickness/2,-od/2-5]) square([od/2,od+10]);
    translate([-od/2,od/6]) square([od,od/3]); //chop off top
  }
  g=40;
  hull(){
    translate([-PhoneThickness/2,-PhoneHeight/2,-pw/2]) cube([od/2,PhoneHeight, pw]);
    translate([-PhoneThickness/2+g/2*sqrt(3),-PhoneHeight/2,-pw/2-g/2]) cube([od/2,PhoneHeight, pw+g]);
  }
}


render() v0();