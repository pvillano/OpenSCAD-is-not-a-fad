//use <gridfinity_modules.scad>

/* [Constants] */
$fa = .01;
$fs = .3;

inch = 25.4;

/* [Options] */
num_x = 6;
num_y = 5;
twt=1.28;
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



module cubette(xyz, twt=twt, center=false){
  translate([1,1,0]*twt/2) cube(xyz-twt*[1,1,0], center=center);
}

module round_cube(xyz, r, center=false){
  min_r = min(r, xyz.x/2-.002,xyz.y/2-.002,xyz.z/2-.002);
  translate(center ? [0,0,0]: .5*xyz) minkowski(){
    sphere(min_r);
    cube(xyz-2*min_r*[1,1,1], center=true);
  }
}

module round_cubette(xyz,r,twt=twt,center=false){
  translate([1,1,0]*twt/2) round_cube(xyz-twt*[1,1,0], r=r, center=center);
}

function sum(x) = x * [for(i=[1:len(x)]) 1];

module fractal_organizer(){
  n=20; // todo: calculate this explicitly
  
  y_len = inch * num_y - twt;
  x_len = inch * num_x - twt;
  
  //b=num_x/num_y;
  b=x_len/y_len;
  w=y_len;
  assert(b>1);
  a=b-1/b;
  difference(){
    cube([inch*num_x, inch*num_y,h]);
    translate([twt/2,twt/2,0]) #fractal_negative(a=a,b=b,n=n,w=w,twt=twt);
  }
}
    
module fractal_negative(a,b,n,w,twt){
  translate([0,0,twt]) for(i=[0:n/2-1]){
    //left to right along top edge
    x1=w*a*b^(-2*i);
    y1=w*b^(-2*i);
    z1=min(h,x1*max_aspect_ratio);
    
    dx1= i==0 ? 0 : w*a*sum([for(j=[0:i-1]) b^(-2*j)]);
    dy1= w-y1;
    if(min(x1,y1)>2*$fs) translate([dx1,dy1,h-z1]) round_cubette([x1,y1,2*h], r=3);
    
    //bottom to top along right edge
    x2=w*b^(-2*i-1);
    y2=w*a*b^(-2*i-1);
    z2=min(h, y2*max_aspect_ratio);
    
    dx2=w*b-x2;
    dy2= i==0 ? 0 : w*a*sum([for(j=[0:i-1]) b^(-2*j-1)]);
    if(min(x1,y1)>2*$fs) translate([dx2,dy2,h-z2]) round_cubette([x2,y2,2*h], r=3);
  }
}


fractal_organizer();