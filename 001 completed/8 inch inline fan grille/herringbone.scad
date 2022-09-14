$fa = .01;
$fs = $preview ? 10 : 1;


twt = .86;
twt2= 1.67;

h1=15;
h2=5;
d0=199;
d1=d0+twt2*2;

l = 50;
w = 10;
h = h2+.2;

gap = twt;


difference(){
    cylinder(h=h1+h2,d=d1);
        cylinder(h=100,d=d0, center=true);
}

difference(){
    cylinder(h=h2,d=d1);
    ddx = round(d1/sqrt(2)/l)*l;
    translate([-ddx+gap/2,gap/2-w/2,-.1]){
        for(j=[0:d1/(l)/sqrt(2)+1]){
            translate([j*(l),j*(-l),0])
            for(i=[-2:d1/(w)/sqrt(2)]){
                dx = (w)*i;
                translate([dx,dx,0])
                    cube([l-gap,w-gap,h]);
                translate([dx-gap,dx,0])
                    rotate([0,0,90])
                        cube([l-gap,w-gap,h]);
            }
        }
    }
}