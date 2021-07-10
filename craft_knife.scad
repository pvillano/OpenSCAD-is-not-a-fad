$fa = .01;
$fs = $preview ? 1 : .5;

r_stick = 4.6;
blade_in_ness = 1.5;
l_stick = 30;

d_magnet = 8.03;
h_magnet = 2.69;

h_blade = 0.50;
w_blade = 5.66;
l_blade = 11;

if($preview) translate([100,100,0]){
    translate([h_blade/2,0,0]) rotate([0,90,0]) cylinder(d=d_magnet, h=h_magnet);
    translate([-h_blade/2,0,0]) rotate([0,-90,0]) cylinder(d=d_magnet, h=h_magnet);

    cube([h_blade,l_blade,w_blade], center=true);
    
}

difference(){
    translate([0,0,-h_blade/2]) hull(){
        sphere(r=r_stick);
        translate([0,l_stick,0]) sphere(r=r_stick);
    }
    translate([0,0,-500]) cube(1000, center=true);
    translate([0,0,.20]) cylinder(d=d_magnet, h=h_magnet);
    translate([0,d_magnet,.20]) cylinder(d=d_magnet, h=h_magnet);
}


translate([r_stick*3,0,0]) difference() {
    intersection(){
        translate([0,0,-h_blade/2]) hull(){
            sphere(r=r_stick);
            translate([0,l_stick,0]) sphere(r=r_stick);
        }
        
        cube([1000,1000,h_blade], center=true);
    }
    hull(){
        translate([0,blade_in_ness,0]) cube([w_blade,l_blade,h_blade+1], center=true);
    }
}