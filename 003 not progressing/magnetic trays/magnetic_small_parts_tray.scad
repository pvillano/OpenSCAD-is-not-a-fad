/*      design constraints:
    holes for magnets
    parametric (duh)
    rounded edges to pick things up
    fractal???
*/



magnet_diameter=5;
twt=2.54;

width=150;
height=30;
x_count=3;
y_count=2;
roundr=20;
/*
difference(){
    cube([width+twt*2,depth+twt*2,height+twt],center=true);
    translate([0,0,roundr]) minkowski(){
        cube([width-roundr*2,depth-roundr*2,height],center=true);
        sphere(roundr);
    }
}
    divide(150,150,2,1,1,twt);
    divide(150,150,4,1,2,twt);
    divide(150,150,6,2,2,twt);
    divide(150,150,8,2,4,twt);
    divide(150,150,10,4,4,twt);
*/

module divide(l,w,h,x,y,twt){
    w_cell=(w-twt)/x-twt;
    l_cell=(l-twt)/y-twt;
    for(i=[0:x-1],j=[0:y-1]){
        dx=twt+(w-twt)/x*i;
        dy=twt+(l-twt)/y*j;
        translate([dx,dy,0])
            cube([w_cell,l_cell,h]);
    }
}
n=2;
dh=(height-twt)/2;
difference(){
    cube([width,width,height]);
    minkowski(convexity=20){
        //cube(roundr,center=true);
        sphere(d=roundr);
        
        translate([0,0,-roundr/2]) for(i=[1:n]){
            divide(width,width,(i-.5)*dh,2^i,2^(i-1),roundr+twt);
            divide(width,width,i*dh,2^i,2^i,roundr+twt);
        }
    }
}
