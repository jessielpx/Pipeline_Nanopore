#!/usr/bin/env python3

import argparse
import re

import pandas as pd


def parse_args():
    parser = argparse.ArgumentParser(
        description="Extract transcript annotations from a gffcompare annotated GTF."
    )
    parser.add_argument(
        "--gtf",
        required=True,
        help="gffcompare annotated GTF file."
    )
    parser.add_argument(
        "--output",
        required=True,
        help="Output transcript annotation TSV."
    )
    return parser.parse_args()


def get_attribute(attributes: str, key: str):
    pattern = rf'(?:^|;\s*){re.escape(key)}\s+"([^"]*)"'
    match = re.search(pattern, attributes)
    return match.group(1) if match else None


def main():
    args = parse_args()
    records = []

    with open(args.gtf, "r", encoding="utf-8") as handle:
        for line in handle:
            if line.startswith("#"):
                continue

            fields = line.rstrip("\n").split("\t")

            if len(fields) != 9:
                continue

            chromosome, source, feature, start, end, score, strand, frame, attributes = fields

            if feature != "transcript":
                continue

            transcript_id = get_attribute(attributes, "transcript_id")

            if not transcript_id:
                continue

            records.append(
                {
                    "transcript_id": transcript_id,
                    "gene_id": get_attribute(attributes, "gene_id"),
                    "ref_gene_id": get_attribute(attributes, "ref_gene_id"),
                    "gene_name": (
                        get_attribute(attributes, "ref_gene_name")
                        or get_attribute(attributes, "gene_name")
                    ),
                    "ref_id": (
                        get_attribute(attributes, "cmp_ref")
                        or get_attribute(attributes, "ref_id")
                    ),
                    "class_code": get_attribute(attributes, "class_code"),
                    "chromosome": chromosome,
                    "start": int(start),
                    "end": int(end),
                    "strand": strand,
                    "source": source,
                }
            )

    annotation = pd.DataFrame(records)

    if annotation.empty:
        raise ValueError(
            f"No transcript records were found in {args.gtf}"
        )

    annotation = annotation.drop_duplicates(
        subset=["transcript_id"]
    ).sort_values(
        by=["chromosome", "start", "end", "transcript_id"]
    )

    annotation.to_csv(
        args.output,
        sep="\t",
        index=False,
        na_rep=""
    )


if __name__ == "__main__":
    main()
