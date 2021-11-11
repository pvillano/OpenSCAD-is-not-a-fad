$fa = .01;
$fs = $preview ? 5 : 1;
slop = .1;
finger = 5;


width = 295;
depth = 127+7;
twt = 1.67;

r_real_egg = 45/2;
h_real_egg = 60;
//r_egg = (depth)/(2 + 4*sqrt(3)/2);
r_egg = (depth-twt)/(2 + 4*sqrt(3)/2)-twt/2;

height = 30; // or whatever

x_eggs = 6;
y_eggs = 3;

module egg() {
    scale([1,1,h_real_egg/r_real_egg/2]) sphere(r=r_egg);
    cylinder(h=r_egg*3, r=10, center=true);
}

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