$fa = .01;
$fs = $preview ? 1 :.2;

d=16;
sep=40;

//prongs
translate([(sep+d)/2,0,0]){
    hull(){
        sphere(d=d);
        translate([0,40,80]) sphere(d=d);
    }
}
translate([-(sep+d)/2,0,0]){
    hull(){
        sphere(d=d);
        translate([0,40,80]) sphere(d=d);
    }
}

//back plate
translate([0,0,-8]){
    difference(){
        minkowski(){
            cube([110,60,8],center=true);
            sphere(d=8);
        }
        translate([0,0,-100]) cube(size=200, center=true);
    }
}