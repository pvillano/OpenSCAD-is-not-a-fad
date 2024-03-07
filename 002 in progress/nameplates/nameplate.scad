Name = "Your Name";
Width = 210;
Fit_Width=true;
Thickness = 1.5;
Height= 60;
Margin=7;
Font = "Arial";
Output = "Preview"; // ["Preview", "Base", "Label"]
module __Customizer_Limit__ () {}
ep=$preview ? .1 : .01;
$fa=.01;
$fs=3;
module label()
  translate([0,0,-Thickness/2-ep])
  linear_extrude(Thickness/2+ep)
  mirror([1,0,0])
  resize(Fit_Width ? [Width-2*Margin, 0] : [0,0] , auto=true)
  text(Name, size=Height-2*Margin, Font, halign="center", valign="center");

module base(){
  cube([Width, Height, Thickness], center=true); //backing
  translate([0,-Height/2,0])
    rotate([60,0,0])
    translate([-Width/2,0,-Thickness/2]) 
    cube([Width, Height*2/3, Thickness]); //foot
    
   translate([0,-Height/2, 0]) rotate([0,-90,0]) cylinder(h=Width, r=Thickness, center=true, $fn=3); //sharp corner
}
rotate([120,0,180]) 
if(Output=="Preview") {
    color("white") base();
    color("black") label();
} else if(Output == "Base"){
  difference(){
    base();
    label();
  }
} else if (Output == "Label") {
  label();
}
