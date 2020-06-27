$fa = .01;
$fs = $preview ? 1 :.2;


r_handle = 27;
translate([0,0,-.5]){
    cube([145,95,1], center=true);
}
difference(){
    translate([0,0,22]){
        cube([15,95,44], center=true);
    }
    translate([0,95/2,r_handle]){
        rotate([0,90,0]){
            cylinder(h=16,r=r_handle,center=true);
        }
    }
    translate([0,-95/2,r_handle]){
        rotate([0,90,0]){
            cylinder(h=16,r=r_handle,center=true);
        }
    }
}