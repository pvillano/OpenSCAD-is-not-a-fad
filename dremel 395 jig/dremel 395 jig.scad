$fa = .01;
$fs = $preview ? 1 : .3;

inch = 25.4;

d_threads = 20;
w_threads = 10;
offset_body = 52;
d_body = 46.3;
unit = inch/4;
h_body = 30;



d_screw = 3.4;
d_screw_hole = 4;
d_screw_head = 7;
l_screw = 14;
h_nut=3.1;
d_nut=7;


clamp_thickness = 8;

function round_to(x, y=1) = ceil(x/y)*y;


module dremel_prev() rotate([0,90,0]){
    translate([0,0,-.1])cylinder(d=d_threads, h=w_threads+.2);
    translate([0,0,w_threads]) cylinder(d1=d_threads,d2=d_body,h=offset_body-w_threads);
    translate([0,0,offset_body-.1]) cylinder(d=d_body,h=h_body+.2);
}
module dremel() rotate([0,90,0]){
    translate([0,0,-.1])cylinder(d=d_threads, h=w_threads+.2);
    translate([0,0,w_threads]) cylinder(d1=d_body*.9,d2=d_body,h=offset_body-w_threads);
    translate([0,0,offset_body-.1]) cylinder(d=d_body,h=99);
}

module screw_hole(){
    d_nut = d_nut*1/sin(60)+.2;
    l_screw = l_screw - h_nut - .2;
    ratio = .5;
    translate([0,0,-ratio*l_screw]) cylinder(d=d_screw,h=l_screw); //threaded part
    cylinder(d=d_screw_hole,h=l_screw); //floating part
    translate([0,0,l_screw*(1-ratio)]) cylinder(d=d_screw_head,h=99); //room for head
    translate([0,0,-ratio*l_screw]) rotate([180,0,0]) cylinder(d=d_nut,h=99, $fn=6); //room for nut
    //room for nut
}
difference(){
    h_centerline=round_to(d_body/2+clamp_thickness, unit);
    union(){
        rotate([0,90,0]) cylinder(d=d_threads+2*clamp_thickness,h=w_threads);
        translate([0,-(d_threads+2*clamp_thickness)/2,-h_centerline]) cube([w_threads, d_threads+2*clamp_thickness,h_centerline]);

        rotate([0,90,0]) translate([0,0,offset_body]) cylinder(d=d_body+2*clamp_thickness,h=h_body);
        translate([offset_body,-(d_body+2*clamp_thickness)/2,-h_centerline]) cube([h_body, d_body+2*clamp_thickness, h_centerline]);

        w_base = round_to(d_body+2*clamp_thickness, unit*2);
        l_base = round_to((offset_body+h_body)*1.25, unit);
        echo("final base size", w_base/unit, l_base/unit);
        translate([0,-w_base/2,-h_centerline]) cube([l_base, w_base, clamp_thickness]);
    }
    dremel();
    for(flip=[-1,1]){
        translate([w_threads/2,flip*(d_threads+clamp_thickness)/2]) screw_hole();
        translate([offset_body + h_body*.25,flip*(d_body+clamp_thickness)/2]) screw_hole();
        translate([offset_body + h_body*.75,flip*(d_body+clamp_thickness)/2]) screw_hole();
    }

    cube([999,999,.1], center=true);
}

%dremel_prev();