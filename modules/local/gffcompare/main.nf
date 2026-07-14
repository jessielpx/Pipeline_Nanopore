process GFFCOMPARE {

    tag "merged_transcriptome"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-transcriptomes-shaaaf20a5a0e76f9e18bad21af639a6b69e4a31a2f.sif'

    cpus 1
    memory '4 GB'
    time '4h'

    publishDir "${params.outdir}/gffcompare", mode: 'copy'

    input:
    path query_gtf
    path reference_gtf

    output:
    path "gffcompare/str_merged.annotated.gtf", emit: annotated_gtf
    path "gffcompare/str_merged.stats", emit: stats
    path "gffcompare/str_merged.tracking", emit: tracking
    path "gffcompare/str_merged.loci", emit: loci

    script:
    """
    set -euo pipefail

    mkdir -p gffcompare

    gffcompare \
        -o gffcompare/str_merged \
        -r ${reference_gtf} \
        -R \
        ${query_gtf}
    """
}
