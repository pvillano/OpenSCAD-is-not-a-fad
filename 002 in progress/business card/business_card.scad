


width = 3.5 * 25.4;
height = 2.0 * 25.4;
thickness = .2;
margin=5;

font="Bahnschrift:style=Bold";
font_size = 6.5;

name = "Peter Villano";
email =   "peter@saej.in";
phone =   "(574)-855-9777";
website = "https://saej.in";

module content(){
    translate([0,height/2-margin,0])
        resize([width-margin*2,0,0], true)
            linear_extrude(center=true, convexity=10)
                text(name, halign="center", valign="top", font=font, size=font_size);

    translate([-width/2+margin-font_size*.1,0,0]){
        linear_extrude(center=true, convexity=10)
            text(email, halign="left", valign="baseline", font=font, size=font_size);
        translate([0,(-height/2+margin)/2,0])
            linear_extrude(center=true, convexity=10)
                text(phone, halign="left", valign="baseline", font=font, size=font_size);
        translate([0,-height/2+margin,0])
            linear_extrude(center=true, convexity=10)
                text(website, halign="left", valign="baseline", font=font, size=font_size);
    }
}

module card() cube([width,height,thickness], center=true);


module positive(){
    intersection(){
        content();
        card();
    }
}

module negative(){
    difference(){
        card();
        content();
    }
}

negative();