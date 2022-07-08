use <threads.scad>

//constants
$fa = .01;
$fs = $preview ? 3 : .3;
inch = 25.4;

//measurements
body_d = 46.3;//ste perimeters to very slow!!!
pipe_d = 1.98*inch;
thread_h = 11;
thread_d=20;
thread_safe_space = 2;

//params
ground_clearance=inch/4;
stick_out = 1.25*inch;
cut_off_ammount = 2.5*inch;


module bushing() difference(){
    *hull(){
        translate([0,0,1])cylinder(d=body_d,h=8);
        cylinder(d=body_d-2,h=10);
    }

    cylinder(d=20+2*1.67,h=10);
    ScrewHole(outer_diam=19.7, pitch=2, tolerance=0, height=14, position=[0,0,-2]);
}

module tray() {
    tray_len = 100;
    tray_h = 10;
    tray_w = inch*2;
    difference(){
        translate([0,-tray_w/2, 0]) cube([tray_len, tray_w,10]);
        #translate([-.1,0,inch]) rotate([0,90,0]) cylinder(h=tray_len+.2,d=body_d);
        difference() rotate([0,90,0]){

        }
    }
}

module pipe_rig(){
    backstop=inch/4;
    difference(){
        translate([0,-inch])cube([inch*2, inch*2,inch/2]);
        #translate([backstop,0,pipe_d/2]) rotate([0,90,0]) cylinder(d=pipe_d, h=99);
    }
}
//bushing();
//tray();

pipe_rig();

