include { JAFFAL } from '../modules/local/jaffal/main'
include { MERGE_JAFFAL_RESULTS } from '../modules/local/merge_jaffal/main'

workflow FUSION_ANALYSIS {

    take:
    fastcat_results_ch
    samplesheet_ch

    main:
    JAFFAL(fastcat_results_ch)

    jaffal_csv_ch = JAFFAL.out.results
        .map { meta, csv, fasta -> csv }
        .collect()

    MERGE_JAFFAL_RESULTS(
        jaffal_csv_ch,
        samplesheet_ch
    )

    emit:
    results = JAFFAL.out.results
    merged = MERGE_JAFFAL_RESULTS.out.merged
}
