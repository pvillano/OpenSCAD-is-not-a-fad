
current_color = "ALL";

module multicolor(color) {
    if (color==current_color || current_color == "ALL"){
        color(color) children();
    }
}


multicolor("white") cube(size=3,center=true);
multicolor("red") cube(size=[9,1,1],center=true);
multicolor("green") cube(size=[1,9,1],center=true);
multicolor("blue") cube(size=[1,1,9],center=true);

