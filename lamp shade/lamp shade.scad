$fa = .01;

$fs = $preview ? 10 : 3;

d_inner = 240;
d_outer = 244;
d_rim = 255;
h_insert = 20;
h_dtent = 10;


module third(r = 9000) {
    intersection() {
        translate([4500, 0, 0])cube(9000, center = true);
        rotate([0, 0, 60])translate([4500, 0, 0])cube(9000, center = true);
        children();
    }
}

//module sphere_part() {
//    third() scale([1, 1, .5]) intersection() {
//        sphere(d = d_rim);
//        cylinder(h = d_rim, d = d_rim);
//    }
//}

module sphere_part() {
    scale([1, 1, .5]) intersection() {
        #sphere(d = d_rim);
        cylinder(h = d_rim, d = 2/sqrt(3)*200, $fn=6);
    }
}
module inside_part() {
    scale([.95, .95, .45]) intersection() {
        sphere(d = d_rim);
        cylinder(h = d_rim, d = d_rim);
    }
}

//inside_part();

intersection(){
    sphere(d=d_outer);
    translate([0,0,210/2])cube([250,210,210], center=true);
}

third(){
    //	union(){
    //		cylinder(h=h_insert, d=d_inner);
    //		difference(){
    //			cylinder(h=h_dtent, d=d_outer);
    //			for(i=[120:120:360])
    //				translate([0,0,-.1*d_outer])
    //				rotate([0,0,i])
    //				scale([1,2,1])
    //				rotate([45,0,0])
    //				cube([d_rim,d_rim,d_rim]);
    //		}
    //
    //		translate([0,0,h_insert])
    //			scale([1,1,.5])
    //			intersection()
    //		{
    //				sphere(d=d_rim);
    //				cylinder(h=d_rim,d=d_rim);
    //		}
    //	}
}