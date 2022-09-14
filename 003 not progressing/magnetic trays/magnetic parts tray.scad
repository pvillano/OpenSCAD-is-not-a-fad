d_magnet = 8.03;
h_magnet = 2.69;

spacing = 25;
x_count = 7; // [1:15]
y_count = 5; // [1:15]
step = 5;
depth = 10;
slop = .1;

/* [Advanced] */
first_layer_thickness = .2;
thin_wall_thickness = 1.67;
/* [Hidden] */
$fa = .01;
$fs = $preview ? 5 : .3;
h_plate = h_magnet + first_layer_thickness + 2*slop;
ep = .01;

module cxycube(size) {
    h = is_list(size) ? size[2] : size;
    translate([0, 0, h / 2])
        cube(size, center = true);
}

difference() {
    hull() {
        translate([0, 0, h_plate - ep])
            cxycube([spacing * x_count - h_plate * 2, spacing * y_count - h_plate * 2, ep]);
        cxycube([spacing * x_count, spacing * y_count, ep]);
    }
    for (i = [.5:x_count - .5], j = [.5:y_count - .5]) {
        translate([- spacing * x_count / 2, - spacing * y_count / 2, 0])
            translate([i * spacing, j * spacing, first_layer_thickness])
                cylinder(d = d_magnet + 2 * slop, h = h_magnet + 2*slop + ep);
    }
}
inner_tall = [spacing * x_count - h_plate * 2, spacing * y_count - h_plate * 2, depth + step + h_plate];
inner_fat = [spacing * x_count + 2 * step, spacing * y_count + 2 * step, depth];
outer_tall = inner_tall + [thin_wall_thickness, thin_wall_thickness, 0];
outer_fat = inner_fat + [thin_wall_thickness, thin_wall_thickness, 0];

difference() {
    hull() {
        cxycube(outer_tall);
        cxycube(outer_fat);
    }
    hull() {
        cxycube(inner_tall + [0, 0, ep]);
        translate([0, 0, - ep])
            cxycube(inner_fat + [0, 0, ep]);
    }
}