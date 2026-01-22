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
    lastEmittedF = 0
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
        op_code, *params_list = line.strip().split()
        if demo and op_code in "G80 M106 M104 M140 M109 M190 Tx Tc".split():
            yield "; " + raw_line
            continue
        if op_code not in {"G0", "G1"}:
            yield raw_line
            continue
        params_dict = {XYZEF[0]: float(XYZEF[1:]) for XYZEF in params_list}
        nextX = params_dict.get("X", X)
        nextY = params_dict.get("Y", Y)
        nextZ = params_dict.get("Z", Z)
        # inputF is only set by original g-code
        inputF = params_dict.get("F", inputF)
        dX = nextX - X
        dY = nextY - Y
        dZ = nextZ - Z
        if dX == dY == dZ == 0:
            # we are not moving, preserve
            lastEmittedF = params_dict.get("F", lastEmittedF)
            yield raw_line
        else:
            new_tokens = [op_code, *params_list]
            # TODO: handle arbitrary params order
            if new_tokens[-1].startswith("F"):
                new_tokens.pop()

            if dY != 0:
                if gantry == "corexy":
                    d, direction = max((abs(dX - dY), "X-Y"), (abs(dX + dY), "X+Y"), (abs(dZ), "Z"))
                else:
                    d, direction = max((abs(dX), "X"), (abs(dY), "Y"), (abs(dZ), "Z"))
                V = sqrt((inputF ** 2) * (d ** 2) / (dX ** 2 + dY ** 2 + dZ ** 2))
                targetV = tune(V)

                nextF = inputF * targetV / V
                if int(nextF) != int(lastEmittedF):
                    new_tokens.append(f"F{int(nextF)}")
                    lastEmittedF = nextF
                    if comments == "":
                        comments = f" {direction} vel {V:.0f}->{targetV:.0f}"

            if comments:
                new_tokens.append(f";{comments}")

            yield " ".join(new_tokens) + "\n"
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
