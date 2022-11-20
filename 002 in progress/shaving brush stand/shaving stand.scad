$fa = .01;
$fs = .5;
bristles_diameter = 60;
brush_height = 115;
narrow_width = 22.0;
torus_diameter=30;
shank_height = 30;
shank_midheight = 15;
bulb_height=40;
bulb_diameter=40;

stand_width = 70;
stand_thickness=8;
brush_gap = 5;
torus_slop=1;
stand_width_top = narrow_width+4*stand_thickness+2*torus_slop;

module mirror2(xyz){
  children();
  mirror(xyz) children();
}


module brush(){
    difference(){
        union(){
            cylinder(d=35,h=shank_height);
            translate([0,0,brush_height-bristles_diameter/2]) sphere(d = bristles_diameter);
            translate([0,0,bulb_height]) sphere(d = bulb_diameter);
        }
        translate([0,0,shank_midheight]) rotate_extrude() translate([0.5*(narrow_width+torus_diameter),0]) circle(d=torus_diameter);
    }

}

swoop_diameter = bristles_diameter+2*brush_gap;
module subtractor(){
    //torus
    difference() {
        cylinder(d=(narrow_width+2*stand_thickness)+torus_slop,h=99, center=true);
        rotate_extrude()
            translate([0.5*(narrow_width+2*stand_thickness)+torus_slop,0]) circle(d=2*stand_thickness);
    }
    //exit
    difference(){
        spacing=narrow_width/2+torus_slop+torus_diameter/2;
        translate([-spacing,-49,-stand_thickness]) cube([spacing*2,49,49]);
        mirror2([1,0,0]){
            translate([spacing,0])
            rotate([90,0,0]) cylinder(d=torus_diameter+torus_slop,h=99, center=true);
        }
    }
    //swoops
     hull() for(dy=[0,-100])translate([0,dy,0]){
        translate([0,0,-brush_height+shank_midheight+bristles_diameter/2])
            rotate([0,90,0])
                cylinder(d=swoop_diameter,h=stand_width+.2, center=true);
        translate([0,0,-swoop_diameter/2])
            rotate([0,90,0])
                cylinder(d=swoop_diameter,h=stand_width+.2, center=true);
    }
}

h_overall = brush_height-shank_midheight+2*stand_thickness+brush_gap;

module stand1(){
    difference(){
        union(){
            translate([0,0,stand_thickness]) mirror([0,0,1]) cylinder(d1=stand_width_top, d2=stand_width,h=h_overall);
            translate([-stand_width_top/2,0,stand_thickness])  mirror([0,0,1]) cube([stand_width_top,bristles_diameter/2 + brush_gap + stand_thickness,h_overall]);
        }
        subtractor();
    }
};

module stand2(){
    w=stand_width_top-stand_thickness;
    l=60;
    difference(){
        translate([-w/2,-w/2+stand_thickness,stand_thickness-h_overall]) cube([w,l,h_overall]);
        subtractor();
    }
}

translate([0,0,shank_midheight])mirror([0,0,1]) %brush();
stand2();
