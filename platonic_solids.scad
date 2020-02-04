
/*
    Points spiral down from thetop, as do faces.
*/
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