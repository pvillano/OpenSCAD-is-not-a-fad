#!/usr/bin/env python3
import argparse
import json
import os.path
import random
import subprocess
from itertools import chain

import trio
from tqdm import tqdm


async def render_parameter_set(progress_bar: tqdm, args, parameter_file, parameter_set: str):
    output_filename = parameter_set + "." + args.export_format
    check_filename(output_filename)
    features = "fast-csg fast-csg-safer lazy-union".split()
    features = chain.from_iterable(("--enable", feat) for feat in features)
    subprocess_args = [args.openscad_exe, *features, args.scad_file, "-p", parameter_file, "-P", parameter_set, "-o",
                       os.path.join(args.output_dir, output_filename), ]
    if args.verbose:
        print(">>>", subprocess.list2cmdline(subprocess_args))

    if not args.dry_run:
        finished_process = await trio.run_process(subprocess_args, capture_stderr=True, capture_stdout=True)
        finished_process.check_returncode()
    await trio.sleep(random.randint(1, 10))
    progress_bar.update(1)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Render each parameter set in PARAMETER_FILES for SCAD_FILE.")
    parser.add_argument("scad_file", metavar="SCAD_FILE", type=str, help="file to render each parameterization of", )
    parser.add_argument("parameter_files", nargs="*", metavar="PARAMETER_FILES", help="defaults to <SCAD_FILE>.json", )
    parser.add_argument("--export-format", metavar="FORM", default="stl", help="Any of " + ", ".join(EXPORT_CHOICES),
                        choices=EXPORT_CHOICES)
    parser.add_argument("--output-dir", metavar="DIR", help="defaults to the same directory as the SCAD file", )
    parser.add_argument("--openscad-exe", metavar="EXE", default="openscad", help="alias or path to openscad exe", )
    parser.add_argument("--dry-run", action="store_true", help="don't create any files")
    parser.add_argument("--verbose", action="store_true", help="explain what is being done")
    args = parser.parse_args()

    if not args.scad_file.endswith(".scad"):
        raise ValueError("scad file must end with .scad")

    if not args.parameter_files:
        args.parameter_files = [args.scad_file.removesuffix(".scad") + ".json"]

    if not args.output_dir:
        args.output_dir = os.path.split(args.scad_file)[0]

    return args


def pair_maker(parameter_files):
    for parameter_file in parameter_files:
        with open(parameter_file, mode="r") as f:
            parameter_set_json = json.load(f)
            file_format_version = parameter_set_json["fileFormatVersion"]
            if not file_format_version == "1":
                raise ValueError(f"Unsupported fileFormatVersion {file_format_version}")
            for parameter_set in parameter_set_json["parameterSets"].keys():
                yield parameter_file, parameter_set


async def main():
    args = parse_args()
    try:
        await trio.run_process([args.openscad_exe, "--version"], capture_stderr=True, capture_stdout=True)
    except FileNotFoundError as e:
        raise FileNotFoundError(f"The system cannot find the executable {args.openscad_exe}") from e

    pairs = list(pair_maker(args.parameter_files))
    progress_bar = tqdm(total=len(pairs))
    async with trio.open_nursery() as nursery:
        for parameter_file, parameter_set in pairs:
            nursery.start_soon(render_parameter_set, progress_bar, args, parameter_file, parameter_set)
    progress_bar.close()
    print("Finished!")


def check_filename(filename):
    WINDOWS_RESERVED_FILENAMES = "CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8 COM9 LPT1 LPT2 LPT3 LPT4 LPT5 LPT6 LPT7 LPT8 LPT9".split()
    if set('<>:"/\\|?*').intersection(filename):
        raise OSError(f"Output filename set '{filename}' contains reserved characters")
    if filename.split(".")[0] in WINDOWS_RESERVED_FILENAMES:
        raise OSError(f"Output filename '{filename}' is windows reserved")


EXPORT_CHOICES = "stl off amf 3mf csg dxf svg pdf png echo ast term nef3 nefd   bg".split()
if __name__ == "__main__":
    trio.run(main)
