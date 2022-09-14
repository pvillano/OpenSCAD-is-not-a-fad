//outside print dimension
outside_diameter = 16;

//thickness of cage
thickness = 3;

//gap between cage and center
gap = .5;

//depth of emboss
letter_depth = .5;

stick_out = 1;

letter_size = outside_diameter - 2*thickness;
module letter(l) {
    // Use linear_extrude() to make the letters 3D objects as they
    // are only 2D shapes when only using text()
    linear_extrude(height = outside_diameter, center=true) {
        text(l, size = letter_size, halign = "center", valign = "center", $fn = 16);
    }
}


column_r = outside_diameter - 2*thickness - 2 * gap - 2 * stick_out;
column_h = outside_diameter + 2* stick_out;
o = column_h/2;
union(){
    difference(){
        hull() {
            cube([column_h, column_r, column_r], center=true);
            cube([column_r, column_h, column_r], center=true);
            cube([column_r, column_r, column_h], center=true);
        }
        translate([o, 0, 0]) rotate([0, 90, 0]) letter("2");
        translate([-o, 0, 0]) rotate([0, -90, 0]) letter("5");
        translate([0, -o, 0]) rotate([90, 0, 0]) letter("1");
        translate([0, o, 0]) rotate([90, 0, 180]) letter("6");
        translate([0, 0, o]) rotate([0, 0, 90])  letter("3");
        translate([0, 0, -o]) rotate([180, 0, -90]) letter("4");
    }
    hull() {
        cube([column_h - letter_depth, column_r - letter_depth, column_r - letter_depth], center=true);
        cube([column_r - letter_depth, column_h - letter_depth, column_r - letter_depth], center=true);
        cube([column_r - letter_depth, column_r - letter_depth, column_h - letter_depth], center=true);
    }
}

gap_r = outside_diameter - 2*thickness;
difference(){
    cube(outside_diameter, center=true);
    hull(){
        cube([outside_diameter, gap_r, gap_r], center=true);
        cube([gap_r, outside_diameter, gap_r], center=true);
        cube([gap_r, gap_r, outside_diameter], center=true);
    }
}