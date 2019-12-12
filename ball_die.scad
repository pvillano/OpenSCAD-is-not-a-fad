ball_bearing_radius = 2;
outer_diameter = 16;

pip_r = 1;
pip_sep = 5;

minimum_thickness = 2;

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
            octahedron(outer_diameter/2 - minimum_thickness - ball_bearing_radius);
            sphere(ball_bearing_radius);
        }
    };
}

color("white") ballish(outer_diameter);

d_pip = pip_sep/2;
color("red") intersection(){
    union(){
        $fn=16;
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
    ballish(outer_diameter+.001);
}
