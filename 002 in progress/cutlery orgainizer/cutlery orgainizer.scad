$fa =.01;
$fs = 1;

width = 175;
num_things=4;
neck=10;

spacing=width/num_things;
diameter=(spacing-neck);
height=20;
thickness=4;
intersection(){
        cube([diameter, width, 2*height]);
    union(){
        cube([diameter, width, thickness]);
        for(i=[0:num_things]){
            translate([diameter/2,i*spacing,0]) cylinder(h=height,d=diameter);
            translate([diameter/2,i*spacing,height]) scale([1,1,.3]) sphere(d=diameter);
        }
    }
}
