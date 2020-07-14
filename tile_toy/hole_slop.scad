$fa = .01;
$fs = 1;

for(i=[0:5]){
    translate([i*5,0,0]){
        difference(){
            cube(5,center=true);
            rotate([90,0,0]) cylinder(h=60, d=2+i*.05, center=true);
        }
    }
}
