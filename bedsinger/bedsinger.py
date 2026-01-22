#!/usr/bin/env python3
import argparse
import sys
from collections.abc import Iterable
from math import sqrt, floor, log


def tune(frequency: float) -> float:
    nearest_octave = 2 ** floor(log(frequency, 2))
    candidates = [
        nearest_octave * 24 / 24,  # first
        nearest_octave * 27 / 24,  # second
        nearest_octave * 30 / 24,  # third
        nearest_octave * 36 / 24,  # fifth
        nearest_octave * 40 / 24,  # sixth
    ]
    candidate = max([note for note in candidates if note <= frequency])
    # lowers, and by at most an octave
    assert (frequency / 2) <= candidate <= frequency
    return candidate


def translate(lines: Iterable[str], demo: bool, gantry: str):
    X = 0
    Y = 0
    Z = 0
    lastEmittedF = '0'
    inputF = 0
    for raw_line in lines:
        if len(raw_line.strip()) == 0:
            yield raw_line
            continue
        line, *maybe_comments = raw_line.split(";", 1)
        if len(line.strip()) == 0:
            yield raw_line
            continue
        comments = maybe_comments[0] if maybe_comments else ""
        tokens = line.strip().split()
        if demo and tokens[0] in "G80 M106 M104 M140 M109 M190 Tx Tc".split():
            yield "; " + raw_line
            continue
        if tokens[0] not in {"G0", "G1"}:
            yield raw_line
            continue
        tokens_dict: dict[str, str] = {XYZEF[0]: XYZEF[1:] for XYZEF in tokens}
        nextX = float(tokens_dict.get("X", X))
        nextY = float(tokens_dict.get("Y", Y))
        nextZ = float(tokens_dict.get("Z", Z))
        # inputF is only set by original g-code
        inputF = float(tokens_dict.get("F", inputF))
        dX = nextX - X
        dY = nextY - Y
        dZ = nextZ - Z
        if dX == dY == dZ == 0:
            # we are not moving, preserve
            lastEmittedF:str = tokens_dict.get("F", lastEmittedF)
            yield raw_line
        else:
            if gantry == "corexy":
                d, direction = max((abs(dX - dY), "X-Y"), (abs(dX + dY), "X+Y"), (abs(dZ), "Z"))
            else:
                d, direction = max((abs(dX), "X"), (abs(dY), "Y"), (abs(dZ), "Z"))
            V = sqrt((inputF ** 2) * (d ** 2) / (dX ** 2 + dY ** 2 + dZ ** 2))
            targetV = tune(V)

            nextF: float = inputF * targetV / V
            if int(nextF) != int(float(lastEmittedF)):
                tokens_dict["F"] = f"{int(nextF)}"
                lastEmittedF = f"{int(nextF)}"
                if comments == "":
                    comments = f" {direction} vel {V:.0f}->{targetV:.0f}"
            else:
                if "F" in tokens_dict:
                    tokens_dict.pop("F")

            result = " ".join(map(lambda kv: f"{kv[0]}{kv[1]}", tokens_dict.items()))
            if comments:
                result += f" ;{comments}"

            yield result + "\n"
        X = nextX
        Y = nextY
        Z = nextZ


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("file")

    parser.add_argument(
        "-d",
        "--demo",
        help="heating, fans, and Prusa MMU commands are commented out",
        action="store_true",
    )
    parser.add_argument(
        "--gantry",
        help="Cartesian printers include Ender 3, Prusa MK4/Mini, and Bambu A1/mini.  "
             "CoreXY printers include Ender K, Prusa CORE One, and Bambu H/X/P.",
        nargs="?",
        default="cartesian",
        choices=["cartesian", "corexy"],
    )
    args = parser.parse_args()

    print("; Warning: bedsinger is brittle af. Use at your own risk", file=sys.stderr)
    with open(args.file, encoding="utf-8") as f:
        for line in translate(f, args.demo, args.gantry):
            print(line, end="")


if __name__ == "__main__":
    main()
