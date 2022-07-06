
$fa=.01;
$fs= 1;
h=100;
//%color("black") translate([0,0,-1]) cube([250,210,.01], center=true);
mirror([1,0,0])
        linear_extrude(.2)
            text("forever", h, "Segoe Script:style=Regular", halign="center", valign="center");