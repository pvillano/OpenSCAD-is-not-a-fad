

inch=25.4;

aa_l = 2*inch;
aa_d = 14.0;

barrel_shroud_diameter = 10.5;
barrel_shroud_height = 4.0;
barrel_thread_diameter = 7.8;
//barrel_flat_height = 8.7;
barrel_h_safe = 30;

gap=1;
length_multiplier = 3;

mid_h=.76*aa_d;
module body(){
    cylinder(d=aa_d,h=aa_l*(length_multiplier-1));
    translate([aa_d+gap,0,0]) cylinder(d=aa_d,h=aa_l*length_multiplier);
    translate([0,-.5*mid_h,0]) cube([aa_d+gap, mid_h,aa_l*(length_multiplier-1)]);
}

module terminal_neg(){
    translate([0,0,-barrel_shroud_height]) cylinder(d=barrel_shroud_diameter, h=barrel_shroud_height+.1);
    mirror([0,0,1])
            cylinder(h=barrel_h_safe, d=barrel_thread_diameter);
//    mirror([0,0,1])%cylinder(d=aa_d,h=aa_l);
}

difference(){
    body();
    translate([0,0,aa_l*(length_multiplier-1)]) terminal_neg();
}
//terminal_neg();

