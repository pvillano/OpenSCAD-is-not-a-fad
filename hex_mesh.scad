

count=1;
thickness = 5;
spacing = 20;

module drawcubes(list, spacing=spacing, thickness=thickness){
    for(xyz12=list){
        xyz0=xyz12[0]*spacing;
        xyz1=xyz12[1]*spacing;
        hull(){
            translate([xyz0.x, xyz0.y, xyz0.z])
                cube(thickness, center=true);
            translate([xyz1.x, xyz1.y, xyz1.z])
                cube(thickness, center=true);
        }
    }
}
module ring(){
    difference(){
        drawcubes([
            [[1,1,0],[1,0,0]],
            [[0,1,1],[0,1,0]],
            [[1,0,1],[0,0,1]],
            [[1,0,1],[1,0,0]],
            [[1,1,0],[0,1,0]],
            [[0,1,1],[0,0,1]],
        ]);
        translate([-1,-1,-1]*(spacing/3+thickness/2)) hull(){
            translate([-2,2,2]*(spacing)) cube(thickness, center=true);
            translate([2,-2,2]*(spacing)) cube(thickness, center=true);
            translate([2,2,-2]*(spacing)) cube(thickness, center=true);
        }
    }
}

module parta(count=count) 
    for(x=[-count:count], y=[-count:count])
{
    if (abs(x-y)<count+1)
        translate([-1,1,0]*spacing*x + [0,-1,1]*spacing*y)
        children();
}


difference(){
    translate([1,1,1]*(-spacing/3+thickness/2)){
        color("red")
            translate([-1,1,0]*spacing/3)
            parta(){ring();}
        color("green")
            translate([0,-1,1]*spacing/3)
            parta(){ring();}
        color("blue")
            translate([1,0,-1]*spacing/3)
            parta(){ring();}
    }
    hull(){
        translate([-2,1,1]*(count+1)*spacing) cube(thickness, center=true);
        translate([1,-2,1]*(count+1)*spacing) cube(thickness, center=true);
        translate([1,1,-2]*(count+1)*spacing) cube(thickness, center=true);
    }
}
