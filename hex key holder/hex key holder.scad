$fa = .01;
$fs = $preview ? 3 : .3;


//imperial_size_list = [.05, 1 / 16, 5 / 64, 3 / 32, 1 / 8, 5 / 32, 3 / 16, 7 / 32, 1 / 4, 5 / 16, 3 / 8];
//imperial_label_list = [".05", "1/16", "5/64", "3/32", "1/8", "5/32", "3/16", "7/32", "1/4", "5/16", "3/8"];
//assert(len(imperial_size_list) == len(imperial_label_list), "Count of imperial sizes and labels must be equal.");

//constants
hexup = 1/sin(60);

//measurements
metric_sizes = [2, 2.5, 3, 4, 5, 6, 8];
metric_safe_space = [12, 25];
w = 44.05;
h = 116.8;

//design parameters
spacing=2;
thin_wall_thickness=1.67;



//generic functions and modules
function sum(v) = [for(p=v) 1] * v;
function lerp(a,b,x) = a+(b-a)*x;

//specific functions
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
    //%cube([w, circumdiameter, h]);
}

//!key(w,h,8,14);

module key_slot_neg(d, w, slop=0, center=false) translate([(center ? -w/2 : 0), 0, 0]){

    //slop: how much jiggle the key should have in the locked or unlocked position
    //should be subtracted from the volume below the x plane, or lower for more strength
		// it turns out keys are naturally a little undersized
    r_sloppy = d / 2 + slop/2;
    circumradius_sloppy = r_sloppy * 1 / sin(60);

    //translate([0, 0, -(circumradius_sloppy - r_sloppy)*tan(60)]) {
    translate([0, 0, 0]) {
        rotate([0, 90, 0]) {
            rotate([0, 0, 90]) cylinder(h = w, r = circumradius_sloppy, $fn = 6);
            intersection() {
                if($preview) cylinder(h = w, r = circumradius_sloppy, $fn=100);
                else cylinder(h = w, r = circumradius_sloppy);
                translate([0, - circumradius_sloppy, 0]) cube([circumradius_sloppy, 2 * circumradius_sloppy, w]);
            }
            //unlocked
            //% translate([0,0,-.1]) cylinder(h = w + .2, r = d / 2 / sin(60), $fn = 6);
            //locked
//            % rotate([0, 0, 90])translate([0, 0, - .1]) cylinder(h = w + .2, r = d / 2 / sin(60), $fn = 6);
        }
        translate([0, - r_sloppy, 0])
            cube([w, 2 * r_sloppy, max(10, d * 1.5)]);
    }
}
module main(size_list=metric_sizes, w=w, h=h){
    size_list_reversed = [for(i=[1:len(size_list)]) size_list[len(size_list)-i]];
    difference(){
        layout(size_list_reversed=size_list_reversed, w=w, h=h, mode="pos");
        layout(size_list_reversed=size_list_reversed, w=w, h=h, mode="neg");
        layout(size_list_reversed=size_list_reversed, w=w, h=h, mode="ghost");
    }
}

module layout(size_list_reversed=size_list_reversed, w=w, h=h, mode="pos|neg|ghost"){
    for(i=[0:len(size_list_reversed)-1]){
        size=size_list_reversed[i];
        sum_less = size_list_reversed * [for(j=[0:len(size_list_reversed)-1])  (j<i) ? 1 : 0];
        sum_more = size_list_reversed * [for(j=[0:len(size_list_reversed)-1])  (j>i) ? 1 : 0];

        separation = sum_less + spacing * i;

        if(mode=="pos"){
						translate([w, -separation, size*hexup/2])
								rotate([0,-90,0])
								rotate([0,0,-30])
								difference()
						{
								d=size*hexup+4;
								h=lerp(metric_safe_space[1], metric_safe_space[0], i/(len(size_list_reversed)-1));
								//h=sum_more + metric_safe_space[0];
								cylinder(d=d,h=h);
								translate([size/2,-(d+.2)/2,-.1]) cube([d+.2, d+.2, h+.2]);
						}
			  }	else if(mode=="neg"){
					translate([-.1, -separation, size*hexup/2])
							rotate([30,0,0])
							key_slot_neg(size,w+.2);
				} else if(mode=="ghost") {
				
						h_i = h * size/max(size_list_reversed);
						w_i =lerp(w, 17, i/(len(size_list_reversed)-1));
				
						%translate([sum_less, -separation, size*hexup/2])
							rotate([-90,0,0])
							translate([0,-size*hexup/2, -h_i+size/2])
							key(w_i, h_i,size,size*2);
				}
    }

}

main();