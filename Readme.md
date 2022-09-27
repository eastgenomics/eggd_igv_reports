<!-- dx-header -->
# IGV Reports (DNAnexus Platform App)

Uses the IGV Reports package to create IGV-style image reports of user-requested genomic regions.

This is the source code for an app that runs on the DNAnexus Platform.
For more information about how to run or modify it, see
https://documentation.dnanexus.com/.

## What does this app do?

The app generates IGV-style visual reports for a list of BAM files. The reports are HTML files which can be easily stored and opened. The app wraps the 'IGV Reports' tool: https://github.com/igvteam/igv-reports 

## What data are required for this app to run?

The app requires as arguments:
* A list of BAM files, one per sample
* A list of corresponding BAM index files (.BAI), one per sample
* The name of a BAM file of genomic sites to be included in the output report. N.B. this must be for a genome release which matches the IGV genome option.
* The name of the desktop IGV genome to be shown in the report. The IGV 'default' genome data for the selected option (including FASTA file and annotation track) will be loaded and used. Possible options: hg19, hg38.


## What data does the app output?

The app outputs a single HTML report file per input BAM file.
