$fa=.01;
$fs=.5;

inch=25.4;

aa_l = 2*inch;
aa_d = 14.0;

barrel_shroud_diameter = 10.5;
barrel_shroud_height = 4.0;
barrel_thread_diameter = 7.8;
barrel_flat_height = 6.7;
barrel_h_safe = 30;
d_nut = 12.4;

//todo
screw_clearance_d = 4.1;
screw_thread_d = 3.8;
screw_head_d = 7;
screw_head_h = 4;
screw_l = 10;

gap=1;

mid_h=.9*aa_d;
//module body(){
//    cylinder(d=aa_d,h=aa_l*(length_multiplier-1));
//    translate([aa_d+gap,0,0]) cylinder(d=aa_d,h=aa_l*length_multiplier);
//    translate([0,-.5*mid_h,0]) cube([aa_d+gap, mid_h,aa_l*(length_multiplier-1)]);
//}

module terminal_neg(){
    translate([0,0,-barrel_shroud_height]) cylinder(d=barrel_shroud_diameter, h=barrel_shroud_height+.1);
    mirror([0,0,1]) intersection(){
        cylinder(h=barrel_h_safe, d=barrel_thread_diameter);
        translate([0,0,barrel_h_safe/2]) cube([barrel_thread_diameter, barrel_flat_height, barrel_h_safe], center=true);
    }
//    mirror([0,0,1])%cylinder(d=aa_d,h=aa_l);
}

module screw_negative(){
    underground=.66;
    //threads, clearance, head, allan key
    translate([0,0,-screw_l*underground]) cylinder(d=screw_thread_d, h=99);
    translate([0,0,0]) cylinder(d=screw_clearance_d,h=99);
    translate([0,0,screw_l*(1-underground)]) cylinder(d=screw_head_d, h=99);
    translate([0,0,screw_l*(1-underground)+screw_head_h]) cylinder(d=screw_head_d+1, h=99);
}

h1=4+barrel_shroud_height;
module body1(){
    difference(){
        union(){
            cylinder(d=aa_d,h=h1);
            translate([aa_d+gap,0,0]) cylinder(d=aa_d,h=aa_l);
            #translate([0,-.5*aa_d,0]) cube([aa_d+gap, mid_h,h1]);
        }
        translate([0,0,h1]) terminal_neg();
        translate([(aa_d+gap),0,0]) screw_negative();
    }
}

module upscrew(){
    translate([0,0,screw_head_h+screw_l]) cylinder(d=screw_thread_d,h=.2, center=true);
}
module body2(){
    h2=2*aa_l-h1;
    difference(){
        union(){
            cylinder(d=aa_d,h=h2);
            translate([aa_d+gap,0,0]) cylinder(d=aa_d,h=h2);
            translate([0,-.5*aa_d,0]) cube([aa_d+gap, mid_h,h2]);
        }
        translate([aa_d+gap,0,h2]) screw_negative();
        for(dx=[0,aa_d+gap]){
            hull(){
                translate([0,0,h2-2]) cylinder(d=d_nut-dx/3,h=2.1);
                translate([dx,0,screw_head_h+screw_l]) cylinder(d=screw_thread_d,h=.2, center=true);
            }
            translate([dx,0,-.1]) cylinder(d=screw_head_d, h=screw_head_h+.1);
            translate([dx,0,0]) cylinder(d=screw_thread_d, h=screw_head_h+screw_l);
        }
    }
}

body2();

