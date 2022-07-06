w=20;
twt=.454;

//complete failure
module naive(){
    cube(w);
    rotate([0,0,180])
        cube(w);
}

module overlap(p=1){
    cube(w);
    translate([twt*p-w,twt*p-w,0])
        cube(w);
}

overlap();