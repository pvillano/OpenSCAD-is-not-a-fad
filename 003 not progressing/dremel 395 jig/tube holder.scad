$fa =.01;
$fs = $preview ? 3 : .3;

inch = 25.4;

tube_d = 1.98 * inch;

slop = .1; //4.9 in a 5.0 hole

margin=5;
thickness = 5;
degrees_clamp = 3;

//difference(){
//    cube([tube_d+margin*2+slop, tube_d+margin*2+slop, thickness], center=true);
//    cylinder(d=tube_d+slop,h=thickness+.2, center=true);
//    translate([0,0,-thickness/2-.1])intersection(){
//        rotate([0,0,degrees_clamp/2]) cube([tube_d+margin,tube_d+margin,thickness+.2]);
//        rotate([0,0,90-degrees_clamp/2]) cube([tube_d+margin,tube_d+margin,thickness+.2]);
//    }
//}
module dupmirror(xyz){
    children();
    mirror(xyz) children();
}

difference(){
    twt=1.67;
    l=20;
    gap=1;
    platform=5;
    hull(){
        cylinder(d=tube_d+twt*2,h=l);
        translate([-twt-.1,0,0]) cube([twt*2+.2,tube_d/2+twt+platform,l]);
    }
    translate([0,0,-.1])cylinder(d=tube_d, h=999);
    translate([-gap/2,0,-.1]) cube([gap,999,999]);
    for(h=[.25,.75]*l) dupmirror([1,0,0]){
        #translate([0,tube_d/2+twt+platform/2,h]) rotate([0,90,0]) cylinder(d=4,h=999);
        translate([0,tube_d/2+twt+platform/2,h])
            rotate([0,90,0])
            translate([0,0,twt+gap/2]) cylinder(d=7,h=999);
    }
}