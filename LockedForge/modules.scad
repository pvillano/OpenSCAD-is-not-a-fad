use <LockedForge.scad>

$fa = .01;
$fs = .3;
unit=25.4;

module cylinder_holder(d, x = 3, y = 3, h = 25.4 / 2, unit = 25.4) {
    difference() {
        cube([x * unit, y * unit, h]);
        translate([x * unit / 2, y * unit / 2, 2]) cylinder(d = d, h = h);
        top_holes(x, y, h = h - 2);
    }
}


module pillshape_holder(d, w, x = 3, y = 2, h = 25.4 / 2, unit = 25.4) {
    difference() {
        cube([x * unit, y * unit, h]);
        hull() {
            translate([x * unit / 2 - (w - d) / 2, y * unit / 2, 2]) cylinder(d = d, h = h);
            translate([x * unit / 2 + (w - d) / 2, y * unit / 2, 2]) cylinder(d = d, h = h);
        }
        top_holes(x, y, h = h - 2);
    }
}


module rectangle_holder(w, l, r = 1, x = 2, y = 1, h = 25.4 / 2, unit = 25.4) {
    difference() {
        cube([x * unit, y * unit, h]);
        translate([x * unit / 2, y * unit / 2, 2])
            linear_extrude(h)
                offset(r = r)
                    square([w - 2 * r, l - 2 * r], center = true);
        top_holes(x, y, h = h - 2);
    }
}

/* my uses*/
////cologne
//translate([25.4 * 3 + 6, 0, 0]) cylinder_holder(64 + .3);
////lotion
//cylinder_holder(59.5 + .1);
////eyeglass-cleaner
//translate([0, 25.4 * 3 + 6, 0]) cylinder_holder(49.8 + .3);
////lip balm
//cylinder_holder(19.16+.3,x=1,y=1);
//pen
//difference() {
//    cylinder_holder(5.3 + .2, x = 1, y = 1);
//    translate([unit/2,unit/2,-.01]) cylinder(d=5.3+.2,h=unit/4);
//}
//flashlight
///cylinder_holder(24.0+.3,x=2,y=2);

////deoderant
//pill(d=25+.3, w=65.8+.3);

//wallet
//pill(d=9.9+.3, w=102.6+.3, x = 5, y = 1);

////knife
//rectangle_holder(23.75+.2,7.6+.2);

////ruler
//rectangle_holder(3/4*unit+.2, .89+.2,0,1,1);

////nail clippers
rectangle_holder(10.6+.2, 11.7+.2,0,1,1);