#!/usr/bin/env python3
import argparse
import subprocess
import json
import sys

EXPORT_CHOICES = [
    "stl",
    "off",
    "amf",
    "3mf",
    "csg",
    "dxf",
    "svg",
    "pdf",
    "png",
    "echo",
    "ast",
    "term",
    "nef3",
    "nefdbg",
]

WINDOWS_RESERVED_FILENAMES = [
    "CON",
    "PRN",
    "AUX",
    "NUL",
    "COM1",
    "COM2",
    "COM3",
    "COM4",
    "COM5",
    "COM6",
    "COM7",
    "COM8",
    "COM9",
    "LPT1",
    "LPT2",
    "LPT3",
    "LPT4",
    "LPT5",
    "LPT6",
    "LPT7",
    "LPT8",
    "LPT9",
]


def print_err(*args, **kwargs):
    kwargs["file"] = sys.stderr
    kwargs["flush"] = True
    print(*args, **kwargs)


def render_parameter_set(args, parameter_file, parameter_set):
    parameter_set: str
    reserved_overlap = set('<>:"/\\|?*').intersection(parameter_set)
    if reserved_overlap:
        print_err(
            f"Warning: file name contains windows reserved characters:  {''.join(reserved_overlap)} "
        )
    if any(
        parameter_set == reserved or parameter_set.startswith(reserved + ".")
        for reserved in WINDOWS_RESERVED_FILENAMES
    ):
        print_err(f"Warning: filename is windows reserved: {parameter_set}")

    subprocess_args = [
        args.openscad_exe,
        args.scad_file,
        "-p",
        parameter_file,
        "-P",
        parameter_set,
        "-o",
        parameter_set + "." + args.export_format,
    ]
    if args.verbose:
        print(">>>", subprocess.list2cmdline(subprocess_args))

    if not args.dry_run:
        process = subprocess.run(subprocess_args, capture_output=True, text=True)
        if args.verbose and process.stdout.strip():
            for line in process.stdout.strip().split("\n"):
                print("OpenSCAD:", line)
        if process.returncode != 0:
            if args.verbose:
                print_err(
                    f"Error: openscad returned with exit code {process.returncode}"
                )
            for line in process.stderr.strip().split("\n"):
                print("Error (OpenSCAD):", line)


def main():
    parser = argparse.ArgumentParser(
        description="Renders exports for all parameter sets for a given model and parameter file. "
        + "Supported formats include "
        + ", ".join(EXPORT_CHOICES)
    )
    parser.add_argument(
        "scad_file",
        metavar="SCAD_FILE",
        type=str,
        help="file to render each parameterization of",
    )
    parser.add_argument(
        "parameter_files",
        nargs="*",
        metavar="PARAMETER_FILES",
        help="defaults to <SCAD_FILE>.json",
    )
    parser.add_argument(
        "--export-format",
        metavar="FORM",
        default="stl",
        help="Override export format from STL",
        choices=EXPORT_CHOICES,
    )
    # todo
    # parser.add_argument("-D", help="var=val -pre-define variables")
    parser.add_argument(
        "--openscad-exe",
        metavar="EXE",
        default="openscad",
        help="alias or path to openscad exe",
    )
    parser.add_argument("--dry-run", action="store_true", help="don't create any files")
    parser.add_argument(
        "--verbose", action="store_true", help="explain what is being done"
    )
    args = parser.parse_args()

    args.scad_file: str
    if not args.scad_file.endswith(".scad"):
        raise ValueError("scad file must end with .scad")

    if not args.parameter_files:
        args.parameter_files = [args.scad_file.removesuffix(".scad") + ".json"]

    for parameter_file in args.parameter_files:
        try:
            with open(parameter_file, mode="r") as f:
                parameter_set_json = json.load(f)
                file_format_version = parameter_set_json["fileFormatVersion"]
                if not file_format_version == "1":
                    raise ValueError(
                        f"Unsupported fileFormatVersion {file_format_version}"
                    )

                for parameter_set in parameter_set_json["parameterSets"].keys():
                    render_parameter_set(args, parameter_file, parameter_set)
        except FileNotFoundError:
            print_err(f"Error: {parameter_file} not found. Continuing...")


if __name__ == "__main__":
    main()
