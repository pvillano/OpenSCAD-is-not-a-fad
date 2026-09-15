from itertools import chain
from math import pi, sin, cos, ceil

from libraries.stl import STLBuffer

outer_diameter = 20
h = 20
depth = 5
layer_height = .3
cell_width = 8
nozzle_diameter = .6
od = outer_diameter
solid_layers_height = 1.

# unchanging
first_layer = .2
filter_od_unused = 175

sector_count = round(3.1415*od/cell_width/4)*2+1
extrusion_width = .75*nozzle_diameter
inner_diameter = outer_diameter - 2*depth

n = ceil(h / layer_height * sector_count)

type Point = tuple[float, float, float]
type Triangle = tuple[Point, Point, Point]
type Quad = tuple[Point, Point, Point, Point]

def coord(theta: float,r: float=od/2 ) -> Point:
    return r * cos(theta), r * sin(theta), theta / (2 * pi) * layer_height

def quad_to_tris(quad: Quad) -> tuple[Triangle, Triangle]:
    return (quad[0], quad[1], quad[2]), (quad[0], quad[2], quad[3])




"""
Each sector is seven quads
five for the inset,
    one below,
and one to the side

p02--------p12----------------p22
|||        |||      hole      |||
p01 before p11----------------p21
|||        |||     under      |||
p00--------p10----------------p20
a0         a1                 a2

p12--------------------p22
 |  \\      top     //  | 
 |    p12a------p22a    | 
 |  L  ||  back  ||  R  | 
 |    p11a------p21a    | 
 |  //    bottom    \\  | 
p11--------------------p21
a1   a1a        a2a    a2
"""

def main():

    stlOut = STLBuffer()

    for i in range(0,n):

        a0 = i * 2*pi/sector_count
        a1 = a0 + extrusion_width/(outer_diameter*pi)*2*pi
        a1a = a0 + extrusion_width/(inner_diameter*pi)*2*pi #slightly larger than a1a
        a2 = (i + 1 ) * 2*pi/sector_count
        a2a = a2 - (a1a - a1)

        p00 = coord(a0)
        p01 = coord(a0+2*pi)
        p02 = coord(a0+4*pi)
        p10 = coord(a1)
        p11 = coord(a1+2*pi)
        p12 = coord(a1+4*pi)
        p20 = coord(a2)
        p21 = coord(a2+2*pi)
        p22 = coord(a2+4*pi)
        p11a = coord(a1a+2*pi, inner_diameter/2)
        p12a = coord(a1a+4*pi, inner_diameter/2)
        p21a = coord(a2a+2*pi, inner_diameter/2)
        p22a = coord(a2a+4*pi, inner_diameter/2)


        # quads, verts are ccw from lower left
        before = (p00, p10, p12, p02)
        under = (p10, p20, p21, p11)

        left = (p11, p11a, p12a, p12)
        bottom = (p11, p21, p21a, p11a)
        right = (p21a, p21, p22, p22a)
        top = (p12a, p22a, p22, p12)
        back = (p11a, p21a, p22a, p12a)

        quads = [before, under, left, bottom, right, top, back]
        tris = chain.from_iterable(quad_to_tris(quad) for quad in quads)
        stlOut.write_triangles(tris)
    with open("output.stl", "wb") as f:
        f.write(stlOut.getvalue())
if __name__ == '__main__':
    main()
