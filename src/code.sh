#!/bin/bash

main() {
    set -e -x -v -o pipefail 
    export PATH=$PATH:/home/dnanexus/.local/bin  # pip installs some packages here, add to path

    mark-section "Download the input files"
    mkdir bam
    mkdir references
    dx-download-all-inputs --parallel

    # BAMs and BAIs put in same directory as their index
    find ~/in/bam_file -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/bam
    find ~/in/bam_index -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/bam

    #TODO sense-check the BAM and BAI names

    # Put reference material in one dir
    bed_name=$(find ~/in/sites -type f -name "*" -print0)
    find ~/in/sites -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/references

    mark-section "Installing igv-reports and packages from wheels"
    sudo -H python3 -m pip install --no-index --no-deps packages/*

    mark-section "Generate an IGV report for each sample"
    while IFS= read -r -d '' bam_file_name
    do
        sample_id=$(echo "$bam_file_name" | cut -d "." -f 1 )
        create_report  ~/references/"$bed_name" \
        --genome "$reference_genome" \
        --flanking 1000 \
        --tracks ~/bam/"$bam_file_name" \
        --output ~/out/igv_reports/"$sample_id"_igv_report.html
    done < $(find ~/in/bam_files -type f -name "*" -print0)

    mark-section "Output the HTML file"
    output_xlsx=$(dx upload /home/dnanexus/out/igv_reports/* --brief)
    dx-jobutil-add-output xlsx_report "$output_xlsx" --class=file
	
    mark-success
}
