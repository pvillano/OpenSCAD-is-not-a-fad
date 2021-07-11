$fa = .01;
$fs = $preview ? 10 : 2;

r1=100;
r2=13;
r=r1 - r2;

//major triad
f1 = 4;
f2 = 5;
f3 = 6;
//minor triad
//f1 = 10;
//f2 = 12;
//f3 = 15;

n = round(r*40/$fs/30)*30+30;

module rotate_to(v){
    v_unit = [v[0]/norm(v), v[1]/norm(v), v[2]/norm(v)];
    axis = cross([0,0,1], v_unit);
    angle = acos(v_unit[2]); // dot(v_unit, [0,0,1]) / norm(v_unit)
    rotate(angle, axis){
        children();
    }
}


module drawpath(fun, n, rad){
    for(i=[1:n]){
        i1 = (i-0.5)/n;
        i2 = (i+0.0)/n;
        i3 = (i+0.5)/n;
        i4 = (i+1.0)/n;
        i5 = (i+1.5)/n;

        p1 = fun(i1);
        p3 = fun(i3);
        p5 = fun(i5);

        d1 = [p3.x-p1.x, p3.y-p1.y, p3.z-p1.z];
        d2 = [p5.x-p3.x, p5.y-p3.y, p5.z-p3.z];
        hull(){
            translate(fun(i2)) rotate_to(d1) cylinder(r1=rad, r2=0, h=.1, center=true);
            translate(fun(i4)) rotate_to(d2) cylinder(r1=rad, r2=0, h=.1, center=true);
        }
    }
}



myfun = function (t) [r*sin(f1*t*360), r*sin(f2*t*360),r*sin(f3*t*360)];

%cube(r1*2-r2/4, center=true);

drawpath(myfun, n, r2);
