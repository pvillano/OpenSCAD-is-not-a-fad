
//thin wall thickness
twt = .879;
//bandaid thickness
bt = .8;

lwh1 = [79,33,1.4*40];
lwh2 = [96,36,1.4*35];
lwh3 = [96,43,1.4*25];

//bounding box
bbox = [100-1,44-1,152-1];

h3 = bbox[2]-twt*4;
rotate([0,-90,0]) difference(){
    translate([0,-twt,-twt]) cube(bbox);
    translate([bbox[0]-lwh1[0],0,0])
        cube([lwh1[0],bbox[1]+-2*twt,h3*.40]);
    
    translate([bbox[0]-lwh2[0],0,h3*.40+twt])
        cube([lwh2[0],bbox[1]+-2*twt,h3*.35]);
    
    
    translate([bbox[0]-lwh3[0],0,h3*.75+2*twt])
        cube([lwh3[0],bbox[1]+-2*twt,h3*.25]);
}
