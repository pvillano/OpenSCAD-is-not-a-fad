

ball_bearing_radius = 5;
outer_diameter = 16;

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




difference(){
    sphere(d=outer_diameter);
    minkowski(){
        octahedron(outer_diameter/2 - minimum_thickness - ball_bearing_radius);
        sphere(ball_bearing_radius);
    }
}
//still needs faces