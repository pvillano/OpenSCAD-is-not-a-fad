
module hyperboloid(h=10,r0=2,r1=5,fn=100){
    #cube([r1*2,r1*2,h], center=true);
    points = concat([ for (z = [-.5:1/fn:.5]) [sqrt(4*(r1^2-r0^2)*(z^2)+r0*r0), z*h] ], [ [0, .5*h], [0, -.5*h] ]);
    rotate_extrude($fn = fn) polygon(points);
}
module hollow_hyperboloid(h=10,r0=3,r1=5,t=1,fn=100){
    #cube([r1*2,r1*2,h], center=true);
    points = concat(
        [ for (z = [-.5:1/fn:.5]) [sqrt(4*(r1^2-r0^2)*(z^2)+r0*r0), z*h] ],
        [ for (z = [.5:-1/fn:-.5]) [sqrt(4*(r1^2-r0^2)*(z^2)+r0*r0)-t, z*h] ]
    );
    rotate_extrude($fn = fn) polygon(points);
}

hollow_hyperboloid();