/*
This module is meant to be used in a difference,
and will both subtract the dimensions of the keyswitch
and enforce the separation between keycaps
 */
cross_width=4.1;
cross_thickness=1.17;
cross_roundover_r = 0.3;
cross_depth_min = 3.8; //switch is only 3.6 so they want gap
stem_d_max = 5.5; // TODO: split stem outer shape in three options: maximum, maximum kalih box

module keycap_negative(slop=0, stem_sh){


}

module stem_cross(h=cross_depth_min, w=cross_width, t=cross_thickness, r=cross_roundover_r){
    difference(){
        union(){
            translate([0,0,h/2]) cube([w,t,h], center=true);
            translate([0,0,h/2]) cube([t,w,h], center=true);
            translate([0,0,h/2]) cube([t+2*r,t+2*r,h], center=true);
        }
        for(i=[-1,1],j=[-1,1]) translate([i*(r+t/2),j*(r+t/2),-.1]) cylinder(h=h+.2,r=r,$fn=max(2*PI*r/$fs,12));
    }
}
stem_cross();