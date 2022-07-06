

wall_thickness=1.67;


module funnel() import("funnel negative.stl");




difference(){
    minkowski(){
        funnel();
        cylinder(r=wall_thickness,h=.01);
    }
    funnel();
}