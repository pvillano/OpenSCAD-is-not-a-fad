$fs=1;
$fa=.01;
use <threads.scad>

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
            ); 
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




d=100;
n=20;
twt=2;
rtooth=d/n/4;

module outer(){
    linear_extrude(100) difference() {
        offset(r=twt) cyclogearprofile(rtooth=rtooth,nteeth=n+1);
        cyclogearprofile(rtooth=rtooth,nteeth=n+1);
    }
    //bottom
    mirror([0,0,1])linear_extrude(twt)
        offset(r=twt) cyclogearprofile(rtooth=rtooth,nteeth=n+1);
    //dovetail
    intersection(){
        linear_extrude(100)
            offset(r=twt)
                cyclogearprofile(rtooth=rtooth,nteeth=n+1);
        translate([0,0,5]) mirror([0,0,1]) dovetail(10,100,20, center=true);
    }
}

module middle(){
    difference(){
        linear_extrude(100) cyclogearprofile(rtooth=rtooth,nteeth=n);
        ScrewThread(outer_diam = d*(n-1)/n, height = 101);
    }
    linear_extrude(twt) cyclogearprofile(rtooth=rtooth,nteeth=n);
}

module inner(){
    difference(){
        ScrewThread(outer_diam = d*(n-1)/n, height = 100);
        translate([0,0,5+twt]) cylinder(d=75, h = 101);
        translate([0,0,5]) mirror([0,0,1]) dovetail(10,120,20, center=true);
    }
}
module dovetail(width, length, angle = 15, center = false) {
  rotate([90, 0, 180])linear_extrude(length, center = center)
    polygon([[- width / 2, 0], [width / 2, 0], [0, width / 2 * tan(90 - angle / 2)]]);
}

module wobbler(){
    intersection(){
        cylinder(d=50,h=15);
        difference(){
            union(){
                rotate([0,0,90])translate([0,0,15]) mirror([0,0,1]) dovetail(10,50,20, center=true);
                cylinder(d=50, h=10);
            }
            translate([0,0,5]) mirror([0,0,1]) dovetail(10,50,20, center=true);
        }
    }

}


inner();
