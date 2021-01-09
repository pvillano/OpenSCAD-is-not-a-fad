FAST = true;

module tetrahedron(r){
    scale(r/sqrt(1+.5)) polyhedron(
        points=[
            [-1,  0, -sqrt(.5)],
            [ 1,  0, -sqrt(.5)],
            [ 0, -1,  sqrt(.5)],
            [ 0,  1,  sqrt(.5)],
        ],
        faces=[
            [0, 1, 3],
            [0, 2, 1],
            [0, 3, 2],
            [1, 2, 3],
        ]
    );
}

module spher(r){
    if(FAST)
        tetrahedron(r);
    else
        sphere(r);
}


module wedge(theta=10,l=1000, center=false){
    if(center){
        translate([0,0,-l/2]) rotate([0,0,theta/2]) intersection(){
            cube(l*2);
            rotate(90-theta)cube(l);
        }
    } else{
        intersection(){
            cube(l*2);
            rotate(90-theta)cube(l);
        }
    }
}

module spike(theta=10,l=1000){
    intersection(){
        wedge(theta, l, center=true);
        rotate([0,90,0]) wedge(.1, l, center=true);
    }
}

module slice(theta){
    minkowski(){
            intersection(){
            wedge(theta=theta, center=true);
            children();
        }
        rotate([-45,0,0]) spike(theta=theta);
    }
}


module outer_shell(thickness = 1){
    difference(){
        minkowski(){
            children();
            spher(r=thickness);
        }
        children();
    }
}

module inner_shell(thickness = 1){
    intersection(){
        children();
        minkowski(){
            spher(r=thickness);
            difference(){
                cube(1000, center=true);
                children();
            }
        }
    }
}

module supported_hollow(thickness=3,step=45, preview=true){
    intersection(){
        minkowski(){
            children();
            sphere(r=thickness);
        }
        for(i=[step:step:360]){
            rotate(-i) slice(step) rotate(i) inner_shell(thickness) children();
        }
        if(preview){
            l = 1000;
            translate([l/2,0,0]) cube(l, center=true);
        }
        difference(){
            children();
            cylinder(r=1,h=thickness*2.01, center=true);
        }
    }
}
supported_hollow(thickness=3,step=20, preview=false) translate([0,10,0]) import("charmander_fixed.stl");