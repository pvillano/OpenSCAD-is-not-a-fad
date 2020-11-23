$fa = .01;
$fs = $preview ? 3 :1;

od1 = 28.0;
id1 = 23.5;
h_outer = 16.3;
h_outer_2 =13.9;
h_inner = 10.9;
od2 = 10.5;
id2 = 6.0 + .1;
tang_width=1.25;
tang_length=od2+5;
tang_height=h_inner-1;

font_size = 12;
letter_depth = (od1-id1)/2/3;
name="VILLANO ";

module letter(l) {
    linear_extrude(height = od1, center=true) {
        text(
            l,
            size = font_size,
            halign = "center",
            valign = "center"
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
        for(i = [0:len(name)-1]){
            rotate([0,0, i * 360/len(name)]) 
                translate([0,-od1/2,h_outer/2]) 
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
