#!/usr/bin/env python3

import argparse
import csv
from pathlib import Path


def read_conditions(samplesheet: Path) -> dict[str, str]:
    conditions = {}

    with samplesheet.open(newline="") as handle:
        reader = csv.DictReader(handle)

        for row in reader:
            conditions[row["sample"]] = row["condition"]

    return conditions


def clean_sample_name(sample_value: str) -> str:
    sample_name = Path(sample_value).name

    for suffix in (".fastq.gz", ".fq.gz", ".fastq", ".fq"):
        if sample_name.endswith(suffix):
            return sample_name.removesuffix(suffix)

    return sample_name


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Merge per-sample JAFFAL CSV files."
    )

    parser.add_argument(
        "--input",
        required=True,
        nargs="+",
        type=Path,
        help="One or more per-sample JAFFAL CSV files.",
    )

    parser.add_argument(
        "--samplesheet",
        required=True,
        type=Path,
        help="Samplesheet containing sample and condition columns.",
    )

    parser.add_argument(
        "--output",
        required=True,
        type=Path,
        help="Merged output CSV.",
    )

    args = parser.parse_args()

    conditions = read_conditions(args.samplesheet)
    csv_files = sorted(args.input)

    args.output.parent.mkdir(parents=True, exist_ok=True)

    output_fields = None
    writer = None
    total_rows = 0

    with args.output.open("w", newline="") as output_handle:

        for csv_file in csv_files:
            with csv_file.open(newline="") as input_handle:
                reader = csv.DictReader(input_handle)

                if reader.fieldnames is None:
                    continue

                if "sample" not in reader.fieldnames:
                    raise ValueError(
                        f"Missing 'sample' column in {csv_file}"
                    )

                if output_fields is None:
                    output_fields = [
                        "sample_name",
                        "condition",
                        *reader.fieldnames,
                    ]

                    writer = csv.DictWriter(
                        output_handle,
                        fieldnames=output_fields,
                    )

                    writer.writeheader()

                for row in reader:
                    sample_name = clean_sample_name(row["sample"])

                    output_row = {
                        "sample_name": sample_name,
                        "condition": conditions.get(
                            sample_name,
                            "unknown",
                        ),
                        **row,
                    }

                    writer.writerow(output_row)
                    total_rows += 1

    if writer is None:
        raise RuntimeError(
            "No valid JAFFAL CSV files were provided."
        )

    print(f"Merged {len(csv_files)} JAFFAL files.")
    print(f"Wrote {total_rows} fusion records.")
    print(f"Output: {args.output}")


if __name__ == "__main__":
    main()
