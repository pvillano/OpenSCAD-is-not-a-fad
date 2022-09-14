
// O(n^2)
module outer_shell(thickness=1){
    difference(){
        minkowski(){
            children();
            sphere(r=thickness);
        }
        children();
    }
}

// O(n^4)+
module inner_shell(thickness=1){
    intersection(){
        children();
        outer_shell(){
            outer_shell(){
                children();
            }
        }
    }
}
// O(n^4)
module balanced_shell(thickness=1){
    minkowski(){
        sphere(thickness/2);
        difference(){
            minkowski(){
                children();
                cube(.1, center=true);
            }
            children();
        }
    }
}