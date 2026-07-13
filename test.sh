nextflow run . \
    -profile rorqual \
    --summary /lustre09/project/6070433/shared/Nanopore_Data/Sequencing_Summaries/sequencing_summary_run1.txt \
    --fastq_dir /lustre09/project/6070433/shared/Nanopore_Data/batch1-8 \
    --ref_genome /lustre09/project/6070433/peixiliu/reference/Homo_sapiens.GRCh38.fa \
    --run_id Batch1 \
    --outdir results \
    -resume
