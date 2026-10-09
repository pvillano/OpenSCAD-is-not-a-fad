$fa=.01;
$fs=.1;

chisel_diameter=11.8;
chisel_length=135;
cap_depth=20;
twt=1.5;
slop=.2;

module mirror2(xyz){
    mirror(xyz) children();
    children();
}

module inner_shape() offset(1) hull()
#for(th=[0,120,240])
    rotate(th)
    mirror2([0,1,0])
    {
    translate(chisel_diameter*[1/cos(30)*.5+1*cos(30),1/2])
        circle(d=chisel_diameter);
    translate(chisel_diameter*[1/cos(30)*.5,0])
        circle(d=chisel_diameter);
    translate(chisel_diameter*[1/cos(30)*.5,1])
        circle(d=chisel_diameter);
    }

module body() difference(){
    translate([0,0,-1])linear_extrude(chisel_length) offset(twt) inner_shape();
    linear_extrude(chisel_length) inner_shape();
}

module cap() difference(){
    union(){
        translate([0,0,-1]) linear_extrude(cap_depth) offset(-slop) inner_shape();
        translate([0,0,-1]) linear_extrude(5) offset(twt) inner_shape();
    }
    linear_extrude(chisel_length) offset(-twt-slop) inner_shape();
}

body();