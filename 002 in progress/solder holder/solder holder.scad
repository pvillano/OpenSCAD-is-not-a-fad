$fa=.01;
$fs=.1;

tight=.15;
loose=.25;

bearing_od = 8;
bearing_id = 3;
bearing_w=4;

threads_length = 18;
thread_clearance = 3;
head_od=5.5;
head_h=3.2;
threads_length_long = 30;

//nut_h = 2.3;
nut_h=3; // some extra space because overhangs
nut_waf=5.5;
nut_d=nut_waf/sin(360/6);

spacer_od=6;
spacer_h=5.55;

captive_od=55;
captive_w=30;


exmarg = 6;
w=captive_w+2*(threads_length-bearing_w);

echo(w);
module mirror2(xyz){
    mirror(xyz) children();
    children();
}

module captive(){
    rotate([90,0,0])cylinder(d=captive_od, h=captive_w, center=true);
}

module trangate(r=captive_od/2+bearing_od/2, w_=captive_w){
    mirror2([0,1,0])
        for(i=[0:2]){
        rotate([0,i*120])
        translate([0,w_/2,r])
        rotate([90,0,0])
        mirror([0,0,1])
        children();
    }
}

module under_nut(layer_height=.35){
    //nut
    mirror([0,0,1]) cylinder(h=99, d=nut_d+tight, $fn=6);
    //steps
    cube([(nut_d+tight)/2, nut_waf+tight*sqrt(3)/2, layer_height*2], center=true);
    cube([(nut_d+tight)/2, (nut_d+tight)/2, layer_height*4], center=true);
    rotate([0,0,180/8]) cylinder(h=layer_height*3,d=(nut_d+tight)/2/cos(180/8), $fn=8);
    // screw
    cylinder(h=99, d=thread_clearance+loose);
}

module bearing_ass(){
    translate([0,0,-bearing_w]){
        cylinder(d=bearing_od, h=bearing_w);
        cylinder(d=spacer_od+tight, h=bearing_w+spacer_h);
        translate([0,0,threads_length-nut_h]) mirror([0,0,1]) under_nut();
    }
}

module main(){
    %captive();
    difference(){
        //outside triangle
        rotate([90,-90,0]) cylinder(d=captive_od*2+exmarg, h=w, $fn=3, center=true);
        //spool neg
        //rotate([90,0,0]) cylinder(h=captive_w+loose, d=captive_od+loose, center=true);
        rotate([90,90,0]) cylinder(d=captive_od*sqrt(7.5)+exmarg/2, h=captive_w+loose, $fn=3, center=true);
        //bearing neg
        #trangate() bearing_ass();

        //slips through check
        %hull(){
            rotate([90,0,0]) cylinder(h=captive_w+loose, d=captive_od+loose, center=true);
            translate([0,0,-100])rotate([90,0,0]) cylinder(h=captive_w+loose, d=captive_od+loose, center=true);
        }
        //assembly screws
        #trangate( captive_od*sqrt(5/8)+exmarg/4, 0){
            cylinder(d=thread_clearance+loose,h=w/2+.2, center=true);
            h=(threads_length_long-nut_h)/2;
            translate([0,0,h]) mirror([0,0,1]) under_nut();
        }
        //cut in half
        translate([0,-500,0]) cube(1000, center=true);
    }
}


main();
