module negative(h=210){
    difference(){
        #hull(){
            children();
            translate([0,0,-h]) children();
        }
        children();
        translate([0,0,-h])
            cube(h*2,center=true);
    }
}

negative(){
    cylinder(h=30,r1=20,r2=25);
}