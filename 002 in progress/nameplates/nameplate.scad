Name = "_--_ _--_";
Fit_Width=true;
Layer = "All"; // ["All", "White", "Blue", "Gold", "Clip"]

module __Customizer_Limit__ () {}
slop=.1;
Width = 210;
BaseThickness = 1.4;
LabelThickness = .8;
Height= 55;
Margin=7;
Font = "Verdana";
Widening=1;
Layers=2;

ep=.01;
$fa=.01;
$fs=.5;

module label(layer=1)
  translate([0,0,(layer-1)*LabelThickness])
    linear_extrude(LabelThickness)
      offset(r=(Layers-layer)*Widening)
          resize([Width-2*Margin-2*LabelThickness, 0], auto=true)
              text(Name, size=Height-2*Margin, font=Font, halign="center", valign="center");


module base() translate([0,0,-BaseThickness]){
  linear_extrude(BaseThickness) square([Width, Height], center=true);
}

module trangle(){
  difference(){
      r=Height/sqrt(3);
      circle(r=r);
      for(a=[0,120,240]){
        rotate(a) translate([2*r*(2/sqrt(3)),0]) circle(r=2*r);
      }
    }
}

module clip(){
  linear_extrude(10){
    translate([.29*Height,0,0])difference(){
      offset(r=BaseThickness) square([BaseThickness, Height], center=true);
      offset(r=slop) square([BaseThickness, Height], center=true);
      square([4*BaseThickness, Height-4*BaseThickness], center=true);
    }

     difference(){
      offset(r=BaseThickness) trangle();
      trangle();
      translate([Height,0]) circle(r=Height,$fn=6);
    }
  }
}


if(Layer=="All" || Layer=="White") color("white") base();

if(Layer=="All" || Layer=="Blue") color([12, 35, 64]/200) {
  label(1);
}

if(Layer=="All" || Layer=="Gold") color([201, 151, 0]/255){
  label(2);
}

if(Layer=="All") color("white") {
  translate([-Width/3,1.5*Height]) clip();
  translate([Width/3,1.5*Height]) clip();
}

if(Layer=="Clip") color("white") {
  clip();
  r1=Height/sqrt(3);
  r2=5;
  for(a=[0,120,240])rotate([0,0,a+60]){
    translate([r1+r2+.8+BaseThickness,0,0]) cylinder(r=r2,h=.4);
    #translate([r1+.3,-.4,0]) cube([r2,1.2,.2]);
  }
}

