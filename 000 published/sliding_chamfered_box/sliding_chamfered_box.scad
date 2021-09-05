/* Villano OpenSCAD 2021.1 */
Interior_Width=190; //[300]
Interior_Depth = 110; //[300]
Interior_Height=23; //[300]
Wall_Thickness=2.5; //[1:.5:30]
Clearance=.25; //[0:.05:1]

w=Interior_Width;
d=Interior_Depth;
h=Interior_Height;
twt=Wall_Thickness;
slop=Clearance;

module octahedron(r){
    scale(r) polyhedron(
        points=[
            [ 0,  0,  1],
            [ 1,  0,  0],
            [ 0,  1,  0],
            [-1,  0,  0],
            [ 0, -1,  0],
            [ 0,  0, -1],
        ],
        faces=[
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 4],
            [0, 4, 1],
            [5, 2, 1],
            [5, 3, 2],
            [5, 4, 3],
            [5, 1, 4],
        ]
    );
}

module drawer(w,d,h,solid=false) {
    difference(){
        union(){
            minkowski(){
                cube([w,d,h-twt],center=true);
                octahedron(twt);
            }
            translate([0,0,-twt]) intersection(){
                minkowski(){
                    cube([w-2*twt,d-2*twt,h-3*twt],center=true);
                    rotate([0,90,0])
                        cylinder(r=2*twt,h=2*twt,center=true,$fn=4);
                }
                minkowski(){
                    cube([w-2*twt,d-2*twt,h-3*twt],center=true);
                    rotate([90,0,0])
                        cylinder(r=2*twt,h=2*twt,center=true,$fn=4);
                }
            }
        }
        if (!solid) translate([0, 0, twt/2+.01])
            cube([w,d,h], center=true);
    }
}
module lid() translate([0,twt/2,0]) difference(){
    minkowski(){
        cube([w,d-twt+2*slop,h-twt], center=true);
        octahedron(2*twt+slop);
    }
    translate([0,-twt/2,0]) minkowski(){
        drawer(w,d+2*slop,h,solid=true);
        octahedron(slop+.01);
    }
}

translate([0,-d/2-twt,0]) drawer(w,d,h);
translate([0,d/2+twt,0]) lid();