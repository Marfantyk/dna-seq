version development

import "https://raw.githubusercontent.com/antonkulaga/bioworkflows/main/common/files.wdl" as files

workflow Lumpy {
    input {
        File ref
        File ref_fai
        File bam
        File bai
        String name
        String destination

    }

    call Smoove{
        input:
            bam = bam, bai = bai, reference = ref, reference_index = ref_fai, sample = name
    }

    call files.copy as copy {
        input: destination = destination + "/lumpy", files = [Smoove.out]
    }

    output {
        File out = copy.out[0]
    }
}


task Smoove {
    input {
        File bam
        File bai
        File reference
        File reference_index
        String sample
        String outputDir = "./smoove"
        Int max_memory = 16
        Int max_cores = 8
    }

    command {
        set -e
        mkdir -p ~{outputDir}
        smoove call \
        --outdir ~{outputDir} \
        --name ~{sample} \
        --fasta ~{reference} \
        ~{bam}
    }

    output {
        File out = outputDir
        File smooveVcf = outputDir + "/" + sample + "-smoove.vcf.gz"
    }

    runtime {
        docker: "brentp/smoove@sha256:d0d6977dcd636e8ed048ae21199674f625108be26d0d0acd39db4446a0bbdced"
        docker_memory: "~{max_memory}G"
        docker_cpu: "~{max_cores}"
    }
}