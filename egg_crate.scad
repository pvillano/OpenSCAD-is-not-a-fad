$fa = .01;
$fs = $preview ? 5 : 1;
slop = .1;
finger = 5;


width = 294;
depth = 127+7;
height = 30; // or whatever
twt = 1.67;

x_eggs = 6;
y_eggs = 3;
r_real_egg = 45/2;
h_real_egg = 60;
//r_egg = (depth)/(2 + 4*sqrt(3)/2);
r_egg1 = (depth-twt)/(2 + 4*sqrt(3)/2)-twt/2;
r_egg2 = (width-twt)/x_eggs-twt/2;
r_egg = 22+1;



module egg(r=r_egg) {
    scale([1,1,h_real_egg/r_real_egg/2]) sphere(r=r);
    //cylinder(h=r*3, r=10, center=true);
}
i_list=[[-1:2],[-1.5:2.5],[-1:2]];
dy1 =sqrt(3)/2*(r_egg*2+twt);
dy_list=[-dy1,0,dy1];
for(k=[0,1,2]){
    dy=dy_list[k];
    for(i=i_list[k]){
        dx=(i-.5)*(r_egg*2+twt);
        translate([dx,dy,0])
        difference(){
            minkowski(){
                egg(r=r_egg);
                cylinder(h=.01,r=twt);
            }
            egg(r=r_egg);
            translate([0,0,r_egg*1.5])
                cube(r_egg*3, center=true);
            cylinder(h=r_egg*3,r=r_egg/3,center=true);
        }
    }
}

/*
module void() intersection(){
    translate([0,0,-height-.1])
        cube([width, depth, height+.2]);
    union(){
        for(i=[1:x_eggs]){
            dx=(i-.5)*width/(x_eggs);
            translate([dx,r_egg+twt,0])
                egg();
            translate([dx,depth-r_egg-twt,0])
                egg();
        }
        for(i=[1:x_eggs-1]){
            dx2=(i)*width/(x_eggs);
            translate([dx2,depth/2,0])
                egg();
        }
    }
}

difference(){
    minkowski(){
        r=r_egg+twt;
        translate([r,r,-height])
        cube([width-2*r,depth-2*r,height]);
        cylinder(h=.001,r=r_egg+twt);
    }
    void();
}
*/