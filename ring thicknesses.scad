$fa = .01;
$fs = $preview ? 10 : 1;

num_rings = 7;
mean_diameter = 8 * 25.4;
thickness = .45;
offset = 2; //gap + thickness
height = thickness * 10;


for(i=[-num_rings/2:num_rings/2]){
    d0 = mean_diameter + offset*i;
    difference(){
        cylinder(height, d=d0+thickness/2, center=true);
        cylinder(height+.1, d=d0-thickness/2, center=true);
    }
}