width = 70.0;
depth = 98.6;
height = 26.8;

wall_thicknesses = [0,.68,1.28];
loose=.4;
dovetail_width=10;
dovetail_height = wall_thicknesses[1];
dovetail_angle=30;


module mirror2(xyz){
    mirror(xyz) children();
    children();
}

module base(){
    cube([width, depth, height]);
}

%base();

module encasement(){
    difference(){
        minkowski(){
            cube([width+loose, depth+loose, height+loose]);
            sphere(r=wall_thicknesses[1]);
        }
        base();
    }
}

//encasement();

module dove_flat(){
    mirror2([0,1])
        translate([0,height/2])
        polygon([
            [tan(dovetail_angle)*dovetail_height,dovetail_height],
            [0,0],
            [dovetail_width,0],
            [dovetail_width-tan(dovetail_angle)*dovetail_height,dovetail_height]]);
}

module dove(){
    linear_extrude(height=20){
        dove_flat();
    }
    linear_extrude(height=dovetail_height){
        hull() dove_flat();
    }
}
module assembly(){
    translate([0,-dovetail_height,height/2]) rotate([-90,0,0]) dove();
}
assembly();