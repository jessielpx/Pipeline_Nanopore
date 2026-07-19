process MERGE_JAFFAL_RESULTS {

    publishDir "${params.outdir}/jaffal", mode: 'copy'

    input:
    path(jaffal_csvs, stageAs: 'jaffal??/*')
    path(samplesheet)

    output:
    path("merged_jaffal_results.csv"), emit: merged

    script:
    """
    python3 ${projectDir}/scripts/merge_jaffal_results.py \
        --input ${jaffal_csvs.join(' ')} \
        --samplesheet ${samplesheet} \
        --output merged_jaffal_results.csv
    """
}
