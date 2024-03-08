Name = "_--_ _--_";
Fit_Width=true;
Layer = "All"; // ["All", "White", "Blue", "Gold", "Clip"]

module __Customizer_Limit__ () {}
slop=.1;
Width = 210;
Thickness = 1.4;
Height= 60;
Margin=7;
Font = "Verdana";
Widening=1.5;
Layers=2;

ep=$preview ? .1 : .01;
$fa=.01;
$fs=$preview ? 3 : 1;

module label(layer=1)
  translate([0,0,(layer-1)*Thickness])
    linear_extrude(Thickness)
      offset(r=(Layers-layer)*Widening) text(Name, size=Height-2*Margin, font=Font, halign="center", valign="center");


module base() translate([0,0,-Thickness]){
  linear_extrude(Thickness) square([Width, Height], center=true);
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
      offset(r=Thickness) square([Thickness, Height], center=true);
      offset(r=slop) square([Thickness, Height], center=true);
      square([4*Thickness, Height-4*Thickness], center=true);
    }

     difference(){
      offset(r=Thickness) trangle();
      trangle();
      translate([Height,0]) circle(r=Height,$fn=6);
    }
  }
}

module both(){
  if(Fit_Width){
    resize([0, 0, 2000+2*Thickness]) //scale only z
    resize([Width-2*Margin, 0, 0], auto=true){ //scale other dimensions to match width
      translate([0,0,-1000]) label(1);
      translate([0,0,1000]) label(2);
    }
  } else{
      translate([0,0,-1000]) label(1);
      translate([0,0,1000]) label(2);
  }
}

if(Layer=="All" || Layer=="White") color("white") base();

if(Layer=="All" || Layer=="Blue") color([12, 35, 64]/200) {
  intersection(){
    translate([0,0,1000]) both();
    cube(Width*2, center=true);
  }
}

if(Layer=="All" || Layer=="Gold") color([201, 151, 0]/255){
  intersection(){
    translate([0,0,-1000]) both();
    cube(Width*2, center=true);
  }
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
    translate([r1+r2+.4+Thickness,0,0]) cylinder(r=r2,h=.4);
    #translate([r1+.3,-.4,0]) cube([r2,.8,.2]);
  }
}

