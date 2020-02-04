module tetrahedron(r){
    scale(r) polyhedron(
        points=[
            [-1,  0, -sqrt(.5)],
            [ 1,  0, -sqrt(.5)],
            [ 0, -1,  sqrt(.5)],
            [ 0,  1,  sqrt(.5)],
        ],
        faces=[
            [0, 1, 3],
            [0, 2, 1],
            [0, 3, 2],
            [1, 2, 3],
        ]
    );
}


/*
    Points spiral down from the top, as do faces.
*/
module octahedron(r){
    scale(r) polyhedron(
        points=[
            [ 0,  0,  1],
            [ 1,  0,  0],
            [ 0,  1,  0],
            [-1,  0,  0],
            [ 0, -1,  0],
            [ 0,  0, -1],
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

PHI = (1 + sqrt(5))/2;

module dodecahedron(r){
    scale(r) hull(){
        cube(size=2, center=true);
        for(r_vec = [[0,0,0], [0,90,90], [90,0,90]]){
            rotate(r_vec)
            linear_extrude(height=2/PHI, center=true)
            polygon([
                [ PHI,  0],
                [   0,  .01],
                [-PHI,  0],
                [   0, -.01],
            ]);
        }
    };
}
