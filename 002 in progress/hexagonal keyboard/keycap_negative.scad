/*
This module is meant to be used in a difference,
and will both subtract the dimensions of the keyswitch
and enforce the separation between keycaps

data from https://www.cherrymx.de/en/dev.html
 */
$fa=.01;
$fs=.1;
cross_width=4.1; //[4.1:4.15]
cross_thickness=1.17; //[1.15:1.19]
cross_roundover_r = 0.3; // exact
cross_depth_min = 3.8; //switch is only 3.6 so they want gap
stem_d = 5.5; // TODO: split stem outer shape in three options: maximum, maximum kalih box
stem_h_min = cross_depth_min;
keyhole_xy = 15.4;
keyhole_taper1 = 7.5;
keyhole_taper2 = 30;
keyhole_midheight_min = 3;
keyhole_h_max = 5;
//keycap_spacing = 19.05;
keycap_w = 18;

module keycap_negative(){
    stem_round();
}
module keycap_bounds(w=keycap_w){
    translate([-key_spacing/2,-key_spacing/2,-keyhole_h_max]) cube([key_spacing,key_spacing,20]);
}

module stem_cross(h=cross_depth_min, w=cross_width, t=cross_thickness, r=cross_roundover_r){
    //sticks up from [0,0,0] with .01 below the xy plane to adhere to the balls
    translate([0,0,h/2]) cube([w,t,h], center=true);
    translate([0,0,h/2]) cube([t,w,h], center=true);
    difference(){
        translate([0,0,h/2]) cube([t+2*r,t+2*r,h], center=true);
        for(i=[-1,1],j=[-1,1]) translate([i*(r+t/2),j*(r+t/2),-.01]) cylinder(h=h+.02,r=r,$fn=max(2*PI*r/$fs,12));
    }
    for(a=[0,90]) rotate([0,0,a])difference(){
        translate([-t/2-r,-w/2,-.01]) cube([t+2*r,w,r+.01]);
        for(dx=[-t/2-r,t/2+r]) translate([dx,0,r]) rotate([90,0,0]) cylinder(h=w+.02,r=r, center=true,$fn=max(2*PI*r/$fs,12));
    }
    difference(){
        translate([-t/2-r,-t/2-r,0]) cube([t+2*r,t+2*r,r]);
        for(a=[0,90,180,270]) rotate([0,0,a]) translate([t/2+r,t/2+r,r]) sphere(r,$fn=max(2*PI*r/$fs,12));
    }
}

module housing_clearance(h1=keyhole_midheight_min, h2=keyhole_h_max, w=keyhole_xy, taper1=keyhole_taper1, taper2=keyhole_taper2){
    // spec clearing for a keycap_negative
    // glued to the bottom of the xy plane
    translate([0,0,-h2]) hull()
    {
        cube([w,w,.01], center=true);
        midwidth = w - 2*h1*2*tan(taper1);
        translate([0,0,h1]) cube([midwidth,midwidth,.01], center=true);
        top_width = midwidth - 2 * (h2-h1)*tan(taper2);
        translate([0,0,h2]) cube([top_width,top_width,.01], center=true);
    }
}

module stem_round(h = stem_h_min, d1=stem_d, taper=1.5, w = keyhole_xy){
    difference(){
        housing_clearance();
        translate([0,0,-h]) cylinder(h=h+.1,d1=stem_d, d2=stem_d+2*stem_h_min*tan(taper));
    }
    translate([0,0,-h]) stem_cross();

}

stem_round();