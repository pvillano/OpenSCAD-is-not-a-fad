use <threadlib/threadlib.scad>
$fa = .01;
$fs = $preview ? 10 :1;

width=210;
height=120;
thread_size=150;
thread_pitch=8;
higbee_arc=20;
intersection(){
    cylinder(h=height,d=width*2/sqrt(3),$fn=6);
    cylinder(d1=width,d2=width+height*2*sqrt(3),h=height);
    cylinder(d1=width+height*2*sqrt(3),d2=width,h=height);
    translate([0,0,-thread_pitch/2])
    nut(
        designator="M150x8",
        turns=height/thread_pitch+1,
        Douter=width*2/sqrt(3),
        higbee_arc=0,
        fn=(150*2*PI/$fs)
    );
}