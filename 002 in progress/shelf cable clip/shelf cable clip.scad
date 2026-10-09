shelf_thickness = 17;
compression = 10; // [0:180]
wall_thickness = 1.7;
height = 30;
length = 45;
mouse_ears = 10;

module _(){}
pi=3.1415;
circumference = shelf_thickness*pi;
wt=wall_thickness;
ir = shelf_thickness/2; //todo

module mirror2(xyz){
    children();
    mirror(xyz) children();
}

linear_extrude(height){
    
    difference(){
        // main ring
        circle(r=ir+wt);
        circle(r=ir);
        
        //cut out C shape
        intersection(){
            sq = ir+wt;
            rotate([0,0,-compression/2])
                translate([0,-sq,0])
                square([sq,2*sq]);
            rotate([0,0,compression/2])
                translate([0,-sq,0])
                square([sq,2*sq]);
        }
    }
    
    // legs
    mirror2([0,1,0])
        rotate([0,0,-compression/2])
        translate([0,ir,0])
        square([length,wt]);
}

if(mouse_ears > 0) color("green")linear_extrude(.2) {
    mirror2([0,1,0])
        rotate([0,0,-compression/2])
        translate([length+mouse_ears -wt/2,ir+wt/2,0])
        circle(r=mouse_ears);
}

//cube();