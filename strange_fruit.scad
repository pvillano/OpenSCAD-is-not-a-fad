$fa = .01;
$fs = $preview ? 1 :.1;
n = 1000;
r = 50;
phi = (sqrt(5)-1)/2;

for(i = [1:n*2-1]) 
    rotate(i*phi*360) 
        translate([r*sqrt(1-(1-i/n)*(1-i/n)),0,r*(1-i/n)]) 
            sphere(r=r/sqrt(n)*1.5);

sphere(r=r);
