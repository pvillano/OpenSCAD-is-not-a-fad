module negative(h=210){
    difference(){
        hull(){
            children();
            translate([0,0,-h]) children();
        }
        children();
        translate([0,0,-2*h])
            cube(h*4,center=true);
    }
}


negative(40){
    translate([-40,-45,0]) import("Quonset_Hut_Shell.stl");
}