$fa = .01;
$fs = $preview ? 3 :1;

h = 14;
spacing = 12;
width=18;

platform=16;
font="Fira Code:Black";
for(i=[0:4]){
    translate([spacing*i, spacing*i, 0]){
        intersection() {
            rotate([90,0,0])
                linear_extrude(center=true, convexity=10)
                    text("PETER"[i], halign="center", valign="baseline", font=font, size=h);
            
            rotate([90,0,90])
                linear_extrude(center=true, convexity=10)
                    text("ROCKY"[i], halign="center", valign="baseline", font=font, size=h);
        }
        translate([0,0,-1]) cube([16,16,2], center=true);
    }
}
