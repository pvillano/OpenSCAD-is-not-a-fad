
segement_length=10;
thickness = 3;

function p2c(p) = [p.x * cos(p.y), p.x * sin(p.y)];
function c2p(c) = [sqrt(c.x * c.x + c.y * c.y), atan2(c.y, c.x)];
function cumsum(values, zero) = [for (a = 0, b = values[0]; a < len(values); a = a + 1, b = b + (values[a] == undef?zero:values[a
])) b];

turns = [0, 60, - 90, 60, 90, 60, - 90, 60, 90, - 60, 90, - 60, 90, 60];


cum_angles = cumsum(turns, 0);
inc_cart = [for (i = cum_angles) p2c([segement_length, i])];
cum = cumsum(inc_cart, [0,0]);
difference(){
    linear_extrude(thickness, center=true) translate([1.2,.85]*segement_length) rotate(90+45) offset(r=-.15) polygon(cum);
    rotate([0,180,0]) linear_extrude(thickness) translate([1.2,1.7]*segement_length) text(":)", .8*segement_length, halign="center", valign="center", font="Segoe UI");
}