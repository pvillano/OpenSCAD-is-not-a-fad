imperial_sizes = [.05, 1/16, 5/64, 3/32, 1/8, 5/32, 3/16, 7/32, 1/4, 5/16, 3/8];
metric_sizes = [2, 2.5, 3, 4, 5, 6, 8];
w=44.05;
h=116.8;


module key(w, h, d, r_bend){
    circumdiameter=d*1/sin(60);
    translate([d/2,circumdiameter/2,0]){
    //translate([0,0,0]){
        rotate([0,0,90])
            cylinder(h-d/2-r_bend,d=circumdiameter, $fn=6);
        translate([r_bend,0,h-d/2])
            rotate([0,90,0])
            rotate([0,0,90])
            cylinder(w-circumdiameter/2-r_bend,d=circumdiameter, $fn=6);
        translate([0,0,h-r_bend-d/2])
            rotate([90,-90,0])
            translate([0,-r_bend,0])
            rotate_extrude(angle=90, convexity=10)
            translate([r_bend,0,0])
            rotate([0,0,30])
            circle(d=circumdiameter, $fn=6);
    }
    %cube([w,circumdiameter,h]);
}

key(w,h,8,10);