$fs = 1;
$fa = .01;
use <threads.scad>


h_outer = 20;
d_outer = 50;
h_bottom = 4;

twt = 1.24; //thin wall thickness
sliding_slop = .4; // for screw
thread_pitch = 3;

n_teeth = 10;
wobbler_teeth=3;

/* calculated */
d_middle = d_outer - 2 * twt - 2 * 2 * sin(30) * thread_pitch;
d_gear = d_middle - d_middle / n_teeth / 4 - 2 * twt;
r_tooth = d_gear / n_teeth / 4;
d_small_gear_inside = d_gear - 14 * r_tooth;

d_screw = d_outer - 2 * twt;
d_wobbler = d_outer - 2 * r_tooth;

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

module mirror2(xyz) {
  mirror(xyz) children();
  children();
}

module discus(h, r, e=0, center=false){
  dh = center ? 0 : h/2;
  translate([0,0,dh])
    render() mirror2([0,0,1])
    cylinder(h=h/2+e, r1=r+e, r2=r-h/2+e);
}

module plug(h,r,e=0){
  cylinder(h=h+e,r=r+e, center=true);
  cylinder(h=h/2+e, r1=r+e, r2=r+h/2+e);
}

module outer() {
  difference() {
    cylinder(d = d_outer+2*sliding_slop, h = h_outer);
    translate([0, 0, h_bottom]) ScrewHole(outer_diam = d_screw, height = h_outer, pitch = thread_pitch, tooth_angle=45, tolerance =
    sliding_slop);
    translate([0,0,h_bottom/2]) mirror([0,0,1]) plug(h=h_bottom, r=10, e=sliding_slop);
  }
}

module middle() {
  difference() {
    ScrewThread(outer_diam = d_screw, height = h_outer - h_bottom, pitch = thread_pitch, tooth_angle=45, tolerance = 0);
    translate([0, 0, h_bottom]) linear_extrude(h_outer) cyclogearprofile(r_tooth, n_teeth);
  }
}

module inner() {
  linear_extrude(h_outer-h_bottom) difference() {
    cyclogearprofile(r_tooth, n_teeth - 1);
    offset(- twt) cyclogearprofile(r_tooth, n_teeth - 1);
  }
  difference() {
    linear_extrude(h_bottom) cyclogearprofile(r_tooth, n_teeth - 1);
    translate([0,0,h_bottom/2]) plug(h=h_bottom, r=10, e=sliding_slop);
 }
}

module wobbler() {
  translate([0,0,h_bottom/2]) plug(h=h_bottom, r=10);
  translate([r_tooth,0,-h_bottom/2]) mirror([0,0,1]) plug(h=h_bottom, r=10);
}

module wobbler2(){
  difference(){
    translate([0,0,h_bottom/2]) mirror([0,0,1]) plug(h=h_bottom, r=10);
    translate([0,0,h_bottom/2]) mirror2([1,0,0]) translate([5,0,0]) cylinder(d=4,h=h_bottom+.2, center=true);
    #linear_extrude(1, center=true) text("0", size=4, halign="center", valign="center");
  }
  translate([0,d_outer,0]) difference(){
    translate([0,0,h_bottom/2]) mirror([0,0,1]) plug(h=h_bottom, r=10);
    translate([0,0,h_bottom/2]) mirror2([1,0,0]) translate([5,r_tooth,0]) cylinder(d=4,h=h_bottom+.2, center=true);
    #linear_extrude(1, center=true) text("1", size=4, halign="center", valign="center");
  }
  translate([0,d_outer*2,0]) difference(){
    translate([0,0,h_bottom/2]) mirror([0,0,1]) plug(h=h_bottom, r=10);
    translate([0,0,h_bottom/2]) mirror2([1,0,0]) translate([5,r_tooth*2,0]) cylinder(d=4,h=h_bottom+.2, center=true);
    #linear_extrude(1, center=true) text("2", size=4, halign="center", valign="center");
  }
}

module handle(){
  difference(){
    cylinder(h=5, d=d_outer);
    translate([0,0,.6]) mirror2([1,0,0]) translate([5,0,0]) cylinder(d=3.2,h=5);
  }
}

//middle();
handle();
translate([d_outer+4, 0, 0]) outer();
translate([0, d_outer, 0]) inner();
translate([d_outer, d_outer, 0]) wobbler2();

