
dims = [633.14, 480.00, 5.67];
sea_level=2.11;

final_width=200;
final_thickness=1.7;
final_height=10;

support_thickness=.452;
support_height=.3;
test=false;

final_length=final_width*dims[1]/dims[0];
ratio=final_width/dims[0];

module colorado(){
    if($preview || test){
        cube([dims[0],dims[1],sea_level]);
        translate([dims[0]/4,0,0])
            cube([dims[0]/2,dims[1]/2,dims[2]]);
    } else {
        translate([0,dims[1],0]) import("Terrain2STL colorado.stl");
    }
}

module menorado() difference(){
    translate([0,0,final_thickness])
        scale([ratio,ratio,(final_height-final_thickness)/(dims[2]-sea_level)])
        translate([0,0,-sea_level])
        colorado();
    translate([-.1,-.1,-5])
        cube([final_width+.2,final_length+.2,5]);
}


/*
for(dx=[0,final_width-final_thickness])
    translate([dx,0,0])
    hull()
{
    cube(final_thickness);
    translate([0,0,final_length-final_thickness])cube(final_thickness);
    translate([0,final_width/3,0]) cube(final_thickness);
}
translate([-5,final_width/6,0]) cube([final_width+10,final_width/6+5,.3]);
*/
translate([-final_width/2,0,0]){
    rotate([90,0,0]) menorado();
    for(i=[.25,.5,.75]){
        dx=i*final_width;
        translate([dx,0,0]) difference(){
            cylinder(h=final_length,r1=final_width/4,r2=support_thickness);
            translate([0,0,support_height]) 
                cylinder(h=final_length-support_height,r1=final_width/4-support_thickness,r2=0);
            translate([-final_width/4,-final_width/4,-.1])
                cube([final_width/2,final_width/4,final_length]);
            translate([0,0,-.1])
                cylinder(r=final_width/4-10, center=true);
        }
    }
}