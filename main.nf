#!/usr/bin/env nextflow
nextflow.enable.dsl = 2


params.outdir = 'exomiser_results'
params.vcf = null
params.hpo=null
params.ped=null
params.exoYml=null
params.genome="hg38" //default assembly is hg38, unless --genome is set!
params.rundir= "${launchDir.baseName}" 
//File parameters:

outdir_full_path= "${launchDir}/${params.outdir}/"

params.help=null
//exo_yml_hg38="/data/shared/programmer/exomiser-cli-12.1.0/examples/mj.wgs.hg38.analysisfile.yml"
exo_yml="/data/shared/programmer/exomiser-cli-12.1.0/examples/mj.wgs.analysisfile.yml"

switch (params.genome) {
    case 'hg19':
        exo_yml_genome="hg19"
    break;
    case 'hg38':
        exo_yml_genome="hg38"
    break;
}

def helpMessage() {
    log.info"""

    Description:
    Prioritize variants and genes in vcf file (SNPs, INDELs and/or CNVs), relative to patients phenotype.
    Requires a vcf file with variants, a ped-file describing the relation and status of analyzed samples, and a file containing relevant HPO terms.
    

    Main options:
      --help            Print this help message
 
      --genome          hg19 or hg38
                            Default: hg38
 
      --vcf             Path to vcf file (required)

      --ped             Path to .ped pedigree file (required)

      --hpo             Path to file containing HPO terms (required)

      --outdir          Manually set output directory
                            Default: "exomiser_results"

    """.stripIndent()
}
if (params.help) exit 0, helpMessage()



// Channels:

Channel
    .fromPath(params.vcf)
    .map{ tuple(it.baseName, it)}
    .set {vcf_input}
Channel
    .fromPath(params.hpo)
    .map{tuple(it, it.baseName, it.simpleName)}
    .set {hpo_input}

Channel
    .fromPath(params.ped)
    .map{tuple(it, it.baseName, it.simpleName)}
    .set {ped_input}


process exo13 {
    //errorStrategy 'ignore'
    publishDir "${params.outdir}/exo13/", mode: 'copy'
    echo true

    input:
    tuple file(hpo), val(hpo2), val(hpo3)// from hpo_input3
    tuple val(vcf_basename), path(vcf)// from vcf_input3
    tuple file(ped), val(ped2), val(ped3)// from ped_input3

    output:

    path("*.{html,tsv,vcf}")

    shell:
    '''
    index=`tail -n 1 !{ped}|awk '{print $2}'`
    father=`tail -n 1 !{ped}|awk '{print $3}'`
    mother=`tail -n 1 !{ped}|awk '{print $4}'`
    hpolist=`sed -r 's/^HP:[[:digit:]]*/"&"/g' !{hpo} | awk '{print $1}'| paste -s -d, -`
    sed "s/VCF_PH/!{vcf}/g; \
    s/GENOME_PH/!{exo_yml_genome}/g; \
    s/PROBAND_PH/${index}/g; \
     s/PED_PH/!{ped}/g; \
     s/HPO_PH/$hpolist/g; \
     s/OUTPUT_PH/!{vcf_basename}.!{exo_yml_genome}.exo13/g" \
     !{exo_yml} > !{params.rundir}.analysisready.yml
    java -jar /data/shared/programmer/exomiser-cli-13.0.0/exomiser-cli-13.0.0.jar --analysis !{params.rundir}.analysisready.yml \
     --spring.config.location=/data/shared/programmer/exomiser-cli-13.0.0/
    '''
}

process exo13_1_2309 {
    //errorStrategy 'ignore'
    publishDir "${params.outdir}/exo13_1/", mode: 'copy'
    echo true

    input:
    tuple file(hpo), val(hpo2), val(hpo3)// from hpo_input2
    tuple val(vcf_basename), path(vcf)// from vcf_input2
    tuple file(ped), val(ped2), val(ped3)// from ped_input2


    output:
    //path("${params.rundir}.analysisready.yml")
    path("*.{html,tsv,vcf}")
    shell:
    '''
    index=`tail -n 1 !{ped}|awk '{print $2}'`
    father=`tail -n 1 !{ped}|awk '{print $3}'`
    mother=`tail -n 1 !{ped}|awk '{print $4}'`
    hpolist=`sed -r 's/^HP:[[:digit:]]*/"&"/g' !{hpo} | awk '{print $1}'| paste -s -d, -`
    sed "s/VCF_PH/!{vcf}/g; \
    s/GENOME_PH/!{exo_yml_genome}/g; \
    s/PROBAND_PH/${index}/g; \
     s/PED_PH/!{ped}/g; \
     s/HPO_PH/$hpolist/g; \
     s/OUTPUT_PH/!{vcf_basename}.!{exo_yml_genome}.exo13_1/g" \
     !{exo_yml} > !{params.rundir}.analysisready.yml
    java -jar /data/shared/programmer/exomiser-cli-13.1.0/exomiser-cli-13.1.0.jar --analysis !{params.rundir}.analysisready.yml \
     --spring.config.location=/data/shared/programmer/exomiser-cli-13.1.0/
    '''
}

process exo14_2402 {
    //errorStrategy 'ignore'
    publishDir "${params.outdir}/exo13_1/", mode: 'copy'
    echo true

    input:
    tuple file(hpo), val(hpo2), val(hpo3)// from hpo_input2
    tuple val(vcf_basename), path(vcf)// from vcf_input2
    tuple file(ped), val(ped2), val(ped3)// from ped_input2


    output:
    //path("${params.rundir}.analysisready.yml")
    path("*.{html,tsv,vcf}")
    shell:
    '''
    index=`tail -n 1 !{ped}|awk '{print $2}'`
    father=`tail -n 1 !{ped}|awk '{print $3}'`
    mother=`tail -n 1 !{ped}|awk '{print $4}'`
    hpolist=`sed -r 's/^HP:[[:digit:]]*/"&"/g' !{hpo} | awk '{print $1}'| paste -s -d, -`
    sed "s/VCF_PH/!{vcf}/g; \
    s/GENOME_PH/!{exo_yml_genome}/g; \
    s/PROBAND_PH/${index}/g; \
     s/PED_PH/!{ped}/g; \
     s/HPO_PH/$hpolist/g; \
     s/OUTPUT_PH/!{vcf_basename}.!{exo_yml_genome}.exo13_1/g" \
     !{exo_yml} > !{params.rundir}.analysisready.yml
    java -jar /data/shared/programmer/exomiser-cli-14.0.0/exomiser-cli-14.0.0.jar --analysis !{params.rundir}.analysisready.yml \
     --spring.config.location=/data/shared/programmer/exomiser-cli-13.1.0/
    '''
}




workflow {
   // exo13(hpo_input,vcf_input, ped_input)
    exo13_1_2309(hpo_input,vcf_input, ped_input)
    exo14_2402(hpo_input,vcf_input, ped_input)
}
