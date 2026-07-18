process PREPROCESS_ANNOTATION {

    tag "annotation"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-transcriptomes-shaaaf20a5a0e76f9e18bad21af639a6b69e4a31a2f.sif'

    cpus 2
    memory '16 GB'
    time '2h'

    publishDir "${params.outdir}/reference", mode: 'copy'

    input:
    path annotation_gtf
    path reference_fasta

    output:
    path "annotation.cleaned.gtf", emit: cleaned_gtf

    script:
    """
    set -euo pipefail

    grep '^>' "${reference_fasta}" \
        | sed 's/^>//' \
        | cut -d' ' -f1 \
        > reference_contigs.txt

    awk '
    BEGIN {
        while ((getline < "reference_contigs.txt") > 0) {
            keep[\$1] = 1
        }
    }

    /^#/ {
        print
        next
    }

    keep[\$1] {
        print
    }
    ' "${annotation_gtf}" \
      > annotation.filtered.gtf

    gffread \
        annotation.filtered.gtf \
        -g "${reference_fasta}" \
        -T \
        -o annotation.cleaned.gtf
    """
}
