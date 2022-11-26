$fa = .01;
$fs = .5;
inch = 25.4;

/*
ih=16;
id_min=30;
wall_thickness_min = 1.17;


oc = (id_min + 2*wall_thickness_min) * PI;
oc_inches = ceil(oc/inch);
echo("oc inches", oc_inches);

od = oc_inches*inch/PI;
wall_thickness = min(wall_thickness_min, (od-id_min)/2);
*/

ih_min = 16;
id_min = 30;
oc_inches = 6;
min_division = 4;
min_thickness = 2;
tick_width = 1;
slop = .2;
emboss_depth = 1;


od = oc_inches * inch / PI;
//id = od - 2 * wall_thickness;
id = od - 2 * emboss_depth - 4 * min_thickness;
oh_min = ih_min + 2 * emboss_depth + 2 * min_thickness;
oh = ceil(oh_min / inch * 4) * inch / 4;
ih = oh - 2 * emboss_depth - 2 * min_thickness;

module ridges(count) {
    difference() {
        for (i = [1:count]) {
            rotate([0, 0, i * 360 / count]) translate([0, od / 2, 0]) cube([tick_width, od, oh + .2], center = true);
        }
        cylinder(d = od - 2 * emboss_depth, h = oh + .2, center = true);
    }
}

module bottom() {
    difference() {
        union() {
            cylinder(h = oh / 2, d = od);
            cylinder(h = (oh + ih) / 2 - slop, d = (od - emboss_depth + id) / 2 - slop / 2);
        }
        translate([0, 0, (oh - ih) / 2]) cylinder(d = id, h = ih);

        ridges(count = oc_inches);

        translate([0, 0, min_thickness]) linear_extrude(99) text("pvillano", halign = "center", valign = "center", size
        = .2 * id);
    }
}

module top() {
    difference() {
        cylinder(h = oh / 2, d = od);
        translate([0, 0, (oh - ih) / 2]) cylinder(h = 99, d = (od - emboss_depth + id) / 2 + slop / 2);

        ridges(count = oc_inches * min_division);
        translate([0, 0, min_thickness]) linear_extrude(99) text("pvillano", halign = "center", valign = "center", size
        = .2 * id);

    }
}

module assembly() {
    %translate([0, 0, oh/2]) cylinder(d = id_min, h = ih_min, center = true);
    difference() {
        union() {
            translate([0, 0, oh]) mirror([0, 0, 1]) top();
            bottom();
        }
        if ($preview) translate([0, - 999, - 999 / 2])cube(999);
    }
}


bottom();