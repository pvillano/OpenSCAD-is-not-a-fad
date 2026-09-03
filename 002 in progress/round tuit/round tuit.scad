od=45;
n=48;
h= 4;
engrave_depth=.3;
tuit_size=12;
border_percent = 2.5;
border = od/2*border_percent/100;
id = od -2*border;

$fs=.5;
$fa=.01;

module guilloche(tip_diameter=.1, tip_angle=90){
    translate([0,0,-engrave_depth+tip_diameter/2])
    for(i=[0:n-1])
        rotate([0,0,i/n*360])
        translate([id/4,0])
        rotate_extrude()
        translate([id/4,0])
        offset(tip_diameter/2)
        intersection()
    {
        rotate([0,0,tip_angle/2]) square(5);
        rotate([0,0,90-tip_angle/2]) square(5);
    }
}

module chamfer_extrude(height, half_angle){
    minkowski(){
        linear_extrude(.000001) children();
        cylinder(h=height, r2=0,r1=height * tan(half_angle));
    }
}

module paragraph(lines=[""], size=8, spacing=1.4){
    for(i=[0:len(lines)-1]){
        t = lines[i];
        dy = size*spacing;
        y = dy * (-i + len(lines)/2 - .5);
        translate([0,y,0])
                text(t, size,
                font="Trebuchet MS:style=Bold",
                halign="center",
                valign="center");
        
    }
}

module backed_tuit(){
    //lines=["A","ROUND","TUIT"];
    chamfer_extrude(engrave_depth, 15) paragraph(["TUIT"], tuit_size);
    translate([0,0,-1])
        chamfer_extrude(1, 45)
        offset(r=1.2)
        square([3,1]*tuit_size, center=true);
}

module mirror2(xyz){
    children();
    mirror(xyz) children();
}



module main(){

    //border, excluded from difference
    mirror2([0,0,1])
        intersection(){
        cylinder(h=h/2, d=od);
        chamfer_extrude(h/2,15) difference(){
            circle(d=od);
            circle(d=id);
        }
    }
        

    translate([0,0,h/2-engrave_depth]) backed_tuit();
    
    difference(){
    
        cylinder(h=h-2*engrave_depth, d=od, center=true);
        
        
        translate([0,0,h/2-engrave_depth]) guilloche();
        
        rotate([0,180,0])
            translate([0,0,h/2-engrave_depth]) 
            translate([0,0,-engrave_depth])
            mirror([0,0,1])
            translate([0,0,-1])
            chamfer_extrude(1,15)
            paragraph(
            ["This is a",
            "round tuit. Now",
            "that you have one,",
            "you can finish all",
            "the things you put",
            "aside until you got",
            "got A ROUND",
            "TUIT!",
            ], 3.2
        );
    }
}

main();
