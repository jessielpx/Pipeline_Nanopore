#!/usr/bin/env python3

import argparse
from pathlib import Path

import pandas as pd


def parse_args():
    parser = argparse.ArgumentParser(
        description="Merge Salmon quant.sf-style files into count and TPM matrices."
    )
    parser.add_argument(
        "--inputs",
        nargs="+",
        required=True,
        help="Sample-level Salmon transcript count TSV files."
    )
    parser.add_argument(
        "--counts-output",
        required=True,
        help="Output path for merged NumReads matrix."
    )
    parser.add_argument(
        "--tpm-output",
        required=True,
        help="Output path for merged TPM matrix."
    )
    return parser.parse_args()


def sample_name_from_path(path):
    suffix = ".transcript_counts.tsv"
    name = Path(path).name
    if name.endswith(suffix):
        return name[:-len(suffix)]
    return Path(path).stem


def main():
    args = parse_args()

    count_tables = []
    tpm_tables = []

    for input_file in args.inputs:
        sample = sample_name_from_path(input_file)
        table = pd.read_csv(input_file, sep="\t")

        required_columns = {"Name", "TPM", "NumReads"}
        missing = required_columns.difference(table.columns)

        if missing:
            raise ValueError(
                f"{input_file} is missing required columns: "
                f"{', '.join(sorted(missing))}"
            )

        count_tables.append(
            table[["Name", "NumReads"]].rename(
                columns={"NumReads": sample}
            )
        )

        tpm_tables.append(
            table[["Name", "TPM"]].rename(
                columns={"TPM": sample}
            )
        )

    counts = count_tables[0]
    for table in count_tables[1:]:
        counts = counts.merge(table, on="Name", how="outer")

    tpm = tpm_tables[0]
    for table in tpm_tables[1:]:
        tpm = tpm.merge(table, on="Name", how="outer")

    counts = counts.fillna(0)
    tpm = tpm.fillna(0)

    sample_columns = sorted(counts.columns.drop("Name"))
    counts = counts[["Name", *sample_columns]]
    tpm = tpm[["Name", *sample_columns]]

    counts.to_csv(args.counts_output, sep="\t", index=False)
    tpm.to_csv(args.tpm_output, sep="\t", index=False)


if __name__ == "__main__":
    main()
