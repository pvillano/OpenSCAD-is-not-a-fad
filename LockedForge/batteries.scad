use <LockedForge.scad>

$fa = .01;
$fs = .3;

unit=25.4;

AAA = [10.5, 44.5];
AA = [14.5, 50.5];
D = [43.2, 61.5];

V9 = [26.5, 17.5, 48.5];

CR2032 = [20, 3.2];
LI18650 = [18, 65];

module battery_holder(d, min_sep=3, x = 3, y = 3, h = 25.4 / 2, unit = 25.4) {
    x_count = floor(x*unit/(d+min_sep));
    y_count = floor(y*unit/(d+min_sep));
    difference() {
        cube([x * unit, y * unit, h]);
        for(i=[.5:x_count],j=[.5:y_count]){
            translate([i*x*unit/x_count,j*y*unit/y_count,2])
            cylinder(d=d,h=h);
        }
        top_holes(x, y, h = h - 2);
    }
}
battery_holder(AAA[0]+.3);

translate([unit*4,0,0]) battery_holder(AA[0]+.3);
translate([0,unit*4,0]) battery_holder(CR2032[0]+.3);