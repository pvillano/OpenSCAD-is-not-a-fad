$fs = 3;
$fa = .01;
use <threads.scad>


h_outer = 50;
d_outer = 50;

twt = 1.24; //thin wall thickness
sliding_slop = .3; // for dovetails
thread_pitch = 4;

w_dovetail = 10;
h_dovetail = 5;
a_dovetail = 1;

n_teeth = 20;

/* calculated */
d_middle = d_outer - 2 * twt - 2 * 2 * sin(30) * thread_pitch;
d_gear = d_middle - d_middle / n_teeth / 4 - 2 * twt;
r_tooth = d_gear / n_teeth / 4;
d_small_gear_inside = d_gear - 14 * r_tooth;

// from https://github.com/mechadense/scad-lib-cyclogearprofiles/blob/master/lib-cyclogearprofiles.scad
module cyclogearprofile(rtooth = 4, nteeth = 5, vpt = 0, verbouse = 0) {
  // functions for generation of hypo- and epicycloids
  //asserted: r1 > r2 (& divisible without remainder)!! <<<<<<< TODO check for that
  function hypo_cyclo(r1, r2, phi) =
    [(r1 - r2) * cos(phi) + r2 * cos(r1 / r2 * phi - phi), (r1 - r2) * sin(phi) + r2 * sin(- (r1 / r2 * phi - phi))];
  function epi_cyclo(r1, r2, phi) =
    [(r1 + r2) * cos(phi) - r2 * cos(r1 / r2 * phi + phi), (r1 + r2) * sin(phi) - r2 * sin(r1 / r2 * phi + phi)];
  // alternating hypo- and epicycloids
  function epihypo(r1, r2, phi) =
    pow(- 1, 1 + floor((phi / 360 * (r1 / r2)))) < 0 ? epi_cyclo(r1, r2, phi) : hypo_cyclo(r1, r2, phi);

  // make sure the number of teeth-groove pairs is a positive natural number
  n = max(floor(nteeth), 1);

  rrollcircle = rtooth * (2 * n);
  // vpt ... vertices per tooth
  usedvpt = vpt > 0 ? vpt : (($fn > 0) ? $fn :
          ceil(min((360 / $fa) / (2 * n), (2 * rrollcircle * 3.141592653 / $fs) / (2 * n)))
  ) * 3; //modified here: added * 3
  npoints = n * usedvpt;

  if (verbouse > 0)
  {
    echo("the gear with ID: ", verbouse);
    echo(rtooth = rtooth, nteeth = nteeth);
    echo("the gears rolling radius is: ", rrollcircle);
    if (vpt == 0) echo("used for the resolution: ", $fa = $fa, $fs = $fs, $fn = $fn);
    echo("this gear has a resolution of ", usedvpt, " verices per tooth");
    echo("this makes ", npoints, " verices in total");
  }

  list1ToN = [for (i = [0 : npoints]) i];
  pointlist = [for (i = list1ToN) epihypo(rrollcircle, rtooth, 360 / npoints * i)];
  polygon(points = pointlist, paths = [list1ToN], convexity = 6);
}

module dovetail(width, length, angle = 15, center = false) {
  rotate([90, 0, 180])linear_extrude(length, center = center)
  polygon([[- width / 2, 0], [width / 2, 0], [0, width / 2 * tan(90 - angle / 2)]]);
}


module outer() {
  difference() {
    cylinder(d = d_outer, h = h_outer);
    translate([0, 0, twt]) ScrewHole(outer_diam = d_outer - 2 * twt, height = h_outer, pitch = thread_pitch, tolerance =
    sliding_slop);
    translate([0, 0, - .1]) cylinder(d1 = d_small_gear_inside, d2 = d_small_gear_inside - 2 * twt, h = twt + .2);
  }
}

module middle() {
  difference() {
    ScrewThread(outer_diam = d_outer - 2 * twt, height = h_outer - twt, pitch = thread_pitch, tolerance = sliding_slop);
    translate([0, 0, twt]) linear_extrude(h_outer) cyclogearprofile(r_tooth, n_teeth);
  }
}

module inner() {
  linear_extrude(h_outer) difference() {
    cyclogearprofile(r_tooth, n_teeth - 1);
    offset(- twt) cyclogearprofile(r_tooth, n_teeth - 1);
  }
  difference() {
    linear_extrude(twt) cyclogearprofile(r_tooth, n_teeth - 1);
    translate([0, 0, - .1]) cylinder(d1 = d_small_gear_inside - 2 * twt, d2 = d_small_gear_inside, h = twt + .2);
  }
}

module mirror2(xyz) {
  mirror(xyz) children();
  children();
}

module wobbler() {
  difference() {
    cylinder(d2 = d_small_gear_inside - 2 * twt - sliding_slop, d1 = d_small_gear_inside - sliding_slop, h = twt);
    translate([r_tooth, 0, - .1]) mirror2([1, 0, 0]) translate([d_small_gear_inside / 4, 0, 0]) cylinder(d = 3.7, h =
      twt + .2);
  }
}
middle();
translate([d_outer, 0, 0]) outer();
translate([0, d_outer, 0]) inner();
translate([d_outer * .75, d_outer, 0]) wobbler();
translate([d_outer * 1.5, d_outer, 0]) wobbler();