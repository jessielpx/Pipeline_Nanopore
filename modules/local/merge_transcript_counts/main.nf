process MERGE_TRANSCRIPT_COUNTS {

    tag "all_samples"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-common-sha72f3517dd994984e0e2da0b97cb3f23f8540be4b.sif'

    cpus 1
    memory '4 GB'
    time '2h'

    publishDir "${params.outdir}/quantification/merged", mode: 'copy'

    input:
    path transcript_count_files
    path merge_script

    output:
    path "unfiltered_transcript_counts.tsv", emit: counts
    path "unfiltered_tpm_transcript_counts.tsv", emit: tpm

    script:
    """
    python ${merge_script} \
        --inputs ${transcript_count_files} \
        --counts-output unfiltered_transcript_counts.tsv \
        --tpm-output unfiltered_tpm_transcript_counts.tsv
    """
}
