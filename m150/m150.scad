$fa = .01;
$fs = $preview ? 30 : 1;

use <threadlib/threadlib.scad>
diameter=210;
height=120;//???
thread_size=150;
thread_pitch=8;
chamfer_angle = 22.5; //[15:30]


circumdiameter=diameter/cos(30); //corner to corner
intersection(){
	cylinder(d=circumdiameter,h=height, $fn=6);
	cylinder(d1=diameter+height/tan(chamfer_angle),d2=diameter,h=height);
	cylinder(d1=diameter,d2=diameter+height/tan(chamfer_angle),h=height);
	translate([0,0,-thread_pitch])
    nut(
        designator="M150x8",
        turns=height/thread_pitch+2,
        Douter=circumdiameter,
        higbee_arc=0,
        fn=(150*2*PI/$fs)
    );
}
//#cylinder(d=diameter,h=height);
//#cylinder(d=circumdiameter,h=height);
