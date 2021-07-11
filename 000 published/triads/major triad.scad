resolution = .2;//[.05,.1,.2,.5,1]
size=200; //[300]
radius=30;//[60]

/* [Hidden] */
f1 = 4;
f2 = 5;
f3 = 6;
$fs = $preview ? 1 : resolution;
$fa = .01;

r=size/2 - radius/2;
n = round(r*f3/$fs);

if($preview)
    #cube(size, center=true);

for(i=[1:n]){
    i1 = i/n*360;
    i2 = (i+1)/n*360;
    hull(){
        translate([r*sin(f1*i1), r*sin(f2*i1),r*sin(f3*i1)]) octahedron(radius/2);
        translate([r*sin(f1*i2), r*sin(f2*i2),r*sin(f3*i2)]) octahedron(radius/2);
    }
}

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