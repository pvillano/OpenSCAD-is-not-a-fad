$fs=1;
$fa=.01;
use <threads.scad>

d_gear=100;
n_teeth=20;
twt=2; //thin wall thickness
sliding_slop = .3; // for dovetails
thread_pitch=4;

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
    linear_extrude(100) difference() {
        offset(r=twt) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
        cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
    }
    //bottom
    mirror([0,0,1]) linear_extrude(twt)
        offset(r=twt) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
    //dovetail
    intersection(){
        linear_extrude(100)
            offset(r=twt)
                cyclogearprofile(rtooth=rtooth,nteeth=n_teeth+1);
        translate([0,0,5]) mirror([0,0,1]) dovetail(10,d_gear*1.2,20, center=true);
    }
}

module middle(){
    difference(){
        linear_extrude(100) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth);
        ScrewThread(d_thread, pitch=thread_pitch, height = 101);
    }
    linear_extrude(twt) cyclogearprofile(rtooth=rtooth,nteeth=n_teeth);
}

module inner(){
    difference(){
        ScrewThread(d_thread-sliding_slop, pitch=thread_pitch, height = 100);
        translate([0,0,5+twt]) cylinder(d=75, h = 101);
        translate([0,0,5]) mirror([0,0,1]) dovetail(10 + sliding_slop,120,20, center=true);
    }
}

module wobbler(){
    intersection(){
        cylinder(d=50,h=15);
        difference(){
            union(){
                rotate([0,0,90])translate([0,0,15]) mirror([0,0,1]) dovetail(10,50,20, center=true);
                cylinder(d=50, h=10);
            }
            translate([0,0,5]) mirror([0,0,1]) dovetail(10 + sliding_slop,50,20, center=true);
        }
    }

}


outer();
