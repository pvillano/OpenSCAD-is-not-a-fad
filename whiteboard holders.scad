x=16;
y=56;


cube([x,y,10]);
cube([x+15,y+15,5]);


mirror([1,0,0]) translate([1,0,0]) {
    
    cube([x,y,10]);
    cube([x+15,y+15,5]);
}
