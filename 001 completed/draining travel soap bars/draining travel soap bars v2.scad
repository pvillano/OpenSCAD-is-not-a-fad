$fs = $preview ? 10 : 1;
sides = 6;

// should include slop!
h_soap = 15;
// should include slop!
d_soap = 40;
twt=1.29;
floor_thickness = 2;
foot_height = 8;

h_magnet = 54.4/30 + .2;
w_magnet = 20.17/4 + .5;
l_magnet = 38.17/2 + .2;


wall_thickness = 2*twt+h_magnet;

wobble = 8;
hole_spacing = (d_soap + floor_thickness+.01) / 3;
hole_percent = 75;
/*
# travel soap container
draining epoxy-coated travel soap bar container

## constraints
I want to make something to hold my travel soap bars with the following constraints
1. waterproof - sealed with epoxy resin
2. draining
3. compact
4. sealed completely when closed
5. doesn't drain on top of eachother
6. needs to hold 3 pucks: soap, shampoo, conditioner

## ideation
* so one design could be like stacking cups with two diameters, holes on the bottom and a lid on top.
    * the bottommost one needs an extra lid for transport
* what if there was a shaft that the holders swung out from?
* what if I got some tins -> no draining
* what if it was held together with magnets? then I wouldn't have to worry about expoxy affecting clearances

## final design
five parts: a top lid, three chambers and a bottom lid. hexagons, just for funsies

##for version 2
the chambers could have three sloping feet that nest with the chamber below. one traingle wave
*/
/*
* the problem is making it seal e. the geometry of the top must mate with the geometry of the bottom
* even though both have a coat of epoxy of an unknown thickness! this is not trivial...
    * a ball and socket is not possible
    * two planes does work
    * a cone works
    * a corner to a corner works
    * not sure about saddles
* the problem can be formalied as follows: find two surfaces embedded in 3d space such that when either surface is
       explanded in the local normal direction they can still mate
 */

/*
I did this on paper, but the mesh is built like a tube, with points arranged "spiraling" along it's "length".
since the pattern of points is periodic, generating the faces is "easy" as 1234,2345,3456...
the tube loops back on itself, so the final faces are 7891,8912,9123
 */
/*
none of this really matters since I already decided that the corners will touch the ground at two points
Edit: this is impossible i think
for a loop of edges to be a polygon, they must all lie in the same plane
for a quadrilateral, two opposite are skew iff the other pair of opposite edges are skew.

* option 1:/ interpolate the saddles, sweeping opposite edges, creating a saddle
    * might interfere with fit
* option 2:) attempt to exploit/discover remaining degrees of freedom so that it's all neat polygons
    * :( foot could touch ground at an angle
    * :( walls could have uneven thickness wait no that doesn't matter
    * :'D tilt troughs up and peaks down. point both to the same point on the z axis
* option 3:( make every saddle concave
* option 4:( match concave and convex saddles
*/
//distance from center
r_0 = d_soap / 2 * (1 / cos(180 / sides)) * (1 / cos(wobble));
r_1 = (d_soap / 2 + wall_thickness) * (1 / cos(180 / sides)) * (1 / cos(wobble));
h_0 = 0;
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

module walls() {
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
        translate([0, 0, - r_0 * sin(wobble) - floor_thickness]) walls();
        cylinder(r = r_1 * 11, h = h_1 * 11, $fn = 4);
    }
    translate([0, 0, - floor_thickness])
        cylinder(d = d_soap * (1 / cos(180 / sides)), h = floor_thickness, $fn = sides);
}


//chamber();
//translate([0, 0, h_1 + 10]) lid();
support_blocker();
%cylinder(h = h_soap, d = d_soap, $fn = 24);