process PARSE_GFFCOMPARE {

    tag "merged_transcriptome"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-common-sha72f3517dd994984e0e2da0b97cb3f23f8540be4b.sif'

    cpus 1
    memory '4 GB'
    time '2h'

    publishDir "${params.outdir}/gffcompare", mode: 'copy'

    input:
    path annotated_gtf
    path parse_script

    output:
    path "transcript_annotation.tsv", emit: annotation_table

    script:
    """
    python ${parse_script} \
        --gtf ${annotated_gtf} \
        --output transcript_annotation.tsv
    """
}
