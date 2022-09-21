$fa =.01;
$fs = sqrt(.5);

phi = (sqrt(5)-1)/2;
count1 = 144;
count2 = 233;
dr = .4;
dh = dr*4;
h=5;
NumberOfHoles = 144;

prototype = false;

n= NumberOfHoles;

module mirror2(xyz){
    children();
    mirror(xyz)
        children();
}

module spike_gear(count, height, dr, dh) {
    r = count * dr;
    twist=360/count;
    function polar(i, r) = [cos(i * 180 / count), sin(i * 180 / count)] * r;
    points = [for (i = [1:count * 2]) ((i % 2) ? polar(i, r + dh / 2) : polar(i, r - dh / 2))];
    translate([0,0,height/2]) mirror2([0,0,1]) linear_extrude(height/2, twist=twist) {
        polygon(points);
    }
}


words = ["The", "Worst", "Spirograph", "Ever"];

//outside
difference(){
    translate([-100,-100,0]) cube([200,200,h]);
    translate([0,0,-.1]) spike_gear(count2, h+.2, dr, dh);
    for(i=[0:4]){
        rotate([0,0,45-i*90])
        translate([0,count2*dr*1.095,h-1])
        linear_extrude(height = 2) {
            text(words[i], size = 10, halign = "center", valign = "center");
        }
    }

    translate([-count2*dr*1.04,count2*dr*1.04,1])
    rotate([0,180,90])
    linear_extrude(height = 2) {
        text("pvillano", size = 10, halign = "left", valign = "top");
    }
}
//inside
difference(){
    spike_gear(count1, h, dr, dh);
    for(i=[.5:n]){
        c=count1*dr-2.5*dh;
        translate([sqrt(i/n)*c*cos(360*i/phi), sqrt(i/n)*c*sin(360*i/phi), -.1])
            cylinder(d1=2.5, d2=7, h=h+.2);
    }
}

























