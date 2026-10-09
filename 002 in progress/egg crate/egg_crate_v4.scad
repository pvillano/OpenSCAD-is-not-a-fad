$fa = .01;
$fs = 3;
slop = .1;

//egg measurements
real_egg_d = 44.7;
real_egg_h = 60;

//design
width = 286;
depth = 127;
height = 25; // or whatever
twt = 1.67;
angle=66.7;
bottom=1;

spacing = real_egg_d;
basis1 = [1,0,0];
basis2 = [cos(angle), sin(angle),0];
football_h = 2*(real_egg_h-real_egg_d/2);
module football(){
    scale([1,1,football_h/real_egg_d]) sphere(d=real_egg_d);
    //cylinder(h=90, d=real_egg_d/2, center=true);
}

module egg() render(){
    sphere(d=real_egg_d);
    difference(){
        football();
        cylinder(99,99,$fn=4);
    }
}

module egg_neg(){
    football();
    cylinder(h=90, d=real_egg_d/2, center=true);
}


egg();