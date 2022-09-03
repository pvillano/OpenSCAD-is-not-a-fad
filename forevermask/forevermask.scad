
$fa=.01;
$fs= 1;
h=20;
w_img=183;
w_actual = 160;
module img(){
rotate([0,0,90])
scale(w_actual/w_img)
translate([-w_img/2,-65,0])
import("kn95.png.svg");
}
%color("black") translate([0,0,-1]) img();


mirror([1,0,0])
        linear_extrude(.2)
            text("forever", h, "Segoe Script:style=Regular", halign="center", valign="center");