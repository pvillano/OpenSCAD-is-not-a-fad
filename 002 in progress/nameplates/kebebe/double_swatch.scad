Width = 20;
LayerHeight=.2;
Roundover=3;
Layer = "All"; // ["All", "Top", "Bottom"]
module __Customizer_Limit__() {}
$fa=.01;
$fs=.1;

if(Layer == "All" || Layer == "Bottom")
  color("red")
    for(i=[1:4])
    translate([0,i*Width])
    linear_extrude(i*LayerHeight)
      offset(Roundover)
        square([Width-2*Roundover,Width-2*Roundover]);
if(Layer == "All" || Layer == "Top")
  color("orange")
    for(i=[0:3])
    translate([0,i*Width,i*LayerHeight])
    linear_extrude((4-i)*LayerHeight)
      offset(Roundover)
        square([Width-2*Roundover,Width-2*Roundover]);