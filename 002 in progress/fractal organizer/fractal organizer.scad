//use <gridfinity_modules.scad>

/* [Constants] */
inch = 25.4;

/* [Options] */
num_x = 3;
num_y = 2;
twt=.4;
h=21;
max_aspect_ratio=1.5; //prevents holes from getting too deep

/*
// omg this is so complicated
//gridfinity constants
bevel2_top = 5;
gridfinity_pitch = 42; //xy spacing
corner_radius = 3.75; //outside of box
// each bin is undersized by this much
gridfinity_clearance = 0.5;  
*/

/* [Calculated] */

n=15; // todo: calculate this explicitly
b=num_x/num_y;
w=inch*num_y;
assert(b>1);
a=b-1/b;

module cubette(xyz, twt=twt){
  translate([1,1,0]*twt/2) cube(xyz-twt*[1,1,0]);
}


function sum(x) = x * [for(i=[1:len(x)]) 1];

module fractal_organizer(){
  difference(){
    cube([b*w,w,h]);
    translate([0,0,twt]) for(i=[0:n/2-1]){
      //left to right along top edge
      x1=w*a*b^(-2*i);
      y1=w*b^(-2*i);
      z1=min(h,x1*max_aspect_ratio);
      
      dx1= i==0 ? 0 : w*a*sum([for(j=[0:i-1]) b^(-2*j)]);
      dy1= w-y1;
      translate([dx1,dy1,h-z1]) cubette([x1,y1,z1]);
      
      //bottom to top along right edge
      x2=w*b^(-2*i-1);
      y2=w*a*b^(-2*i-1);
      z2=min(h, y2*max_aspect_ratio);
      
      dx2=w*b-x2;
      dy2= i==0 ? 0 : w*a*sum([for(j=[0:i-1]) b^(-2*j-1)]);
      translate([dx2,dy2,h-z2]) cubette([x2,y2,z2]);
    }
  }
}

fractal_organizer();