$fa=.01;
$fs=3;
// bottle outer diameter must be an overapproximation!
bottle_od = 40.3;
// fillet radius must be an underapproximation!
bottle_fillet_r = 5;

count=6;
spacing=5;

angle=360/count;
halfangle=angle/2;

hex_correction = 1/cos(30);

module bottle(hex=false){
    translate([0,0,bottle_fillet_r]) minkowski() {
        sphere(r = bottle_fillet_r);
        if(hex){
            rotate([0,0,30]) cylinder(h = 70 - 2 * bottle_fillet_r, d = hex_correction*(bottle_od - 2 * bottle_fillet_r), $fn=6);
        } else {
            cylinder(h = 70 - 2 * bottle_fillet_r, d = bottle_od - 2 * bottle_fillet_r);
        }
    }
        cylinder(d=25,h=85);
        cylinder(d=7,h=105);
}

module main(){
    difference(){
        union(){
            translate([0,0,-spacing]) minkowski(){
                rotate([0,0,30])cylinder(d=bottle_od*3+4*spacing, h=30, $fn=6);
                cylinder(r1=0, r2=spacing, h=spacing);
            }
        }


        %bottle(hex=false);
        bottle(hex=true);
        for(i=[0:5]){
            rotate([0,0,i*angle]) translate([bottle_od+spacing/2,0,0]) {
                %bottle(hex=false);
                bottle(hex=true);
            }
        }
    }
}

module testfit(){
    difference(){
        cylinder(d=bottle_od+4, h=30);
        translate([0,0,2]) bottle();
    }
}

main();