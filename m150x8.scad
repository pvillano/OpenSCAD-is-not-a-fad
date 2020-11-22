use <threadlib/threadlib.scad>
$fa = .01;
$fs = $preview ? 10 :1;

width=210;
height=120;
thread_size=150;
thread_pitch=8;
intersection(){
    difference(){
        cylinder(h=height,d=width*2/sqrt(3),$fn=6);
        tap("M150x8",turns=height/thread_pitch, fn=(150*2*PI/$fs));
    }
    cylinder(d1=width,d2=width+2*100,h=100*tan(30));
    cylinder(d1=width+2*100,d2=width,h=100*tan(30));
}