$fa=.01;
$fs=.3;
inch=25.4;
twt=.675;
od=inch;

h=1.5*inch;
h2=1.5*twt;
outset=10;

difference(){
    union(){
        cylinder(h=h,d=od);
        cylinder(h=h2,d1=od+2*outset-h2, d2=od+2*outset);
    }
    translate([0,0,-.1]) cylinder(h=h+.2,d=od-2*twt);
}