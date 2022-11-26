/*

WIP

The idea is to have three parts:

* a base consisting of a male thread that can be stretched and fit snugly around the can
* a lid that attatches to the base
with an offset hole that uncovers the original holes in the can
and goes to the edge of the can
* a rotating insert that fits in the lid with another offset hole
that can be used to cover or uncover the holes of the original can
 */



use <threads.scad>

$fa = .01;
$fs = 3;
lip_diameter=104;
lip_height=4;
can_diameter=100;
inner_diameter=98;
wall_thickness=2;
pitch=2;
thread_margin=sqrt(3)*pitch;
module base(){
    difference(){
        translate([0,0,-wall_thickness]) ScrewThread(outer_diam=lip_diameter+2*wall_thickness+thread_margin, height=lip_height+wall_thickness, pitch=2,tolerance=0.4);
        //translate([0,0,-wall_thickness])cylinder(d=lip_diameter+2*wall_thickness,h=lip_height+2*wall_thickness);
        cylinder(d=lip_diameter, h=lip_height+.1);
        translate([0,0,-wall_thickness-.01])cylinder(d=can_diameter,h=22);
        translate([0,0,-wall_thickness-.01])cube([can_diameter,.5,can_diameter]);
    }


}
module insert(){
    insert_d=.66*inner_diameter;
    difference(){
        union() {
            cylinder(d1=insert_d,d2=insert_d-2*wall_thickness,h=wall_thickness);
            cylinder(d2=insert_d,d1=insert_d-2*wall_thickness,h=wall_thickness);
        }

        translate([insert_d/4,0,-.01]) cylinder(d=insert_d/2-2*wall_thickness,h=wall_thickness+.02);
        translate([-insert_d/4,0,wall_thickness/2]) cylinder(d=insert_d/2-2*wall_thickness,h=wall_thickness+.02);
    }

}

module lid() {

}
base();

//insert();