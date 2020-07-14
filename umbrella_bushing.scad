$fa = .01;
$fs = $preview ? 1 :.3;

wood_slop = 1;

difference(){
    union(){
        cylinder(d=69 - wood_slop,h=9 - wood_slop); 
        cylinder(d=59 - wood_slop,h=26);    
    }
    cylinder(d=39,h=27);
}