

gap=.4;
grid=15;

module lubonify(count=4){
    intersection(){
        for(i=[0:count-1]) {
            translate([0,0,i*grid])
            if(i%2){
                children();
            } else {
                mirror([1,0,0]) children();
            }
        }
        translate([0,0,count*grid/2])
            cube([200,200,count*grid-gap],center=true);
    }
}
module icube(x=1,y=1,dx=0,dy=0,zgap=false){
    translate([dx*grid,dy*grid,0])
        translate([gap/2,gap/2,zgap ? gap/2 : 0])
        cube([x*grid-gap,y*grid-gap,grid-(zgap ? gap : 0)]);
}

module naive_spinny(){
    translate([0,0,gap/2])
        cylinder(r=grid-gap/2,h=grid-gap);
    difference(){
        union(){
            icube(4,1);
            icube(4,1,-4,-1);
        }
        translate([0,0,-.1])
        cylinder(r=grid-gap/2,h=grid+.2);
    }
    difference(){
        union(){
            icube(4,1,0,-1);
            icube(4,1,-4,0);
        }
        translate([0,0,-.1])
        cylinder(r=grid+gap/2,h=grid+.2);
    }
}

module spinny(){
    translate([0,0,gap/2])
        cylinder(r=grid-gap/2,h=grid-gap);
    icube(2,1,1,0);
    icube(2,1,-3,-1);
    icube(2,1,-3,0);
    icube(2,1,1,-1);
    icube(2,1,0,0, zgap=true);
    icube(2,1,-2,-1, zgap=true);
}

module unspinny(){
    icube(1.5,1,1,0);
    icube(1.5,1,-2.5,-1);
    icube(1.5,1,-2.5,0);
    icube(1.5,1,1,-1);
    hull(){
        translate([grid+gap/2,gap/2,gap/2])
            cube([.001,grid-gap,grid-gap]);
        translate([-grid-gap/2,-grid+gap/2,gap/2])
            cube([.001,grid-gap,grid-gap]);
    }
}
//#rotate([0,0,45]) cube([100,.001,100], center=true);
lubonify() unspinny();