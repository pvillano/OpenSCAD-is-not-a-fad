$fa = .01;
$fs = .3;

/* [Name] */
//first name
text1 = "ABCD";
//last name
text2 = "1234";
/* [Style] */
// Use a Black or Bold Font Style
font="Times New Roman:style=Bold";
height = 14;
spacing = 15;
base_diameter=20;
base_height = 3;

module nameplate(t1, t2) translate([(-len(t1)+1)/2*spacing, (-len(t1)+1)/2*spacing, 0]) {
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
}

nameplate(text1, text2);