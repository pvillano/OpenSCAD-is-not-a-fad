clearance=17; // [50]
height=150; // [300]
r1=25-17/2; r2=25+17/2;
for(xy = [[269,73],[85,170],[237,228],[475,280],[263,487]]){
    translate([xy[0],-xy[1],0]) difference(){
        cylinder(r=r2, h=clearance*2, center=true);
        cylinder(r=r1, h=clearance*2+.1, center=true);
    }
    hull(){
        translate([xy[0],-xy[1],0]) cylinder(r=r2, h=clearance);
        translate([237,-228,0])
        cylinder(r=r2, h=height-clearance);
    }
}