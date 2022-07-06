$fa = .01;

$fs = $preview ? 10 : 10;

d_inner = 240;
d_outer = 250;
d_rim = 255;
h_insert = 20;
h_dtent = 10;
thickness = 10;

module third(r = 9000) {
    intersection() {
        translate([4500, 0, 0])cube(9000, center = true);
        rotate([0, 0, 60])translate([4500, 0, 0])cube(9000, center = true);
        children();
    }
}

intersection() {
    translate([-250/2,-210/2,0])cube([250, 210, d_outer/2]);
    difference() {
        //cylinder(d=d_outer,h=d_outer/2+thickness);
        union() {
            translate([0, 0, d_outer / 2])
                sphere(d = d_outer);
            cylinder(d1=d_outer/sqrt(3), d2=d_outer*1.5/sqrt(3),h=d_outer/4);
        }
        translate([0, 0, d_outer / 2])
            sphere(d = d_outer - thickness);

        if ($preview)translate([0,0,-1000])cube(9000);
    }
}
