$fa=.01;
$fs=.5;


bearing_od = 8;
bearing_id = 3;
bearing_w=4;

threads_length = 18;
head_od=5.5;
head_h=3.2;


//nut_h = 2.3;
nut_h=3; // some extra space because overhangs
nut_waf=5.5;
nut_d=nut_waf/sin(360/6);

spacer_od=nut_d;
spacer_h=nut_h;

captive_od=55;
captive_w=30;

tight=.1;
loose=.25;

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

module quadrate(){
    mirror2([0,1,0])
        for(i=[0:3]){
        rotate([0,45+i*90])
        translate([0,captive_w/2,captive_od/2+bearing_od/2])
        rotate([90,0,0])
        children();
    }
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

//%trangate() cylinder(h=bearing_w, d=bearing_od, center=true);
module main(){
%captive();
    difference(){
        rotate([90,-90,0]) cylinder(d=captive_od*2+exmarg, h=w, $fn=3, center=true);
        //spool neg
        //rotate([90,0,0]) cylinder(h=captive_w+loose, d=captive_od+loose, center=true);
        rotate([90,90,0]) cylinder(d=captive_od*sqrt(7.5)+exmarg/2, h=captive_w+loose, $fn=3, center=true);
        //bearing neg
        #trangate() bearing_ass();

        %hull(){
            rotate([90,0,0]) cylinder(h=captive_w+loose, d=captive_od+loose, center=true);
            translate([0,0,-100])rotate([90,0,0]) cylinder(h=captive_w+loose, d=captive_od+loose, center=true);
        }
        #trangate( captive_od*sqrt(5/8)+exmarg/4, 0){
            cylinder(d=bearing_id+tight,h=w/2+.2, center=true);
            h=(30-nut_h)/2;
            translate([0,0,h]) cylinder(h=w/2-h+.2, d=nut_d+tight, $fn=6);
        }

        translate([0,-500,0]) cube(1000, center=true);
    }
}

module bearing_ass(){
    translate([0,0,-bearing_w]){
        cylinder(d=bearing_id,h=threads_length);
        cylinder(d=bearing_od, h=bearing_w);
        cylinder(d=spacer_od, h=bearing_w+spacer_h);
        translate([0,0,threads_length-nut_h]) cylinder(h=nut_h+.1, d=nut_d+tight, $fn=6);
    }
}

main();
