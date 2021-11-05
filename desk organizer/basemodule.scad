module base(x_count = 1, y_count = 1,unit = 25.4*2, h=25.4,  d_magnet = 8+.2, h_magnet=2.8+.1, center = false) {
    d_xyz= center ?  [0,0,0] : [unit*x_count, unit*y_count, h]/2;
    translate(d_xyz)
    difference(){
        cube([unit*x_count, unit*y_count, h], center=true);
        for(i=[0:1],j=[-1,1]){
            rotate([0,0,180*i])
                translate([unit*x_count/2+.1, j*(unit*y_count/2-h/2),0])
                rotate([0,-90,0])
                cylinder(d=d_magnet,h=h_magnet+.1);
            rotate([0,0,180*i])
                translate([j*(unit*x_count/2-h/2), unit*y_count/2+.1,0])
                rotate([90,0,0])
                cylinder(d=d_magnet,h=h_magnet+.1);

        }
    }
}

base(2,1, center=false);