$fs=1;
$fa=.01;
use <threads.scad>

d_gear=50;
n_teeth=20;
twt=1.24; //thin wall thickness
sliding_slop = .3; // for dovetails
thread_pitch=4;

w_dovetail = 10;
h_dovetail = 5;
a_dovetail=1;

h_outer = 50;
h_middle = h_outer - twt - (h_dovetail + twt);
h_inner = h_middle - twt;

/* calculated */
rtooth=d_gear/n_teeth/4;
d_thread = d_gear*(n_teeth-1)/n_teeth - 2*twt;

// from https://github.com/mechadense/scad-lib-cyclogearprofiles/blob/master/lib-cyclogearprofiles.scad
module cyclogearprofile(rtooth=4,nteeth=5,vpt=0,verbouse=0) {
  // functions for generation of hypo- and epicycloids
  //asserted: r1 > r2 (& divisible without remainder)!! <<<<<<< TODO check for that
  function hypo_cyclo(r1,r2,phi) =
   [(r1-r2)*cos(phi)+r2*cos(r1/r2*phi-phi),(r1-r2)*sin(phi)+r2*sin(-(r1/r2*phi-phi))];
  function epi_cyclo(r1,r2,phi) =
   [(r1+r2)*cos(phi)-r2*cos(r1/r2*phi+phi),(r1+r2)*sin(phi)-r2*sin(r1/r2*phi+phi)];
  // alternating hypo- and epicycloids
  function epihypo(r1,r2,phi) =
    pow(-1, 1+floor( (phi/360*(r1/r2)) )) <0 ? epi_cyclo(r1,r2,phi) : hypo_cyclo(r1,r2,phi);

  // make sure the number of teeth-groove pairs is a positive natural number
  n = max(floor(nteeth),1);

  rrollcircle = rtooth*(2*n);
  // vpt ... vertices per tooth
  usedvpt = vpt>0 ? vpt : ( ($fn>0) ? $fn :
            ceil(min( (360/$fa)/(2*n) , (2*rrollcircle*3.141592653/$fs)/(2*n) ))
            )*3; //modified here: added * 3
  npoints = n*usedvpt;

  if(verbouse>0)
  {
    echo("the gear with ID: ",verbouse);
    echo(rtooth=rtooth,nteeth=nteeth);
    echo("the gears rolling radius is: ", rrollcircle);
    if(vpt==0) echo("used for the resolution: ",$fa=$fa,$fs=$fs,$fn=$fn);
    echo("this gear has a resolution of ",usedvpt, " verices per tooth");
    echo("this makes ",npoints, " verices in total");
  }

  list1ToN  = [ for (i = [0 : npoints]) i ];
  pointlist = [ for (i = list1ToN) epihypo(rrollcircle,rtooth,360/npoints*i) ];
  polygon(points = pointlist, paths = [list1ToN],convexity = 6);
}

module dovetail(width, length, angle = 15, center = false) {
  rotate([90, 0, 180])linear_extrude(length, center = center)
    polygon([[- width / 2, 0], [width / 2, 0], [0, width / 2 * tan(90 - angle / 2)]]);
}

module outer(){
    linear_extrude(h_outer) difference() {
        offset(r=twt) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
        cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
    }
    //bottom
    linear_extrude(twt)
        offset(r=twt) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
    //dovetail
    intersection(){
        linear_extrude(h_outer)
            offset(r=twt)
                cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
        translate([0,0,h_dovetail+twt]) mirror([0,0,1]) dovetail(w_dovetail,d_gear*1.2,a_dovetail, center=true);
    }
}

module middle(){
    difference(){
        linear_extrude(h_middle) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth);
        ScrewThread(d_thread*1.01+sliding_slop, pitch=thread_pitch, height = h_middle+.1);
    }
    linear_extrude(twt) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth);
}

module inner(){
    difference(){
        ScrewThread(d_thread, pitch=thread_pitch, height = h_inner);
        translate([0,0,h_dovetail+twt]) cylinder(d=d_thread-2*thread_pitch-2*twt, h = h_inner + .1);
        translate([0,0,h_dovetail]) mirror([0,0,1]) dovetail(w_dovetail + sliding_slop,d_thread+.1,a_dovetail, center=true);
    }
}

module wobbler(){
    intersection(){
        cylinder(d=d_gear/2,h=2*h_dovetail+twt);
        difference(){
            union(){
                rotate([0,0,90])translate([0,0,2*h_dovetail+twt]) mirror([0,0,1]) dovetail(w_dovetail,d_gear/2,a_dovetail, center=true);
                cylinder(d=d_gear/2, h=h_dovetail+twt);
            }
            translate([0,0,h_dovetail]) mirror([0,0,1]) dovetail(w_dovetail + sliding_slop,d_gear/2,a_dovetail, center=true);
        }
    }

}


wobbler();
