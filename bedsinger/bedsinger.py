#!/usr/bin/env python3
import argparse
import sys
from collections import Counter
from collections.abc import Iterable
from math import sqrt, floor, log2, log


def alpha_only(s: str) -> str:
    return "".join(ch for ch in s if ch.isalpha())


def tune(frequency: float) -> float:
    #TODO: analyse the overtone series for a better set of notes...
    nearest_octave = 2 ** floor(log(frequency, 2))
    candidates = [
        nearest_octave * 24/24, # first
        nearest_octave * 27/24, # second
        nearest_octave * 30/24, # third
        nearest_octave * 36/24, # fifth
        nearest_octave * 40/24, # sixth
    ]
    candidate = max([note for note in candidates if note <= frequency])
    # lowers, and by at most an octave
    assert (frequency / 2) <= candidate <= frequency
    return candidate


def translate(lines: Iterable[str], dry_run=True, axis: str = 'Y'):
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
        if dry_run and op_code in {'G80', 'M106', 'M104', 'M140', 'M109', 'M190', 'Tx', 'Tc'}:
            continue
        if op_code not in {'G0', 'G1'}:
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
        # TODO: don't hardcode Y
        if dX == dY == dZ == 0:
            # we are not moving, preserve
            lastEmittedF = params_dict.get("F", lastEmittedF)
            yield raw_line
        else:
            new_tokens = [op_code, *params_list]
            # TODO: handle arbitrary params order
            if new_tokens[-1].startswith('F'):
                new_tokens.pop()

            if dY != 0:
                # dX^2 + dY^2 + dZ^2 = c * F^2
                d, direction = max((abs(dX), 'X'), (abs(dY), 'Y'), (abs(dZ), 'Z'))
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


def stats(lines: Iterable[str]):
    opcode_counter = Counter()
    g1_axis_counter = Counter()
    feedrate_counter = Counter()
    for line in lines:
        line = line.strip()
        line, *comments = line.split(";")
        if not line:
            continue
        tokens = line.split()
        opcode_counter[tokens[0]] += 1
        match tokens:
            case ["G1", *rest]:
                alpha = alpha_only(line[2:])
                g1_axis_counter["G2" + alpha] += 1
                for r in rest:
                    if r.startswith("F"):
                        feedrate_counter[float(r[1:])] += 1
            #     case ["M204"]:
            #         opcode_counter["M204 - Set Starting Acceleration"] += 1
            #     case ["M73"]:
            #         opcode_counter["M73 - Set Print Progress"] += 1
            #     case ["G92"]:
            #         opcode_counter["G92 - Set Position"] += 1
            case _:
                opcode_counter["unhandled"] += 1

    print(opcode_counter.most_common(10), file=sys.stderr)
    print(g1_axis_counter.most_common(99), file=sys.stderr)
    print(min(feedrate_counter.items()), " ".join(sorted(map(str, feedrate_counter.most_common(3)))),
          max(feedrate_counter.items()), file=sys.stderr)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("filename")
    parser.add_argument("axis", nargs="?", default="y")
    args = parser.parse_args()

    print("; Warning: bedsinger is brittle af. Use at your own risk", file=sys.stderr)
    # with open(args.filename, encoding="utf-8") as f:
    #     stats(f)
    with open(args.filename, encoding="utf-8") as f:
        for line in translate(f):
            print(line, end="")


if __name__ == '__main__':
    main()
