/*
    Its gonna be a hexagon, as close to spec as possible
 */

use <keycap_negative.scad>
$fa = 0.01;
$fs = 1;

difference(){
    translate([0,0,-5]) cylinder(h=6.25,d=25,$fn=6);
    keycap_negative();
}