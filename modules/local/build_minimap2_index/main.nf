process BUILD_MINIMAP2_INDEX {

    tag "reference"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-transcriptomes-shaaaf20a5a0e76f9e18bad21af639a6b69e4a31a2f.sif'

    cpus 4
    memory '32 GB'
    time '4h'

    publishDir "${params.outdir}/reference", mode: 'copy'

    input:
    path reference_fasta

    output:
    path "reference.mmi"

    script:
    """
    minimap2 \
        -d reference.mmi \
        ${reference_fasta}
    """
}
