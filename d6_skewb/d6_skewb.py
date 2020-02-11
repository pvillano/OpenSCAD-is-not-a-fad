from solid import *
from solid.utils import *

from rocky_common import *

def rotate_list(l):
    l.append(l.pop(0))

def main(
    p = [9,0,3],
    angle = 30,
    sep = 2.2):

    p2 = list(p)
    p2[2] += sep
    spheres = translate([0,0,0])(sphere()) + translate([0,0, 2*p[2] + sep])(sphere())
    for i in range(3):
        spheres += rotate(360/3*i, [0,0,1])(translate(p)(sphere()))
        spheres += rotate(360/3*i + angle, [0,0,1])(translate(p2)(sphere()))
    body = hull()(spheres)
    generate_part(body, 'skewb', .3)



if __name__ == '__main__':
    main()
