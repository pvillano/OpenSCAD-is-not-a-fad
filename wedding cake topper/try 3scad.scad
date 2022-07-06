$fa = .01;
$fs = $preview ? 5 : .5;

thickness=7;

skewer_diameter=2;//?

difference(){
    intersection(){
        cube([250,200,10]);
        
        translate([-30,-17,0])
            linear_extrude(thickness, convexity=3)
            scale(1.8)
            import("carrying2.svg");
    }
    translate([115,-1,thickness/2])
        rotate([-90,0,0])
        cylinder(d=1.8,h=150);
    translate([136,-1,thickness/2])
        rotate([-90,0,0])
        cylinder(d=1.8,h=150);
}
//cube([134,5,5]);