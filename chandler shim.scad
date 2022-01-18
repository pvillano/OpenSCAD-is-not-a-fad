$fa = .01;
$fs = $preview ? 10 : 1;

ods=[45.3,45.8,45.8,46.1,46.1,46.5];
id=40.3+.1;
h=43;

letter_depth=(min(ods)-id)/2/2;
letter_size=15;


module letter(l) {
    linear_extrude(height = letter_depth*2, center=true) {
        text(l, size = letter_size, halign = "center", valign = "center", $fn = 16);
    }
}

for(i=[0:5]){
    od=ods[i]-.1;
    letter_depth=(od-id)/2/2;

    translate([max(ods)*1.1*i,0,0]){
        difference(){
            cylinder(h=h,d=od,center=true);
            cylinder(h=h+.1,d=id,center=true);
            translate([0,-od/2,0]) rotate([90,90,0]) letter(str(od));
        }
    }
}
