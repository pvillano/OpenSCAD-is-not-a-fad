$fa = .01;
$fs = $preview ? 10 : 10;

slop = .5;
edge=5.09;
twt=1.67;
nullspc=.5;

module k(){
    projection() scale(1.5) import("Korea_local_name.stl", convexity=20);
}
module b(){
    linear_extrude(edge){
        difference(){
            offset(edge) k();
            offset(nullspc-twt/2) k();
        }
    }
    linear_extrude(edge/2) offset(edge) k();
}

module p() intersection(){
    scale(1.5) import("Korea_local_name.stl", convexity=20);
    linear_extrude(center=true) offset(nullspc-twt/2-slop) projection() scale(1.5) import("Korea_local_name.stl", convexity=20);
}
rotate([0,0,261]){
    b();
    //p();
}
