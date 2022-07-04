$fa = .01;
$fs = $preview ? 3 : .3;


imperial_size_list = [.05, 1 / 16, 5 / 64, 3 / 32, 1 / 8, 5 / 32, 3 / 16, 7 / 32, 1 / 4, 5 / 16, 3 / 8];
imperial_label_list = [".05", "1/16", "5/64", "3/32", "1/8", "5/32", "3/16", "7/32", "1/4", "5/16", "3/8"];
assert(len(imperial_size_list) == len(imperial_label_list), "Count of imperial sizes and labels must be equal.");

metric_sizes = [2, 2.5, 3, 4, 5, 6, 8];

w = 44.05;
h = 116.8;

spacing=2;

hexup = 1/sin(60);

function sum(v) = [for(p=v) 1] * v;

module key(w, h, d, r_bend) {
    /*
    r_bend: bend radius is measured with inside curvature
     */
    r_bend_center = r_bend - d / 2;
    circumdiameter = d * 1 / sin(60);
    translate([d / 2, circumdiameter / 2, 0]) {
        //long part
        rotate([0, 0, 90])
            cylinder(h - r_bend, d = circumdiameter, $fn = 6);
        //short part
        translate([r_bend_center, 0, h - d / 2])
            rotate([0, 90, 0])
            rotate([0, 0, 90])
            cylinder(w - circumdiameter / 2 - r_bend_center, d = circumdiameter, $fn = 6);
        //bent part
        translate([0, 0, h - r_bend])
            rotate([90, - 90, 0])
            translate([0, - r_bend_center, 0])
            rotate_extrude(angle = 90, convexity = 10)
            translate([r_bend_center, 0, 0])
            rotate([0, 0, 30])
            circle(d = circumdiameter, $fn = 6);
    }
    %cube([w, circumdiameter, h]);
}

//!key(w,h,8,14);

module key_slot_neg(d, w, slop=0, center=false) translate([(center ? -w/2 : 0), 0, 0]){

    //slop: how much jiggle the key should have in the locked or unlocked position
    //should be subtracted from the volume below the x plane, or lower for more strength
    r_sloppy = d / 2 + slop/2;
    circumradius_sloppy = r_sloppy * 1 / sin(60);

    //translate([0, 0, -(circumradius_sloppy - r_sloppy)*tan(60)]) {
    translate([0, 0, 0]) {
        rotate([0, 90, 0]) {
            rotate([0, 0, 90]) cylinder(h = w, r = circumradius_sloppy, $fn = 6);
            intersection() {
                if($preview) cylinder(h = w, r = circumradius_sloppy, $fn=24);
                else cylinder(h = w, r = circumradius_sloppy);
                translate([0, - circumradius_sloppy, 0]) cube([circumradius_sloppy, 2 * circumradius_sloppy, w]);
            }
            //cylinder(h=w,r = radius_scrapey);

            //unlocked
            //% translate([0,0,-.1]) cylinder(h = w + .2, r = d / 2 / sin(60), $fn = 6);
            //locked
//            % rotate([0, 0, 90])translate([0, 0, - .1]) cylinder(h = w + .2, r = d / 2 / sin(60), $fn = 6);
        }
        translate([0, - r_sloppy, 0])
            cube([w, 2 * r_sloppy, max(10, d * 1.5)]);
    }
}

module demo() rotate([30, 0, 0]) difference() {
    d=8;
    h = 10;
    l = 20;
    w = 20;
    r_bulge=d + 4;
    union(){
        rotate([-30, 0, 0]) translate([0,0,-h/2-d/2/sin(60)]) cube([l, 30, h], center=true);
        translate([0,0,-d]) rotate([0,90,0]) rotate([0,0,90])cylinder(r=r_bulge,h=w, center=true, $fn=6);
    }
    key_slot_neg(d=d, w=w+.2, center=true);
    rotate([-30, 0, 0]) translate([0,0,-999/2-9]) cube(999, center=true);
}

module layout(){
    metric_reversed = [for(i=[1:len(metric_sizes)]) metric_sizes[len(metric_sizes)-i]];
    for(i=[0:len(metric_reversed)-1]){
        size=metric_reversed[i];
        sum_less = metric_reversed * [for(j=[0:len(metric_reversed)-1])  (j<i) ? 1 : 0];

        separation = 1.0 * sum_less + 1*i;

        h_i = h * size/max(metric_reversed);
        w_i = w * size/max(metric_reversed);

        neutral = [0,-size*hexup, -h_i];
        *translate([separation, -separation, 0])
            rotate([-90,0,0])
            translate(neutral)
            key(w_i, h_i,size,size*2);


        translate([w-w_i/2, -separation-size/2, size*hexup/2])
            rotate([30,0,0])
            key_slot_neg(size,w_i/2);
    }
    translate([0,-h,-1]) cube([w,h,1]);
}

layout();