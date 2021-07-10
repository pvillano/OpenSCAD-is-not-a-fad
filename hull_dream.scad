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


module outer_shell(thickness=1){
    difference(){
        minkowski(){
            children();
            sphere(r=thickness);
        }
        children();
    }
}

module inner_shell(thickness = 1){
    intersection(){
        children();
        minkowski(){
            sphere(r=thickness);
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
    }
}



module thingy(){
    union(){
        translate([0,0,14]) cube(20, center=true);
        cube(10, center=true);
    }
}

supported_hollow(step=45, thickness=1) thingy();





