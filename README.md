KG Vejle, Exomiser analysis

# Usage
The script takes 3 mandatory inputs: 

1. PED file describing the relationship between the samples in the VCF file
2. VCF file containing the samples described in the PED file
3. Textfile with relevant HPO terms

See infonet for information regarding how to prepare the HPO and PED files. 

## Common use case
    nextflow run KGVejle/exomiser -r main --vcf /path/to/vcf/ --hpo /path/to/hpo/ --ped /path/to/ped

By default, all output (txt, vcf, json and html) is stored in the output directory "exomiser_results". in the folder the script is executed.

