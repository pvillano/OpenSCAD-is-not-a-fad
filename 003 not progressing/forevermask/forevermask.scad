
$fa=.01;
$fs= 1;
mask_svg_w=183;
mask_w_actual = 160;


dx=-160;
dy=-170;
s=.5;
module img(){
    rotate([0,0,95])
    scale(mask_w_actual/mask_svg_w)
    translate([-mask_svg_w/2,-65,0])
    import("kn95.png.svg");
}
%translate([0,0,-1]) img();

//h=20;

//mirror([1,0,0]) linear_extrude(.2) text("forever", h, "Segoe Script:style=Regular", halign="center", valign="center");

//scale(s) translate([dx,dy,0])import("forever.svg");
mirror([1,0,0]) linear_extrude(.2) resize([95,0], auto=true)  translate([dx,dy,0])import("forever.svg");