from solid import *
from solid.utils import *

from rocky_common import *

resolution = .1
num_rings = 20

def main():
    base_ring = translate([.5,0,0])(rotate([45,0,0])(torus(1,1/num_rings, resolution)))
    part = []
    for i in range(num_rings):
        part.append(rotate([0,0,360*i/num_rings])(base_ring))
    generate_part(union()(part), 'ring_thing', .3)

if __name__ == '__main__':
    main()
