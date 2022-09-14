
$fa=.01;
$fs= 1;
h=35;
angle=38.5;
%color("black") translate([0,0,-1]) cube([250,210,.01], center=true);
%color("green") translate([0,0,-.5]) cube([240,200,.01], center=true);
color("red")
mirror([1,0,0])
    resize([240,0,.2], auto=true)
        rotate([0,0,angle])
        linear_extrude(.2)
            text("INSECURITY", h, "Arial:style=Bold", halign="center", valign="center");
%color("blue")
mirror([1,0,0])
    resize([0,200,.2], auto=true)
        rotate([0,0,angle])
        linear_extrude(.2)
            text("INSECURITY", h, "Arial:style=Bold", halign="center", valign="center");