
cube_size = 50;
fattening = 10;

module fatten(r){
    minkowski(){
        sphere(r=r);
        children();
    }
}


translate([cube_size*2,0,0]) cube(cube_size);

fatten(fattening){
    cube(cube_size);
};
