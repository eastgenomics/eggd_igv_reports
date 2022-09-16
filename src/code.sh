#!/bin/bash

main() {
    set -exo pipeline 
    export PATH=$PATH:/home/dnanexus/.local/bin  # pip installs some packages here, add to path

    mark-section "Download the input files"
    mkdir bam
    mkdir references
    dx-download-all-inputs --parallel
    # BAMs need to be in same directory as their index
    find ~/in/bam_file -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/bam
    find ~/in/bam_index -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/bam
    # Put reference material in one dir
    find ~/in/sites -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/references
    find ~/in/reference_genome -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/references
    find ~/in/reference_index -type f -name "*" -print0 | xargs -0 -I {} mv {} ~/references
    
    mark-section "Installing packages"
    sudo -H python3 -m pip install --no-index --no-deps packages/*

    # run IGV reports

    # move results and output
    report=$(dx upload report --brief)

    dx-jobutil-add-output report "$report" --class=file
}
