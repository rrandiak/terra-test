version 1.0

workflow count_gaps {
    input {
        File assembly_fasta
    }

    call count_ns {
        input:
            assembly_fasta = assembly_fasta
    }

    output {
        Int total_gaps = count_ns.total_ns
    }
}

task count_ns {
    input {
        File assembly_fasta
    }

    command {
        zgrep -v "^>" ${assembly_fasta} | tr -d -c 'Nn' | wc -c > gaps.txt
    }

    output {
        Int total_ns = read_int("gaps.txt")
    }

    runtime {
		docker: "debian:bullseye"
        preemptible: 3
    }
}
