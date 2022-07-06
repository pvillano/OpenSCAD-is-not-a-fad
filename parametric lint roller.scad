
$fa = .1;
$fs = $preview ? 5 : 1;

id1=30.0;
id2=15.0;
h1=78;
h2=94;
twt=1.26;
single_wall=.86;
module whole(){
    difference(){
        union(){
            cylinder(h=h1,d=id1+2*twt);
            translate([0,0,h1])
                cylinder(h=h2-h1,d1=id1+2*twt,d2=id2+2*twt);
        }
        union(){
            translate([0,0,twt]) cylinder(h=h1-twt,d=id1);
            translate([0,0,h1])
                cylinder(h=h2-h1,d1=id1,d2=id2);
        }
    }
}

module half() difference(){
    whole();
    translate([-id1/2-twt-.1,0,-.1])
        cube([id1+2*twt+.2,id2+twt+.1,h2+.2]);
}

half();
translate([id1+twt*3,0,0]) half();
//hinge
translate([id1/2,-single_wall,0]) cube([twt*3,single_wall,h1]);
//catch
translate([id1*1.5+3*twt,-twt,0]) cube([twt+single_wall,twt,h1]);
translate([-id1*.5-twt*3,-twt,0]) cube([3*twt,twt,h1]);
translate([-id1*.5-twt*3,-twt,0]) cube([twt,3*twt,h1]);
x1=-id1*.5-twt-single_wall;
x2=-id1*.5-twt*2;
y1=1*twt;
y2=2*twt;
//triangle bit
linear_extrude(h1) polygon([[x1,y1],[x2,y1],[x2,y2]]);
