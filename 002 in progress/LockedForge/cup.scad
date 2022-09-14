use <LockedForge.scad>

$fa = .01;
$fs = $preview ? 3 : 1;
unit = 25.4;

twt=1.67;
height = 50;
waist = .8;

module hollow_hyperboloid(h = 10, r0 = 3, r1 = 5, t = 1) {
    fn= round(h/$fs);
    points = concat(
    [for (z = [- .5:1 / fn:.5]) [sqrt(4 * (r1^2 - r0^2) * (z^2) + r0 * r0), z * h]],
    [for (z = [.5:- 1 / fn:- .5]) [sqrt(4 * (r1^2 - r0^2) * (z^2) + r0 * r0) - t, z * h]]
    );
    translate([0,0,h/2]) rotate_extrude() polygon(points);
}

module swab_holder(d, x = 3, y = 3, h = 25.4 / 2, unit = 25.4) {
    r1=min(x * unit/2, y * unit/2)-2*twt;
    r0 = r1 * waist;
    translate([x * unit/2, y * unit/2, h-.01])
        hollow_hyperboloid(h=height, r0=r0, r1=r1,t=twt);
    difference() {
        cube([x * unit, y * unit, h]);

        translate([x * unit/2, y * unit/2, h])
            scale([1,1,.3])
            sphere(r=r1-twt);
        top_holes(x, y, h = h - 2);
    }
}


difference(){
    swab_holder();
    if($preview) cube([3 * unit/2, 3 * unit/2,99999]);
}