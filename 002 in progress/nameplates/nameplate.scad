Name = "Your Name";
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


module base()translate([0,0,0-Thickness]){
  linear_extrude(Thickness) square([Width, Height], center=true);
}

module trangle(){
  difference(){
      r=Height/sqrt(3);
      circle(r=r);
      for(a=[0,120,240]){
        rotate(a)translate([2*r*(2/sqrt(3)),0]) circle(r=2*r);
      }
    }
}

module clip(){

  translate([0,1.5*Height,0]) linear_extrude(10){
    difference(){
      offset(r=Thickness) square([Thickness, Height], center=true);
      offset(r=slop) square([Thickness, Height], center=true);
      square([4*Thickness, Height-4*Thickness], center=true);
    }

    translate([-.29*Height,0,0]) difference(){
      offset(r=Thickness) trangle();
      trangle();
      translate([Height,0]) circle(r=Height,$fn=6);
    }
  }
}

//todo: this renders blue twice
if(Layer=="All" || Layer=="White") color("white") base();

if(Layer=="All" || Layer=="Blue") color([12, 35, 64]/200) resize(Fit_Width ? [Width-2*Margin, 0,0] : [0,0,0] , auto=true) {
  label(1);
}

if(Layer=="All" || Layer=="Gold") color([201, 151, 0]/255){
  intersection(){
    resize(Fit_Width ? [Width-2*Margin, 0,0] : [0,0,0] , auto=true) {
      translate([0, 0, -999]) label(1);
      label(2);
    }
    cube(Width*2, center=true);
  }
}

if(Layer=="All" || Layer=="Clip") color("white") {
  translate([-Width/3,0]) clip();
  translate([Width/3,0]) clip();
}

