/*
    Authors: Peter Villano

    This work is licensed under the Creative Commons Attribution 4.0 International License. To view a copy of this license, visit
http://creativecommons.org/licenses/by/4.0/.
*/

Diameter = 60;
Height = 60;
Mesh_Spacing = 7;
Mesh_Overhang = 2;
//Vertical spacing between triangles
Buffer_Height = .4; // [.1:.05:.4]
//Horizontal gap between triangles
Buffer_Width = .4; // [.1:.05:.4]
module __Customizer_Limit__() {};

d = Diameter;
h = Height;

$fa = .01;
$fs = $preview ? 1 : .3;
sin60 = sin(60);
c_count = round(d * PI / (Mesh_Spacing + Buffer_Width));
z_count = round(h / (Mesh_Spacing + Buffer_Height));
dr = Mesh_Overhang;
dz = h / z_count;


module star(r, dr, count, buffer) {
    function polar(i, r) = [cos(i * 360 / count), sin(i * 360 / count)] * r;
    dc = buffer / (r * 2 * PI) * count / 2;
    points = [
        [for (i = [1:count]) polar(i, r)],
        [for (i = [1:count]) polar(i + .5 - dc, r + dr)],
        [for (i = [1:count]) polar(i + .5 + dc, r + dr)],
        ];
    //points = [for (i = [1:count]) ((i % 2) ? polar(i, r) : polar(i, r + dr))];
    swizzled_points = [for (i = [0:count * 3 - 1]) points[i % 3][floor(i / 3)]];
    polygon(swizzled_points);
}
for (i = [0:z_count - 1]) rotate([0, 0, 180 / c_count * i]) translate([0, 0, dz * i]) {
    translate([0, 0, Buffer_Height]) intersection() {
        cylinder(d = d, h = dz + .01);
        linear_extrude(dz - Buffer_Height + .01, scale = d / (d + dr * 2)) star(d / 2, dr, c_count, Buffer_Width);
    }
    cylinder(d = d, h = Buffer_Height + .01);
}