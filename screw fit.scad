$fa = .01;
$fs = $preview ? 1 : .3;
//sizes=[for (i=[3.6:.1:4.2]) i];
sizes=[for (i=[4.2:-.1:3.6]) i];
spacing=10;
length=7;
width=length+spacing/2+2;
text_depth=1;
text_height=5;
rear_text_height=5;



difference(){
    cube([spacing*len(sizes),width,width]);
    translate([-.1,spacing,width])
        rotate([-45,0,0])
        cube([spacing*len(sizes)+.2,width,width]);
    
    for(i=[0:len(sizes)-1]){
        size=sizes[i];
        translate([spacing*(i+.5),0,0]){
            translate([0,spacing/2,spacing/2+2])
                cylinder(h=length+.1,d=size);
            translate([0,spacing/2+2,spacing/2])
                rotate([-90,0,0])
                cylinder(h=length+.1,d=size);
            translate([0,(width+spacing)/2,(width+spacing)/2])
            rotate([45,0,180])
                linear_extrude(text_depth*2,center=true, slices=1, convexity=20)
                text(str(size),text_height,halign="center", valign="center");
        }
    }
    
    //back text
    translate([spacing*len(sizes)/2,0,width/2])
        rotate([90,0,0])
        linear_extrude(text_depth*2,center=true, slices=1, convexity=20){
        translate([0,width/4,0]) text("M4 Hole Sizes",rear_text_height,halign="center", valign="center");
        translate([0,-width/4,0]) text(".2 layer height",rear_text_height,halign="center", valign="center");
        }
    
    if($preview && false)
        translate([-.1,-.1,-.1])
        cube([spacing/2+.1,width+.2,width+.2]);
}