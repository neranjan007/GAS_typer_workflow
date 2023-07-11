version 1.0

task cutadapt_task{
    meta {
        description: "cutadapt trimming of fastq files"
    }

    input {
        # task inputs
        File read1
        File read2
        String docker = "neranjan007/cutadapt:4.4"
        Int cpu = 1
        Int memory = 10
    }

    command <<<
        sample_name=$(echo "~{read1}" | awk -F"/" '{print $(NF)}' | sed 's/_S[0-9]\+_L[0-9]\+_R[0-9]\+.*//g')
        out_nameMLST=MLST_"$sample_name"

        fastq1_trimd=cutadapt_"$sample_name"_S1_L001_R1_001.fastq
        fastq2_trimd=cutadapt_"$sample_name"_S1_L001_R2_001.fastq

        cutadapt \
            -b AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
            -q 20 \
            --minimum-length 50 \
            --paired-output temp2.fastq -o temp1.fastq \
            ~{read1} ~{read2}
        
        cutadapt \
            -b AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
            -q 20 \
            --minimum-length 50 \
            --paired-output $fastq1_trimd -o $fastq2_trimd \
            temp2.fastq temp1.fastq
    >>>

    output {
        
    }

    runtime {
        docker: "~{docker}"
        memory: "~{memory} GB"
        cpu: cpu
        disks: "local-disk 50 SSD"
        preemptible: 0
    }
}