$fa = .01;
$fs = $preview ? 2 : .5;
h=12;
d2=$preview ? 15 : 30.0+.2;
d1=30.6+.2;
twt=.86;
inch=25.4*1.5;
difference(){
    cylinder(h=h+7*.2,d1=d1+twt*2,d2=inch);
    cylinder(h=h,d1=d1,d2=d2);
}