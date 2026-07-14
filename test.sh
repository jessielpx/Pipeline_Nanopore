#!/bin/bash
#SBATCH --account=def-lefranco
#SBATCH --job-name=NanoTest
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --time=24:00:00

module purge
module load StdEnv/2023
module load java/21.0.1
module load nextflow/25.10.2
module load apptainer/1.4.5

export NXF_DISABLE_CHECK_LATEST=true
export NXF_ANSI_LOG=false
export NXF_DOCKER_ENABLED=false

export NXF_SINGULARITY_CACHEDIR=/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR
export NXF_APPTAINER_OPTS="-B /lustre09:/lustre09,/project:/project,/scratch:/scratch"

export APPTAINER_TMPDIR=$SCRATCH/apptainer_tmp
mkdir -p "$APPTAINER_TMPDIR"

cd /home/peixiliu/links/projects/rrg-lefranco/peixiliu/Pipeline_Nanopore

nextflow run . \
    -profile rorqual \
    --summary /lustre09/project/6070433/shared/Nanopore_Data/Sequencing_Summaries/sequencing_summary_run1.txt \
    --fastq_dir /lustre09/project/6070433/shared/Nanopore_Data/batch1-8 \
    --ref_genome /lustre09/project/6070433/peixiliu/reference/Homo_sapiens.GRCh38.fa \
    --ref_annotation /lustre09/project/6070433/peixiliu/reference/genes.filtered_to_fasta.gtf \
    --run_id Batch1 \
    --outdir results \
    --de_analysis true \
    -resume
