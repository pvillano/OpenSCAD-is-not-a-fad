iw = 103;
il = 147;
ih = 18;
twt = 1.24;
slop = .15;
frac = 0.3333333333333333;//[0.08333333333333333:0.08333333333333333:1]
oh = ih + 2 * twt + slop;
ow = iw + 4 * twt + 2 * slop;
ol = il + 4 * twt + 2 * slop;
module bottom() {
    difference() {
        union() {
            translate([twt + slop, twt + slop, 0]) cube([iw + 2 * twt, il+ 2 * twt, ih + 1 * twt]);
            translate([0, 0, 0]) cube([ow, ol, (oh - slop) * frac]);
        }
        translate([2 * twt + slop, 2 * twt + slop, twt]) cube([iw, il, ih + .01]);
    }
}
module top() {
    difference() {
        cube([ow, ol, (oh - slop) * (1 - frac)]);
        translate([twt, twt, - .01]) cube([ow - 2 * twt, ol - 2 * twt, (oh - slop) * (1 - frac) - twt]);
    }
}

if($preview){
   difference() {
       union() {
           bottom();
           translate([0, 0, oh - (oh - slop) * (1 - frac)]) top();
       }
       translate([ow / 2, - 1, - 1]) cube(ow * 2);

       %bottom();
       %translate([0, 0, oh - (oh - slop) * (1 - frac)]) top();
   }
} else {
        translate([3,0,0]) bottom();
        translate([-ow-3,0,(oh - slop) * (1 - frac)]) mirror([0,0,1]) top();
}
