$fa = .01;
$fs = $preview ? 5 : .1;

thickness=5;


skewer_diameter=2.3;//?
l=64/2;
difference(){
    intersection(){
        cube([250,200,10]);
        
        translate([-30,-17,0])
            linear_extrude(thickness, convexity=3)
            scale(1.3)
            import("carrying2.svg");
    }
    translate([65,-1,thickness/2])
        rotate([-90,0,0])
        cylinder(d=1.8,h=l);
    translate([87,-1,thickness/2])
        rotate([-90,0,0])
        cylinder(d=1.8,h=l);
}
//cube([134,5,5]);