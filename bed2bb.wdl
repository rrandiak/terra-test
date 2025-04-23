version 1.0

workflow bed2bb {
    input {
        File bed_file
        String genome_assembly
    }

    call get_chrom_sizes {
        input:
        genome_assembly = genome_assembly
    }

    call convert_bed_to_bigbed {
        input:
            bed_file = bed_file,
            chrom_sizes = get_chrom_sizes.chrom_sizes
    }

    output {
        File bigbed_file = convert_bed_to_bigbed.bigbed_file
    }
}

task get_chrom_sizes {
    input {
        String genome_assembly
    }

    command <<<
        apt-get update
        apt-get install -y curl
        curl -o chrom.sizes "http://hgdownload.soe.ucsc.edu/goldenPath/${genome_assembly}/bigZips/${genome_assembly}.chrom.sizes"
    >>>

    output {
        File chrom_sizes = "chrom.sizes"
    }

    runtime {
        docker: "debian:bookworm-slim"
        preemptible: 2
    }
}

task convert_bed_to_bigbed {
    input {
        File bed_file
        File chrom_sizes
    }

    command {
        bedToBigBed -sort ${bed_file} ${chrom_sizes} output.bb
    }

    output {
        File bigbed_file = "output.bb"
    }

    runtime {
        docker: "quay.io/biocontainers/ucsc-bedtobigbed:473--h52f6b31_1"
        preemptible: 2
    }
}
