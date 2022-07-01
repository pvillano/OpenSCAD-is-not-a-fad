$fa =.01;
$fs=.3;


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

//key(w,h,8,10);

module key_slot_neg(d,w,slop){
    //centered on the y axis, extending into the x axis, with slop in the z
    r=d/2;
    circumradius = r*1/sin(60);
    translate([0,0,-circumradius/2])
        rotate([0,90,0]){
            cylinder(h=w,r=circumradius+slop/2);
            %cylinder(h=w+1,r=circumradius,$fn=6);
        }
    translate([0,-r,0])
        cube([w,d+slop,max(10,d*1.5)]);
}



rotate([30,0,0]) difference(){
    h=15;
    translate([0.01,-15/2,0])cube([25,15,h]);
    translate([0,0,h-3]) key_slot_neg(8,20,.1);
}
translate([0,-25/2,-2.5])cube([25,25,5]);
















