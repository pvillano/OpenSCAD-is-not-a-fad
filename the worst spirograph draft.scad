draft = true;
phi = (sqrt(5)-1)/2;
count1 = draft ? 21 : 144;
count2 = draft ? 34 : 233;
r = 80;
dr = r/count2;
dh = dr*4;
h=40;
width=200;

n=1; //610;
module spike_gear(count, height, dr, dh, twist) {
    r = count * dr;
    function polar(i, r) = [cos(i * 180 / count), sin(i * 180 / count)] * r;
    points = [for (i = [1:count * 2]) ((i % 2) ? polar(i, r + dh / 2) : polar(i, r - dh / 2))];
    translate([0,0,height/2]) {
        linear_extrude(height = height/2, twist = twist) polygon(points);
        mirror([0,0,1]) linear_extrude(height = height/2, twist = twist) polygon(points);
    }
}


words = ["The", "Worst", "Spirograph", "Ever"];


difference(){
    translate([-100,-100,0]) cube([200,200,h]);
    translate([0,0,-1]) spike_gear(count2, h+2, dr, dh,360*(h+2)/h/count2);
    if (!draft) for(i=[0:4]){
        rotate([0,0,45-i*90])
        translate([0,count2*dr*1.095,h-1])
        linear_extrude(height = 2) {
            text(words[i], size = 10, halign = "center", valign = "center", $fn = 16);
        }
    }

    translate([-count2*dr*1.04,count2*dr*1.04,1])
    rotate([0,180,90])
    if (!draft) linear_extrude(height = 2) {
        text("pvillano", size = 10, halign = "left", valign = "top", $fn = 16);
    }
}
difference(){
    spike_gear(count1, h, dr, dh, 360/count1);
    for(i=[.5:n]){
        c=count1*dr-1.5*dh;
        translate([sqrt(i/n)*c*cos(360*i/phi), sqrt(i/n)*c*sin(360*i/phi), -1])
            cylinder(d=2.5,h=h+2, $fn=16);
    }
}