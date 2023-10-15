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

module repeant(){
    for(i=[5],j=[1]){
        basis1 = [1,0,0];
        basis2 = [j*cos(angle), sin(angle),0];
        grid_offset = (i*basis1 + (j)*basis2);
        centering_factor = [-2.5-cos(angle)/2,0,0];
        coords = spacing*(grid_offset + centering_factor);
        translate(coords) children();
    }
}

module ribs(){
    dh=5;
    h=height-dh;
    angle2 = atan2(sin(angle), 1-cos(angle));

    translate([0,0,dh]){
        for(i=[0:5]){
            grid_offset = [i,0,0];
            centering_factor = [-2.5-cos(angle)/2,0,0];
            coords = spacing*(grid_offset + centering_factor);
            translate(coords) rotate([0,0,angle-90]) color("red") translate([-twt/2,0,0])cube([twt,real_egg_d,h]);
            translate(coords) rotate([0,0,-angle-90]) color("red") translate([-twt/2,0,0])cube([twt,real_egg_d,h]);
            if(i>0) translate(coords) rotate([0,0,angle2+90]) color("green") translate([-twt/2,0,0])cube([twt,real_egg_d,h]);
            if(i>0) translate(coords) rotate([0,0,90-angle2]) color("green") translate([-twt/2,0,0])cube([twt,real_egg_d,h]);
        }
        for(j=[-1:1]){
            basis2 = [j*cos(angle), sin(angle),0];
            grid_offset = j*basis2;
            centering_factor = [-2.5-cos(angle)/2,0,0];
            coords = spacing*(grid_offset + centering_factor);
            translate(coords) color("blue") translate([0,-twt/2,0])cube([real_egg_d*5,twt,h]);
        }
    }
}

module main_pos(){
    intersection(){
        repeat() minkowski(){
            translate([0,0,football_h/2]) egg_neg();
            cylinder(h=twt,r=twt);
        }
        translate([0,0,height/2]) cube([width, depth, height], center=true);
    }
    ribs();
}
module main(){
    %translate([0,0,height/2]) cube([width, depth, height], center=true);
    %translate([0,0,football_h/2+bottom]) repeat() egg();
    difference(){
        main_pos();
        translate([0,0,football_h/2+bottom]) repeat() egg_neg();
    }
}
module measure(){
    %translate([0,0,height/2]) cube([width, depth, height], center=true);
    repeat() minkowski(){
        $fn=32;
        translate([0,0,football_h/2]) cylinder(d=real_egg_d);
        //cylinder(h=40,r=twt); because we're shorter than the midpoint of the eggs, they can touch the sides
    }
}

main();