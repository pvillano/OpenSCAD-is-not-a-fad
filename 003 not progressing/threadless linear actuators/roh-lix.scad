rod_diameter = 5;
bearing_od = 22;
bearing_id = 8;
bearing_width = 7;
thread_pitch = 3;
rod_length=300;

//module rod(diameter=rod_diameter, length=rod_length)
//nvm that's just a cylinder

module bearing(od=bearing_od, id=bearing_id, width=bearing_width,center=false){
    difference(){
        cylinder(d=od,h=width, center=center);
        translate([0,0,(center? 0: -.1)]) cylinder(d=id,h=width+.2, center=center);
    }
}

//bearing();
module demo(){
    twist = atan2(thread_pitch, rod_diameter*PI);
    for(azimuth=[0,120,240]){
        rotate([0,0,azimuth])
            translate([bearing_od/2+rod_diameter/2,0,0])
            rotate([twist,0,0])
            bearing(center=true);
    }
    #cylinder(d=rod_diameter, h=rod_length, center=true);
}


demo();