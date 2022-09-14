
$fa=.01;
$fs= 1;
h=100;
%color("black") translate([0,0,-1]) cube([250,210,.01], center=true);
mirror([1,0,0])
    resize([240,0,.2], auto=true)
        linear_extrude(.2)
            text("FUCK", h, "Arial:style=Black", halign="center", valign="center");