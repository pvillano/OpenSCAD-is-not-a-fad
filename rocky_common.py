from typing import Iterable

from solid import *
from solid.utils import *


def line(a: Tuple[float, float, float], b: Tuple[float, float, float], r: float=1.0, capped=True):
    if capped:
        return hull()(
            translate(a)(sphere(r=r)),
            translate(b)(sphere(r=r))
        )
    else:
        return hull()(
            hull()(
                translate(a)(sphere(r=r)),
                translate(b)(sphere(r=r))
            )
            - translate(a)(sphere(r=r))
            - translate(b)(sphere(r=r))
        )



def mix(p1: Tuple[float, float, float], p2: Tuple[float, float, float], a: float):
    if len(p1) != len(p2):
        raise IndexError()
    return tuple((x * (1 - a)) + (y * a) for x, y in zip(p1, p2))


def pairwise_hull(objs: Iterable[OpenSCADObject]):
    return sum(hull()(a, b) for a, b in zip(objs, objs[1:]))



__all__ = [
    'line',
    'mix',
    'pairwise_hull'
]