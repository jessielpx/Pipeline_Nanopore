nextflow.enable.dsl = 2

include { PYCOQC } from './modules/local/pycoqc/main'
include { FASTCAT } from './modules/local/fastcat/main'
include { BUILD_MINIMAP2_INDEX } from './modules/local/build_minimap2_index/main'

workflow {

    if (!params.summary) {
        error "Please provide --summary /path/to/sequencing_summary.txt"
    }

    if (!params.fastq_dir) {
        error "Please provide --fastq_dir /path/to/barcode_directories"
    }

    if (!params.ref_genome) {
        error "Please provide --ref_genome /path/to/reference.fa"
    }

    summary_ch = Channel.of(
        tuple(
            [id: params.run_id],
            file(params.summary, checkIfExists: true)
        )
    )

    PYCOQC(summary_ch)

    samples_ch = Channel
        .fromPath(
            "${projectDir}/assets/samples.csv",
            checkIfExists: true
        )
        .splitCsv(header: true)
        .map { row ->

            def meta = [
                barcode  : row.barcode,
                sample   : row.sample,
                condition: row.condition
            ]

            def barcode_dir = file(
                "${params.fastq_dir}/${row.barcode}",
                checkIfExists: true
            )

            tuple(meta, barcode_dir)
        }

    FASTCAT(samples_ch)

    reference_ch = Channel.of(
        file(params.ref_genome, checkIfExists: true)
    )

    BUILD_MINIMAP2_INDEX(reference_ch)
}
