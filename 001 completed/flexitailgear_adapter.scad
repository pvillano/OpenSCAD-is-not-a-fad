
$fa=.01;
$fs=.3;

h_mat = 16;
d_mat1 = 30.5 + .01;
d_mat2 = 30.0 + .01;

h_pump = 7.5;
d_pump1 = 20.0 + .01;
d_pump2 = 20.5 + .01;

twt=1.67;

difference(){
    hull(){
        cylinder(h=h_pump,d1=d_pump1+2*twt, d2=d_pump2+2*twt);
        mirror([0,0,1]) cylinder(h=h_mat, d1=d_mat1, d2=d_mat2);
    }
    translate([0,0,-.01])cylinder(h=h_pump+.02,d1=d_pump1, d2=d_pump2);
    mirror([0,0,1]) translate([0,0,-.01])cylinder(h=h_mat+.02, d1=min(d_mat1-2*twt,d_pump1), d2=d_mat2-2*twt);
}