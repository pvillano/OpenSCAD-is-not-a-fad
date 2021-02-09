$fa = .01;
$fs = $preview ? 4 : 1;

height=50;
radius=25;
layer_height = .2;
layer_width = .45; // from PrusaSlicer


translate([radius*0,radius*0,0]) basic(height, radius);
translate([radius*3,radius*0,0]) corrugated_sin(height, radius);




module basic(h, r){
    cylinder(h,r, r);
}

module corrugated_sin(h,r,dr=5,n=10){
    //radius = r + sin(theta/(2 pi n))
    fn = round((2*PI*r)/$fs)*4; //needs more than just a cylinder
    step = 360/fn;
    points = [for (i = [0:step:360]) [sin(i)*(r+dr*sin(i*n)),cos(i)*(r+dr*sin(i*n))]];
    linear_extrude(height=h) {
        polygon(points);
    }
}



