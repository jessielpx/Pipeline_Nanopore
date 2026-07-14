process DIFFERENTIAL_EXPRESSION {

    tag "all_samples"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-transcriptomes-shaaaf20a5a0e76f9e18bad21af639a6b69e4a31a2f.sif'

    cpus 4
    memory '32 GB'
    time '12h'

    publishDir "${params.outdir}/differential_expression", mode: 'copy'

    input:
    path sample_sheet
    path transcript_counts
    path merged_gtf
    path de_script

    output:
    path "de_analysis/results_dge.tsv", emit: dge
    path "de_analysis/results_dge.pdf", emit: dge_pdf
    path "de_analysis/results_dexseq.tsv", emit: dexseq
    path "de_analysis/results_dtu_gene.tsv", emit: dtu_gene
    path "de_analysis/results_dtu_transcript.tsv", emit: dtu_transcript
    path "de_analysis/results_dtu_stageR.tsv", emit: dtu_stageR
    path "de_analysis/results_dtu.pdf", emit: dtu_pdf
    path "de_analysis/cpm_gene_counts.tsv", emit: cpm
    path "merged/filtered_transcript_counts_with_genes.tsv", emit: filtered_counts
    path "merged/all_gene_counts.tsv", emit: gene_counts

    script:
    """
    Rscript ${de_script} \
        --annotation ${merged_gtf} \
        --min_samps_gene_expr ${params.min_samps_gene_expr} \
        --min_samps_feature_expr ${params.min_samps_feature_expr} \
        --min_gene_expr ${params.min_gene_expr} \
        --min_feature_expr ${params.min_feature_expr} \
        --sample_sheet ${sample_sheet} \
        --all_counts ${transcript_counts} \
        --de_out_dir de_analysis \
        --merged_out_dir merged
    """
}
