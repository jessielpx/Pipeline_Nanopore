# Krill-Pipeline-Nanopore

Hi colleagues, this is the pipeline I made for Nanopore long-read RNA sequencing data. The pipeline performs quality control, genome alignment, transcriptome analysis, differential expression analysis, and gene fusion detection using JAFFAL.

The pipeline was designed for running on Rorqual, that's why I named it "Krill".

## Overview

# Pipeline workflow

```
Raw FASTQ files
        │
        ▼
FASTCAT
        │
        ▼
Genome alignment
        │
        ├──────────────► JAFFAL
        │                     
        ▼
Transcriptome analysis
        │
        ▼
Annotation analysis
        │
        ▼
Differential expression analysis
```

---

# Before you start

Before running the pipeline, prepare the following:

* Raw FASTQ directory
* Sequencing summary file
* Sample sheet
* Reference genome (FASTA)
* Reference annotation (GTF)
* JAFFAL reference directory
* A working directory for the sequencing run

The following sections describe each item in detail.

---

# Input files

## 1. Raw FASTQ directory

Provide the directory containing barcode folders produced after Nanopore basecalling.

Example:

```
batch1-8/

barcode01/
barcode02/
barcode03/
...
barcode96/
```

Pipeline parameter:

```
--fastq_dir
```

---

## 2. Sequencing summary

Provide the sequencing summary generated during basecalling.

Example:

```
sequencing_summary_run2_5.txt
```

Pipeline parameter:

```
--summary
```

---

## 3. Sample sheet

The sample sheet links sequencing barcodes to biological samples and experimental groups.

Pipeline parameter:

```
--samplesheet
```

Required columns:

| Column    | Description                 |
| --------- | --------------------------- |
| barcode   | Nanopore barcode directory  |
| sample    | Sample identifier           |
| alias     | Sample name used in reports |
| condition | Experimental condition      |

Example:

| barcode   | sample   | alias      | condition |
| --------- | -------- | ---------- | --------- |
| barcode13 | sample16 | Patient001 | HR        |
| barcode14 | sample72 | Patient002 | control   |

---

## 4. Reference genome

Genome FASTA used for alignment.

Pipeline parameter:

```
--ref_genome
```

Example:

```
Homo_sapiens.GRCh38.fa
```

---

## 5. Reference annotation

Genome annotation in GTF format.

Pipeline parameter:

```
--ref_annotation
```

Example:

```
genes.gtf
```

---

## 6. JAFFAL reference

JAFFAL requires a pre-built reference directory.

Pipeline parameter:

```
--jaffal_ref_dir
```

Example:

```
JAFFA_reference_hg38_gencode49/

hg38.fa
hg38_gencode49.fa
hg38_gencode49.bed
hg38_gencode49.tab
...
```

For our laboratory, this directory is available in the shared folder.

---

# Preparing a run directory

Create one working directory for each sequencing batch.

Example:

```
Batch2/

batch2_samples.csv

alignment/

bam/

fastcat/

differential_expression/

jaffal/

logs/

nextflow_work/
```

The pipeline writes all outputs into this directory.

---

# Running the pipeline

## Interactive execution

Example:

```bash
nextflow run . \
    -profile rorqual \
    --samplesheet batch2_samples.csv \
    --summary sequencing_summary.txt \
    --fastq_dir batch1-8 \
    --ref_genome Homo_sapiens.GRCh38.fa \
    --ref_annotation genes.gtf \
    --jaffal_ref_dir JAFFA_reference_hg38_gencode49 \
    --run_id Batch2 \
    --outdir Batch2
```

---

## SLURM execution

A complete example SLURM submission script is provided:

```
run_batch2.sh
```

Submit with:

```bash
sbatch run_batch2.sh
```

---

# Output directory

After completion, the run directory contains:

```
alignment/
```

Genome alignment files.

```
bam/
```

Final BAM files.

```
fastcat/
```

FASTCAT reports and merged FASTQ files.

```
jaffal/
```

Fusion detection results.

Each sample has its own directory containing:

```
jaffa_results.csv
jaffa_results.fasta
```

The pipeline also automatically generates:

```
merged_jaffal_results.csv
```

which combines all sample-level fusion calls into a single table.

```
transcripts/
```

Transcript assemblies.

```
quantification/
```

Expression quantification results.

```
differential_expression/
```

Differential expression analysis results.

```
logs/
```

Nextflow log files.

```
nextflow_work/
```

Intermediate Nextflow working files.

---

# Common problems

* Missing sequencing summary
* Incorrect barcode names in the sample sheet
* Reference genome and annotation mismatch
* Missing JAFFAL reference directory
* Interrupted runs (resume using `-resume`)

---

# Contact

Please open a GitHub Issue for bug reports or feature requests.
