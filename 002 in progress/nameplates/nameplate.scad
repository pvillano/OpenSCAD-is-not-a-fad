Name = "Your Name";
Fit_Width=true;
module __Customizer_Limit__ () {}
slop=.1;
Width = 210;
Thickness = 1.5;
Height= 60;
Margin=7;
Font = "Verdana";
Widening=1;
Layer = 1; // [1,2,3]
Layers=2;

ep=$preview ? .1 : .01;
$fa=.01;
$fs=$preview ? 99 : 1;


module pyramid(h=3) hull(){
  linear_extrude(.2) children();
  translate([0,0,-h]) linear_extrude(.2) offset(-h) children();
}

module label(layer=1)
  translate([0,0,(layer-1)*Thickness])
    linear_extrude(Thickness)
      offset(r=(Layers-layer)*Widening) text(Name, size=Height-2*Margin, font=Font, halign="center", valign="center");


module tab(tab_width){
  difference(){
    hull(){
      linear_extrude(.2) square([tab_width, Height-sqrt(3)*Thickness]);
      translate([0,0,Thickness-.2]) linear_extrude(.2) square([tab_width, Height]);
    }
    n=3;
    for(i=[0:n-1]){
      translate([i*tab_width/n,0,-ep]) cube([tab_width/n/2+slop,Thickness*2,Thickness+2*ep]);
    }
  }
}

module base()translate([0,0,0-Thickness]){
  tab_width = Height/2;
  hull(){
    linear_extrude(.2) square([Width, Height-2*sqrt(3)*Thickness], center=true);
    translate([0,0,Thickness-.2]) linear_extrude(.2) square([Width, Height], center=true);
  }
  for(a=[0,180]) rotate([0,0,a]){
    translate([Width / 2 - tab_width, -1.5 * Height, 0]) tab(tab_width);
    translate([Width / 2, 1.5 * Height, 0])rotate([0, 0, 180]) tab(tab_width);
  }

//  translate([Width/2+r/2,0]) pyramid() circle(r=r, $fn=3);
}

//color("white") base();
//resize(Fit_Width ? [Width-2*Margin, 0,0] : [0,0,0] , auto=true) {
//  color([12, 35, 64]/255) label(1);
//  color([201, 151, 0]/255) label(2);
//}
color("white") base();
scale(.5) {
  color([12, 35, 64]/255) label(1);
  color([201, 151, 0]/255) label(2);
}