use <platonic_solids.scad>

current_color = "red";
font_size = 10;
letter_depth = 15;
radius = 20;
r = radius;
r2 = radius/sqrt(2);

module multicolor(color) {
    if (color==current_color || current_color == "ALL"){
        color(color) children();
    }
}

module letter(l) {
    translate([0,0,-letter_depth])
    linear_extrude(height = letter_depth) {
        text(l, size = font_size, halign = "center",
            valign = "center", $fn = 16);
    }
}



module rhombic_dodecahedron(r){
    hull(){
        cube(size=r, center=true);
        octahedron(r);
    };
}


rotate([0,45,0]){
    multicolor("white") rhombic_dodecahedron(r);
    multicolor("red") union(){
        rotate([0, 45,0]) translate([0,0,r2]) letter("12");
        rotate([0,135,0]) translate([0,0,r2]) letter("11");
        rotate([0,225,0]) translate([0,0,r2]) letter("01");
        rotate([0,-45,0]) translate([0,0,r2]) letter("02");

        rotate([ 45,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("10");
        rotate([135,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("09");
        rotate([225,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("03");
        rotate([-45,0,0]) translate([0,0,r2]) rotate([0,0, 90]) letter("04");

        rotate([0,0, 45]) rotate([90,0,0]) translate([0,0,r2]) letter("08");
        rotate([0,0,135]) rotate([90,0,0]) translate([0,0,r2]) letter("07");
        rotate([0,0,225]) rotate([90,0,0]) translate([0,0,r2]) letter("05");
        rotate([0,0,-45]) rotate([90,0,0]) translate([0,0,r2]) letter("06");
    }
}