#!/bin/bash

main() {
    set -exo pipeline 
    export PATH=$PATH:/home/dnanexus/.local/bin  # pip installs some packages here, add to path

    mark-section "Download the input files"
    mkdir bam
    mkdir references
    dx-download-all-inputs --parallel

    # BAMs put in same directory as their index
    bam_file_name=$(find ~/in/bam_file -type f -name "*" -print0) 
    sample_id=$(echo "$bam_file_name" | cut -d "." -f 1 )
    find ~/in/bam_file -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/bam
    find ~/in/bam_index -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/bam

    # Put reference material in one dir
    bed_name=$(find ~/in/sites -type f -name "*" -print0)
    find ~/in/sites -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/references

    mark-section "Installing packages"
    sudo -H python3 -m pip install --no-index --no-deps packages/*

    mark-section "Run IGV reports"
    create_report  ~/references/"$bed_name" \
    --genome "$reference_genome" \
    --flanking 1000 \
    --tracks ~/bam/"$bam_file_name" \
    --output ~/out/igv_reports/"$sample_id".html

    mark-section "Output the HTML file"
    output_xlsx=$(dx upload /home/dnanexus/out/igv_reports/* --brief)
    dx-jobutil-add-output xlsx_report "$output_xlsx" --class=file
	
    mark-success
}
