$fa = .01;
$fs = $preview ? 10 : .3;
inch=25.4;

height_outer =1.666*inch*3;
height_inner = 1.635*inch;
//width_outer = 5.827*inch; official
width_outer = 5.889*inch; //my case
width_inner = 5.750*inch;

hole_h1 = 10;
hole_h2 = 21.84;
hole_l1 =47.4;


d_arctic = 128;
twt_arctic = 1.65;
support_thickness_a = 5;
support_thickness = min(support_thickness_a, (width_inner-120)/2);

module void(h){
    intersection(){
        cylinder(h=h,d=d_arctic,center=true);
        cube([120-twt_arctic*2, 120-twt_arctic*2,h+.2],center=true);
    }
}

module crossbone(w,onum,inum=5,twt=.86,h=5){
    o_max=(onum-1)/2;
    i_max=(inum-1)/2;
    w_inner = w/onum;
    dx_inner = w/onum/inum;
    
    for(i=[-o_max:o_max],j=[-o_max:o_max])
        translate([w/onum*i,w/onum*j,0])
        rotate([0,0,(i+j)*90])
        for(k = [-i_max:i_max])
        translate([dx_inner*k,0,0])
        cube([dx_inner-twt,w_inner-twt,h], center=true);
}

module plate() {
    //front plate
    difference(){
        cube([width_outer, height_outer, 5], center = true);
        //holes
        for(dx=[-105/2,105/2],dy=[-105/2,105/2])
            translate([dx,dy,0])
            cylinder(h=5+.2,d1=7,d2=4.8,center=true);
        //grille
        intersection(){
            void(5+.2);
            crossbone(120-twt_arctic*2+.86,3,5,.86,5+.2);
        }
        translate([0,0,5/2+.2])
            void(5+.1);
    }
    for(i=[-1,1],j=[-1,/*0,*/1]){
        dx=i*(width_inner-support_thickness)/2;
        dy=j*height_outer/3;
        translate([dx,dy,5/2]) difference() {
            //suports
            hull(){
                cube([support_thickness,height_inner,.1],center=true);
                translate([0,0,hole_l1])
                    rotate([0,90,0])
                    cylinder(h=support_thickness,d=height_inner,center=true, $fn=4);
            }
            //support holes
            for(dy2=[hole_h1,hole_h2])
                translate([0,dy2-height_inner/2,hole_l1])
                rotate([0,90,0])
                #cylinder(h=support_thickness+.2,d=3,center=true);
        }
    }
}

plate();