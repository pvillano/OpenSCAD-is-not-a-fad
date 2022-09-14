$fa = .01;
$fs = $preview ? 3 :1;

ep=.1;

od1 = 27.8-2*ep;
id1 = (24.2+23.1)/2;
h_outer = 16.3;
h_outer_2 =13.6;
h_inner = 10.9;
od2 = 10.5;
id2 = 5.8 + ep;
tang_width=1.25;
tang_length=20.4-2*ep;
tang_height=h_inner-1;

h_visible=12;
font_size = (h_visible-3)/2;
letter_depth = (od1-id1)/2/3;
name="VILLANO VILLANO VILLANO";

module letter(l) {
    linear_extrude(height = od1, center=true) {
        text(
            l,
            font="Liberation Mono:Bold",
            size = font_size,
            halign = "center",
            valign = "top"
        );
    }
}


difference(){
    union(){
        difference(){
            cylinder(h=h_outer, d=od1);
            cylinder(h=h_outer_2,d=id1);
        }
        
        difference(){
            union(){
                translate([0,0,h_outer_2-h_inner])
                    cylinder(h=h_inner, d=od2);
                translate([0,0,h_outer_2-tang_height/2])
                    cube([tang_width,tang_length,tang_height], center=true);
            }
            translate([0,0,h_outer_2-h_inner]) cylinder(h=h_inner, d=id2);
        }
    }
    difference(){
        for(i = [0:len(name)-1],h = [h_outer-1, h_outer-font_size-2]){
            rotate([0,0, i * 360/len(name)]) 
                translate([0,-od1/2,h]) 
                    rotate([90,0,0])
                        letter(name[i]);
        }
        cylinder(h=h_outer,d=od1-letter_depth*2);
    }
    translate([0,0,h_outer])
        linear_extrude(height = letter_depth*2, center=true) {
        text("⚜", size = 16, 
            font="Segoe UI Emoji",
            halign = "center",
            valign = "center");
    }
}
