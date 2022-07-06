$fs = $preview ? 10 : 1;

/* [parameters] */
selected_module = "all"; // ["all", "chamber", "lid", "support blocker"]


/* [Design Options] */

// number of sides
Sides = 6; // [3:8]
sides = Sides;

// thin wall thickness
Thin_Wall_Thickness=1.29;
twt=Thin_Wall_Thickness;

// thickness of the hexagon floor
Floor_Thickness = 2;
floor_thickness = Floor_Thickness;

/* [Soap Dimensions] */
// Height of soap. Include wiggle room!
Soap_Height = 15;
h_soap = Soap_Height;
// Diameter of soap. Include wiggle room!
Soap_Diameter = 75;
d_soap = Soap_Diameter;

/* [Magnet Dimensions] */
Magnet_Thickness = 2;
h_magnet = Magnet_Thickness + .2;
Magnet_Width = 5;
w_magnet = Magnet_Width + .2;
Magnet_Length = 40;
l_magnet = Magnet_Length + .2;



wall_thickness = 2*twt+h_magnet;

wobble = 8;
hole_spacing = (d_soap + floor_thickness+.01) / 3;
hole_percent = 75;
module __Customizer_Limit__ () {}

//distance from center
r_0 = d_soap / 2 * (1 / cos(180 / sides)) * (1 / cos(wobble));
r_1 = (d_soap / 2 + wall_thickness) * (1 / cos(180 / sides)) * (1 / cos(wobble));
h_0 = 0+0;
h_1 = h_soap + floor_thickness;


//r, theta, phi
function sph2cart(rtp) = [rtp.x * sin(rtp.y) * cos(rtp.z), rtp.x * sin(rtp.y) * sin(rtp.z), rtp.x * cos(rtp.y)];

module magnets() {
    //magnets need to be rotated about a derived angle
    //right triangle from top of sloped surface to midpoint of sloped surface to xy intersection
    radius = 1; //to corner
    horizontal_apothem = radius * cos(180 / sides); //to face
    side = radius * sin(180 / sides) * 2;
    dh = radius * tan(wobble);
    tilt = atan2(dh, side / 2);
    for (i = [1:sides]) {
        theta = (i + .5) * 360 / sides;
        direction = 2 * (i % 2) - 1;
        rotate([tilt * - direction, 0, theta])
            translate([(d_soap + wall_thickness) / 2, 0, 0])
                cube([h_magnet, l_magnet, w_magnet * 2], center = true);
    }
    //todo magnets stick out a little
}

module walls(h_1=h_1) {
    proto_points = [[r_0, h_0], [r_0, h_1], [r_1, h_1], [r_1, h_0]];
    function sector(idx, wobble) = [for (pp = proto_points) (sph2cart([pp[0], wobble, idx * 360 / sides]) + [0, 0, pp[1]
        ])];

    //points = [for (i=[1:sides]) each sector(i, 90-wobble*(2*(i%2)-1))];
    sectors = [for (i = [1:sides]) sector(i, 90 - wobble * (2 * (i % 2) - 1))];
    points = [for (i = [0:len(sectors) - 1], j = [0:len(sectors[0]) - 1]) sectors[i][j]];
    //TESTING// for(point=points)translate(point) cube(center=true);

    proto_faces = [[0, 4, 7, 3], [1, 5, 4, 0], [2, 6, 5, 1], [3, 7, 6, 2]];
    //faces = [for(i=[0:sides-1]) each [for (pf=proto_faces) [for(j=pf) (j+i*4)%len(points)]]];
    face_groups = [for (i = [0:sides - 1]) [for (pf = proto_faces) [for (j = pf) (j + i * 4) % len(points)]]];
    faces = [for (i = [0:len(face_groups) - 1], j = [0:len(face_groups[0]) - 1]) face_groups[i][j]];
    polyhedron(points = points, faces = faces, convexity = 20);
}

module support_blocker(){
    proto_points = [[r_0-1, h_0], [r_0-1, h_1], [r_1+4, h_1], [r_1+4, h_0]];
    function sector(idx, wobble) = [for (pp = proto_points) (sph2cart([pp[0], wobble, idx * 360 / sides]) + [0, 0, pp[1]
        ])];

    //points = [for (i=[1:sides]) each sector(i, 90-wobble*(2*(i%2)-1))];
    sectors = [for (i = [1:sides]) sector(i, 90 - wobble * (2 * (i % 2) - 1))];
    points = [for (i = [0:len(sectors) - 1], j = [0:len(sectors[0]) - 1]) sectors[i][j]];
    //TESTING// for(point=points)translate(point) cube(center=true);

    proto_faces = [[0, 4, 7, 3], [1, 5, 4, 0], [2, 6, 5, 1], [3, 7, 6, 2]];
    //faces = [for(i=[0:sides-1]) each [for (pf=proto_faces) [for(j=pf) (j+i*4)%len(points)]]];
    face_groups = [for (i = [0:sides - 1]) [for (pf = proto_faces) [for (j = pf) (j + i * 4) % len(points)]]];
    faces = [for (i = [0:len(face_groups) - 1], j = [0:len(face_groups[0]) - 1]) face_groups[i][j]];
		
    polyhedron(points = points, faces = faces, convexity = 20);
}


module chamber() {
    translate([0, 0, - r_0 * sin(wobble) - floor_thickness]) difference() {
        walls();
        #magnets();
        translate([0, 0, h_1]) #magnets();
    }

    //floor
    translate([0, 0, - floor_thickness]) difference() {
        cylinder(d = d_soap * (1 / cos(180 / sides)), h = floor_thickness, $fn = sides);
        for (i = [- 5:5], j = [- 5:5])
        rotate([0, 0, 30])
            translate([hole_spacing * i, 0, 0])
                rotate([0, 0, 60])
                    translate([j * hole_spacing, 0, - .01])
                        rotate([0, 0, 30])
                            cylinder(d = (hole_spacing - floor_thickness) / cos(30), h = floor_thickness + .02, $fn = 6);
    }
}


module lid() {
    difference() {
        union(){
            //cut off tips
            difference(){
                translate([0, 0, - r_0 * sin(wobble) - floor_thickness]) walls();
                cylinder(r = r_1 * 11, h = h_1 * 11, $fn = 4);
            }
            //not cut off shorter tips
            translate([0, 0, - r_0 * sin(wobble) - floor_thickness]) walls(h_1=h_1/2);
            //ceiling
            translate([0, 0, - floor_thickness])
                cylinder(d = d_soap * (1 / cos(180 / sides)), h = floor_thickness, $fn = sides);
        }
        translate([0, 0, - r_0 * sin(wobble) - floor_thickness]) #magnets();
    }
}


if(selected_module == "all"){
    spacing = h_1 + 20;
    translate([0, 0, spacing*-1])
        mirror([0,0,1])
        rotate([0,0,360/sides])
        lid();
    translate([0, 0, spacing*0]) chamber();
    translate([0, 0, spacing*1]) chamber();
    translate([0, 0, spacing*2]) lid();

} else if (selected_module == "chamber"){
    chamber();
} else if (selected_module == "lid"){
    translate([0, 0, h_1 + 10]) lid();
} else if (selected_module == "support blocker"){
    support_blocker();
}