$fa =.01;
$fs = $preview ? 3 : .3;

inch = 25.4;

tube_d = 1.98 * inch;

slop = .1; //4.9 in a 5.0 hole

margin=5;
thickness = 5;
degrees_clamp = 3;

difference(){
    cube([tube_d+margin*2+slop, tube_d+margin*2+slop, thickness], center=true);
    cylinder(d=tube_d+slop,h=thickness+.2, center=true);
    translate([0,0,-thickness/2-.1])intersection(){
        rotate([0,0,degrees_clamp/2]) cube([tube_d+margin,tube_d+margin,thickness+.2]);
        rotate([0,0,90-degrees_clamp/2]) cube([tube_d+margin,tube_d+margin,thickness+.2]);
    }
}