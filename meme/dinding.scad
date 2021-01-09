$fa = .01;
$fs = $preview ? 1 : 1;


h1=27;
difference(){
    translate([-15.2,-15.26,0])
        import("dingding.stl", convexity=3);
    cylinder(r1=11.1,r2=10,h=h1*2, center=true);
    translate([0,0,h1])
        cylinder(r1=10,r2=0,h=11);
    //cube(100);
    //translate([-100,-100,0]) cube(100);
}
    