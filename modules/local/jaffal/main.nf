process JAFFAL {

    tag "${meta.sample}"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/jaffa-2.5.sif'
    containerOptions "--cleanenv --bind ${params.jaffal_ref_dir}:/ref"

    cpus 16
    memory '64 GB'
    time '24h'

    publishDir "${params.outdir}/jaffal/${meta.sample}", mode: 'copy'

    input:
    tuple val(meta),
          path(fastq),
          path(fastcat_stats)

    output:
    tuple val(meta),
          path("jaffa_results.csv"),
          path("jaffa_results.fasta"),
          emit: results

    script:
    """
    set -euo pipefail

    /JAFFA/tools/bin/bpipe run \
        -p threads=${task.cpus} \
        /JAFFA/JAFFAL.groovy \
        ${fastq}
    """
}
