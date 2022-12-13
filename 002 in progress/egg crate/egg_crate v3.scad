$fa = .01;
$fs=3;
slop = .1;

//egg measurements
real_egg_d = 44.7;
real_egg_h = 60;

//design
width = 286;
depth = 127;
height = 30; // or whatever
twt = 1.67;
angle=67;
bottom=3;

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

module repeat(){
    for(i=[0:5],j=[-1:1]){
        basis1 = [1,0,0];
        basis2 = [j*cos(angle), sin(angle),0];
        grid_offset = (i*basis1 + (j)*basis2);
        centering_factor = [-2.5-cos(angle)/2,0,0];
        coords = spacing*(grid_offset + centering_factor);
        translate(coords) children();
    }
}

%translate([0,0,height/2]) cube([width, depth, height], center=true);
%translate([0,0,football_h/2+bottom]) repeat() egg();
difference(){
    translate([0,0,height/2]) minkowski(){
        ch=10;
        cube([width-2*ch, depth-2*ch, height-ch], center=true);
        cylinder(h=ch,r1=0,r2=ch, center=true);
    }
    translate([0,0,football_h/2+bottom]) repeat() egg_neg();
}

