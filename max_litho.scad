

$fn=16;
//design variables

print_vol = [250,210,210];
photo_width_inches = 8;
photo_height_inches= 10;

// constants
inch = 25.4;

// calculated values
photo_width=photo_width_inches*inch;
photo_height=photo_height_inches*inch;

// modules

module snake(l, h, wall_thickness=.45, base_thickness=.6, n=3){
    spacing = (l-wall_thickness/2)/n;
    coverup = spacing+wall_thickness/2+.2;
    
    translate([0,-spacing*(n-1)/2,-h/2])
        for(i=[0:n-1])
        translate([0,i*spacing,0])
        difference()
    {
        cylinder(h=h, d=spacing+wall_thickness/2);
        translate([0,0,base_thickness])
            cylinder(h=h, d=spacing-wall_thickness/2);
        rotate([0,0,180*i])
            translate([-coverup/4,0,h/2])
            cube([coverup/2,coverup,h+.2], center=true);
    }
        
    
}

// output

*cube(print_vol,center=true);
rotate([-atan2(print_vol[2],print_vol[1]),0,0])
    cube([photo_width,10,photo_height],center=true);
intersection(){
    union(){
        translate([-photo_width/3,0,0])
            snake(210,210,n=20);
        translate([photo_width/3,0,0])
            snake(210,210,n=20);
    }
    translate([-max(print_vol),-max(print_vol),-max(print_vol)])
        rotate([-atan2(print_vol[2],print_vol[1]),0,0])
        cube(max(print_vol)*2);
}
    
// footnotes
/*
For my printer, maximum photo dimensions are:
    * 250 x 296 = sqrt(210^2+210^2)
    * 210 x 326 = sqrt(250^2+210^2)
    * 9 3/4 x 11 5/8
    * 8 1/4 x 12 3/4
*/