output = "body"; // ["body" , "modifier"]

/* [design parameters] */
mallet_od = 40;
cushion_thickness = 25;
vanity_chamfers = 4;
h_slots = 22;

/* [measurements] */
// make the neck od oversized if it's too difficult to slip on

head_od = 24;
head_h = 14.5;
neck_od = 20;
neck_h = 8;
neck_taper = 3.;

module _(){}
/* [] */
$fs = 1.;
$fa = .01;

module hammerHead(){
    cylinder(d=head_od,h=head_h);
    cylinder(d=neck_od,h=head_h+neck_h);
    translate([0,0,head_h-.01]) cylinder(d1=head_od, d2=neck_od, h = neck_taper);
}

module body() difference(){
    intersection(){
        h = head_h+neck_h+cushion_thickness;
        cylinder(d=mallet_od,h=h);
        cylinder(d1=mallet_od-vanity_chamfers,d2=mallet_od+2*h-vanity_chamfers,h=h);
        cylinder(d2=mallet_od-vanity_chamfers,d1=mallet_od+2*h-vanity_chamfers,h=h);
    }
    mirror([0,0,1]) translate([0,0,-(head_h+neck_h)+.01]) hammerHead();
    translate([0,0,-.1]) linear_extrude(h_slots){
        square([1,head_od*2], center=true);
        square([head_od*2,1], center=true);
    }
}

module modifier() {
    translate([0,0,head_h+neck_h])
        cylinder(h=cushion_thickness,d1=head_od, d2 = mallet_od);

}

if(output=="body"){
    mirror([0,0,1])body();
} else {
    mirror([0,0,1])modifier();
}
