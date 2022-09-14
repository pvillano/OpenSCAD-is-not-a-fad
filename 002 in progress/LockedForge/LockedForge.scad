x = 1;
y = 2;
unit = 25.4;
d_magnet = 5;
layer_height = .2;
loose = layer_height * 2;
cross_section = true;
min_thickness = .6;
z_lock = 4.8;
/* [Hidden] */
module __Customizer_Limit__() {};
$fa = .01;
$fs = .3;
h = d_magnet + loose + 2 * min_thickness;
thickness = d_magnet + loose/2 + .86;
module locked_forge_base(x = 1, y = 1, unit = 25.4, d_magnet = 5, h = 6.2, thickness = 6, loose = .3) {
    module hole() {
        translate([0, 0, min_thickness]) cylinder(h = d_magnet + loose, d = d_magnet + loose);
    }
    difference() {
        union() {
            difference() {
                cube([x * unit, y * unit, h]);

                //center hollow
                translate([thickness, thickness, - .01])
                    cube([x * unit - 2 * thickness, y * unit - 2 * thickness, h + .02]);
            }
            d_side = .86 + 7.1 / 2;
            for (dx = [d_side, x * unit - d_side], dy = [d_side, y * unit - d_side]) {
                translate([dx, dy, 0]) cylinder(h = h, d = 6.9 + .2 + 2*.86);
            }
        }
        d_side = .86 + 7.1 / 2;
        for (dx = [d_side, x * unit - d_side], dy = [d_side, y * unit - d_side]) {
            translate([dx, dy, - .01]) cylinder(h = h + .02, d = 4.1);
            translate([dx, dy, - .01]) cylinder(h = 4 + .2 + .01, d = 6.9 + .2);
        }
        //magnet holes
        for (i = [1:x]) {
            dx = (i - .5) * unit;
            translate([dx, d_magnet / 2, 0]) hole();
            translate([dx, y * unit - d_magnet / 2, 0]) hole();
            translate([dx - d_magnet / 2, d_magnet / 2, min_thickness + layer_height])
                cube([d_magnet, y * unit - d_magnet, z_lock]);
        }
        for (i = [1:y]) {
            dy = (i - .5) * unit;
            translate([d_magnet / 2, dy, 0]) hole();
            translate([x * unit - d_magnet / 2, dy, 0]) hole();
            translate([d_magnet / 2, dy - d_magnet / 2, min_thickness + layer_height])
                cube([x * unit - d_magnet, d_magnet, z_lock]);
        }
        if ($preview && cross_section) {
            translate([- 1, - 1, h / 2]) cube([x * unit + 2, y * unit + 2, h / 2 + 1]);
        }
    }
}

module top_holes(x, y, h=4, d=3.7){
        d_side = .86 + 7.1 / 2;
        for (dx = [d_side, x * unit - d_side], dy = [d_side, y * unit - d_side]) {
            translate([dx, dy, -.01]) cylinder(h = h, d = 3.7);
        }
}


mirror([0, 0, 1]) locked_forge_base(x, y, unit, d_magnet, h, thickness, loose);