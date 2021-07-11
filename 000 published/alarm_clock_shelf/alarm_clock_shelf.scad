$fa = .01;
$fs = $preview ? 5 : 1;

width = 170;
depth = 58+5;
d=width*.378 + 10;
base_thickness = 5;


module clock_base(h){
    translate([d,d,0]) rotate([0,0,-45]) scale([1,depth/width,1]) cylinder(h=h,r=width/2);
}

module shelf_void(){
    intersection(){
        cube([200,200,base_thickness]);
        minkowski(){
            clock_base(base_thickness);
            rotate([0,0,180]) cube([1, 200, 1]);
            rotate([0,0,180]) cube([200, 1, 1]);
        }
    }
}

module shelf(){
    minkowski(){
        shelf_void();
        intersection(){
            cube(base_thickness);
            cylinder(h=base_thickness, r=base_thickness);
        }
    }
}

module whole_shelf(){
    difference(){
        union(){
            difference(){
                shelf();
                translate([0, 0, base_thickness]) scale([1,1,1.1]) shelf_void();
            }
            translate([0,0,base_thickness]) scale([1,1,.3]){
                rotate([ 0,-90,-90]) scale([1,1,.5]) shelf();
                rotate([90,  0, 90]) scale([1,1,.5]) shelf();
            }
        }
        cylinder(h=30/tan(55),r1=30, r2=0);
    }
}

whole_shelf();