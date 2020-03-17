rotate([0,atan(-1/64),0]){
    difference(){
        hull(){
            sphere(d=16);
            translate([65,0,0])
                sphere(d=18);
        }
        cube([20,.55,1000], center=true);
    }
}