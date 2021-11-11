$fa = .01;
$fs = $preview ? 1 :.2;

x=210; // [10:10:1000]
y=250; // [10:10:1000]
z=210; // [10:10:1000]
scale([x/max(x,y),y/max(x,y),1]) cylinder(h=z, d1=max(x,y), d2=0);