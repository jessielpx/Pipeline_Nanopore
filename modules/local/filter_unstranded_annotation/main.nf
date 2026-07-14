process FILTER_UNSTRANDED_ANNOTATION {

    tag "annotation"

    container '/project/def-lefranco/peixiliu/NXF_SINGULARITY_CACHEDIR/ontresearch-wf-transcriptomes-shaaaf20a5a0e76f9e18bad21af639a6b69e4a31a2f.sif'

    cpus 1
    memory '4 GB'
    time '2h'

    publishDir "${params.outdir}/reference", mode: 'copy'

    input:
    path merged_gtf

    output:
    path "merged_transcriptome.stranded.gtf", emit: stranded_gtf
    path "unstranded_transcripts.gtf", emit: excluded_gtf

    script:
    """
    awk '
        BEGIN {
            OFS = "\\t"
        }

        /^#/ {
            print > "merged_transcriptome.stranded.gtf"
            next
        }

        \$7 == "+" || \$7 == "-" {
            print > "merged_transcriptome.stranded.gtf"
            next
        }

        {
            print > "unstranded_transcripts.gtf"
        }
    ' ${merged_gtf}

    touch unstranded_transcripts.gtf

    test -s merged_transcriptome.stranded.gtf
    """
}
