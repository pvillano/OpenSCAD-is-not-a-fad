



inch=25.4;

slop = .1;

height3 = 1.028 * inch;
width3 = 4 * inch;
//depth3 = 5.787 * inch;
depth3 = 5.75 * inch;


d_hole = 0.094 * inch + 2 * slop;
l_hole = .140 * inch + slop;


//shole_dy = 1.222*inch;
shole_dy = 1.122*inch;
shole_dz = .250*inch;

width2 = 2.75 * inch;
$fa = .01;
$fs = $preview ? 1 : .3;

twt = .047 + .407*4;
twt_bot = 7*.2;


difference(){
    cube([width3,depth3,height3]);
    //horizontal holes
    dys=[1.122,1.122+1.638,1.122+4];
    for(dy_in=dys, dz=[shole_dz,height3-shole_dz]){
        dy=dy_in*inch;
        translate([-.1,dy, dz])
            rotate([0,90,0])
            cylinder(h=l_hole+.1, d=d_hole);
        translate([width3+.1,dy, dz])
            rotate([0,-90,0])
            cylinder(h=l_hole+.1, d=d_hole);
    }
    
    translate([twt,-.1,twt_bot])
    cube([width3-2*twt,depth3+.2,height3]);
}


w_spring = (width3 - width2)/2 - twt;
h_spring = height3 - twt_bot*2;
l_spring = width2;
dz1 = .25*inch;
dz2 = h_spring/2 + dz1;
dzo1 = shole_dz-twt_bot;
dzo2 = height3-shole_dz-twt_bot;

translate([-width3*.3,0,twt_bot]) {
    hull(){
        cylinder(h=h_spring,d=twt);
        translate([w_spring,l_spring,0])
            cylinder(h=h_spring,d=twt);
    }
    hull(){
        translate([w_spring,0,0])
            cylinder(h=h_spring,d=twt);
        translate([0,l_spring,0])
            cylinder(h=h_spring,d=twt);
    }
    for(dz=[dzo1,dzo2],dy=[0,l_spring])
        translate([w_spring,dy,dz])
        rotate([0,90,0])
        cylinder(h=l_hole+.1, d=d_hole-2*slop);
    
    for(dz=[dz1,dz2],dy=[0,l_spring])
        translate([0,dy,dz])
        rotate([0,-90,0])
        cylinder(h=l_hole+.1, d=d_hole-2*slop);
}