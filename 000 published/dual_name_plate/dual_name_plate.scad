/* [Name] */
//first name
text1 = "SIRFIRST";
//last name
text2 = "LASTNAME";
/* [Style] */
// Use a Black or Bold Font Style
font="Arial:Black";
height = 14;
spacing = 15;
base_diameter=20;
base_height = 3;

assert(len(text1) == len(text2), "Texts must be same length");

//letters
for(i=[0:len(text1)-1]){
    translate([spacing*i, spacing*i, 0]){
        intersection() {
            rotate([90,0,0])
                linear_extrude(center=true, convexity=10)
                    text(text1[i], halign="center", valign="baseline", font=font, size=height);
            
            rotate([90,0,90])
                linear_extrude(center=true, convexity=10)
                    text(text2[i], halign="center", valign="baseline", font=font, size=height);
        }
    }
}

//base
// you may want to translate this up a bit if letters are barely touching e.g. ♥
translate([0,0,-base_height]) hull(){
    cylinder(d=base_diameter, h=base_height);
    translate([spacing*(len(text1)-1), spacing*(len(text1)-1), 0])
        cylinder(d=base_diameter, h=base_height);
    
}