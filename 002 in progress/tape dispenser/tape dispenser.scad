
unit = 25.4;
TapeID = 3;
Width=1;

tape_id = TapeID * unit;
tape_width=Width*unit+2;

module tape(w=25.4,t=10){
    difference(){
        cylinder(d=tape_id+t*2,h=w,center=true);
        cylinder(d=tape_id,h=w+2,center=true);
    }
}


module base(){
    base_diameter = tape_id + 5;
    //cylinder(d=tape_id,h=tape_width);
    difference(){
        union(){
            rotate([0,0,90]) cylinder(d=base_diameter*1/sin(60),h=3,$fn=6);
            translate([base_diameter/2,0,0]) cylinder(d=base_diameter,h=3,$fn=3);
        }
        p=40;
        x=p/cos(30)/4+5;
        translate([base_diameter-x/tan(30),x,-.1]) hull() {
            rotate([0,0,30] ) cylinder(d=p/cos(30),h=4, $fn=6);
//            %rotate([0,0,30]) translate([-10,0,0]) cylinder(d=p/cos(30),h=4, $fn=6);
//            % translate([0,10,0]) rotate([0,0,30])cylinder(d=p/cos(30),h=4, $fn=6);
            %cylinder(d=20,h=5);
        }
    }
}


%translate([0,0,unit/2+.1])%tape();
base();