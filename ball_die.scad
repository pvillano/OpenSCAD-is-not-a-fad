ball_bearing_radius = 10;
wiggle_room = ball_bearing_radius;

pip_sep = ball_bearing_radius;
pip_r = pip_sep/6;

minimum_thickness = 3;

current_color = "ALL";

$fa = .01;
$fs = $preview ? 10 : 1;


module multicolor(color) {
    if (color==current_color || current_color == "ALL")
        color(color){
            children();
        }
}

outer_diameter = 2 *(wiggle_room + minimum_thickness + ball_bearing_radius);
module octahedron(r){
    polyhedron(
        points=[
            [0, 0, r],
            [r, 0, 0],
            [0, r, 0],
            [-r, 0, 0],
            [0, -r, 0],
            [0, 0, -r],
        ],
        faces=[
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 4],
            [0, 4, 1],
            [5, 2, 1],
            [5, 3, 2],
            [5, 4, 3],
            [5, 1, 4],
        ]
    );
}


module ballish(d){
    difference(){
        sphere(d=d);
        minkowski(){
            octahedron(wiggle_room);
            sphere(ball_bearing_radius);
        }
    };
}

difference(){
    union(){
        multicolor("white") ballish(outer_diameter);

        d_pip = pip_sep/2;
        multicolor("red") intersection(){
            union(){
                rotate([0,0,0]) {
                    cylinder(h=outer_diameter, r = pip_r);
                }
                rotate([90,0,0]) {
                    translate([-d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                }
                rotate([0,90,0]) {
                    translate([-d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([0,0,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    
                };
                rotate([0,-90,0]) {
                    translate([-d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([-d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    
                };
                rotate([-90,0,0]) {
                    translate([-d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([-d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([0,0,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    
                };
                rotate([0,180,0]) {
                    translate([-d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([-d_pip,0,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([-d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,-d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,0,0]) cylinder(h=outer_diameter, r = pip_r);
                    translate([d_pip,d_pip,0]) cylinder(h=outer_diameter, r = pip_r);
                    
                };
            }
            ballish(outer_diameter*($preview ? 1.001: 1));
        }
    }
    if($preview){
        translate([0,-outer_diameter,0]) cube([outer_diameter,outer_diameter,outer_diameter]);
    }
}