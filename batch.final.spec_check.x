#!/bin/csh -f

## This script is to check the entire workflow of spectroscopy and what has been completed 
## Please use input using a path to a .csv file which is formatted to bnum/tnum/DUMMY;
## there should be no header labeling 
## the bnum/tnum. It must be labeled with the number (#) of bnum/tnum as a .#.csv 
## Final version completed on 02.27.18 

if ($#argv < 1 ) then
    echo ""
    echo "This script is for you to understand what has been completed for diffusion scans."
    echo "The output will be a list of what has been completed."
    echo ""
    echo "An example of it's usage would be /pathtoscript/batch.final.diffu_check.x /pathtobnum_tnumlist/bnumtnumlist.#.csv"
    echo ""
    echo "Please input the path to the list of bnum/tnum you'd like to check. Make sure naming conventions are correct."
    echo ""
    echo "b1000_run, b2000_run check whether these were run in dcm_exam_info"
    echo "b1000_adc, b1000_adca, b2000_adc, b2000_adca, b1000_faa, b2000_faa check for existence of these images in respective folders."
    echo "b1000_adca_res and b2000_adca_res check to see if the resolution is properly 1x1x1.5"
    echo "svk_roi_analysis: checks for existence of svk_roi_analysis folder"
    echo "svk_adca1000_tab: checks for existence of _1000_adcfa.tab file in /svk_roi_analysis/"
    echo "the same is true for the tab and csv variables"
    echo "biopsyval: 1 means there exists values for diffusion biopsies that are greater than zero for the FLAIR image;"
    echo "biopsyval = 0 indicates lack of value for the biopsy in the FLAIR image; NA indicates no .tab file to look in."

    exit(1)


endif