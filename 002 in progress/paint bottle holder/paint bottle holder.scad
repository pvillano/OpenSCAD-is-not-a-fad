$fa=.01;
$fs=1;
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


module neg(bot=true){
    if(bot) %bottle();
    rotate([0,0,30]) cylinder(d=hex_correction*bottle_od, h=40, $fn=6);
    for(i=[0:5]){
        rotate([0,0,i*angle]) translate([bottle_od+spacing,0,0]) {
            if(bot) %bottle(hex=false);
            rotate([0,0,30]) cylinder(d=hex_correction*bottle_od, h=40, $fn=6);
        }
    }
}



module main(){
    difference(){
        minkowski(){
            neg();
            cylinder(r1=0, r2=spacing, h=spacing);
        }
        translate([0,0,spacing]) spikee(d=bottle_od, h=5);
        translate([0,0,spacing]) scale([1,1,2]) neg(bot=false);
    }
}

module spiker(d, h){
    for(i=[0:5]) rotate(60*i) intersection(){
        cube(999);
        rotate([0,0,60]) cube(999);
        cylinder(d=hex_correction*d, h=h, $fn=6);
    }
    cylinder(d=d, h=h);
}


module spikee(d, h) mirror([0,1,0]) rotate([0,0,30]){
    for(i=[0:5]) rotate(60*i) intersection(){
        cube(999);
        rotate([0,0,60]) cube(999);
        cylinder(d=hex_correction*d, h=h);
    }
    cylinder(d=hex_correction*d, h=h, $fn=6);
}

module column(){
    translate([0,0,spacing]) spiker(d=bottle_od-.4, h=spacing-.4);
    translate([0,0,spacing]) cylinder(d=bottle_od-.4, h=50);
}

module testmain(){
    difference(){
        minkowski(){
            rotate([0,0,30]) cylinder(d=hex_correction*bottle_od, h=10, $fn=6);
            cylinder(r1=0, r2=spacing, h=spacing);
        }
        translate([0,0,spacing]) spikee(d=bottle_od, h=spacing);
        translate([0,0,spacing]) scale([1,1,2]) rotate([0,0,30]) cylinder(d=hex_correction*bottle_od, h=40, $fn=6);
    }
}


module testcolumn(){
    translate([0,0,spacing]) spiker(d=bottle_od-.4, h=spacing-.4);
    translate([0,0,spacing]) cylinder(d=bottle_od-.4, h=spacing*2);
    translate([0,0,spacing*3]) cube([bottle_od/2,spacing,spacing*2], center=true);
}

column();

//color("red")translate([0,0,20]) column();
