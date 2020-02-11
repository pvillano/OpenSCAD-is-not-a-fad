font_size = 14;
letter_depth = 3;


module letter(l) {
    linear_extrude(height = letter_depth*2, center=true) {
        text(l, size = font_size, halign = "center",
            valign = "center", $fn = 16);
    }
}


difference(){
    cube(20, center=true);
    translate([0,-10,0]) rotate([90,0,0]) letter("g");
}