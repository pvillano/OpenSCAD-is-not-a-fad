/* [Name] */
//first name
text1 = "ABCD";
//last name
text2 = "1234";
/* [Style] */
// Use a Black or Bold Font Style
font="Arial:Black";
height = 14;
spacing = 15;
base_diameter=20;
base_height = 3;

module nameplate(t1, t2) rotate([0,0,-90]) translate([(-len(t1)+1)/2*spacing, (-len(t1)+1)/2*spacing, 0]) {
    assert(len(t1) == len(t2), "Texts must be same length");
    //letters
    for (i = [0:len(text1) - 1]) {
        translate([spacing * i, spacing * i, 0]) {
            intersection() {
                rotate([90, 0, 0])
                    linear_extrude(center = true, convexity = 10)
                        text(t1[i], halign = "center", valign = "baseline", font = font, size = height);

                rotate([90, 0, 90])
                    linear_extrude(center = true, convexity = 10)
                        text(t2[i], halign = "center", valign = "baseline", font = font, size = height);
            }
        }
    }

    //base
    // you may want to translate this up a bit if letters are barely touching e.g. ♥
    translate([0, 0, - base_height]) hull() {
        cylinder(d = base_diameter, h = base_height);
        translate([spacing * (len(text1) - 1), spacing * (len(text1) - 1), 0])
            cylinder(d = base_diameter, h = base_height);

    }
}
if (false){
    rotate([0,0,45]) translate([0,0, height*4]) nameplate(text1, text2);
    rotate([0,0,22.5]) translate([0,0, height*2]) nameplate(text1, text2);
    rotate([0,0,-22.5]) translate([0,0, -height*2]) nameplate(text1, text2);
    rotate([0,0,-45]) translate([0,0, -height*4]) nameplate(text1, text2);
}
nameplate(text1, text2);