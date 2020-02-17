h = 14;
spacing = 12;
for(i=[0:4]){
    translate([spacing*i, spacing*i, 0]){
        intersection() {
            rotate([90,0,0])
                linear_extrude(center=true)
                    text("PETER"[i], halign="center", valign="baseline", size=h);
            
            rotate([90,0,90])
                linear_extrude(center=true)
                    text("ROCKY"[i], halign="center", valign="baseline", size=h);
        }
    }
}

hull(){
    translate([0,0,-1]) cylinder(d=h);
    translate([spacing*4, spacing*4,-1]) cylinder(d=h);
}