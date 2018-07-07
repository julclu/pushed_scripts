#!/bin/csh -f

#### Written by J.Cluceru on 05.21.18 
#### Purpose of this script is to generate .csv files using igt_stats into svk_roi_analysis folders
#### This is for a single file only. I will then modify this file to be applicable in the batch setting
#### Finally, I will generate R code to agglomerate all of these data into one single data frame that can 
#### be combined with the other call_getAnat outputs, etc, so that we have information on the percentage
#### of biopsy ROIs in each of the CEL, NEL, and NEC ROIs 

#### NOTE: this is only for within the /data/RECglioma/bnum/tnum, b/c otherwise the following two commands 
#### won't work: 

## run from within the tfolder 
set bnum = `pwd | cut -d"/" -f4`
set tnum = `pwd | cut -d"/" -f5`
## figure out which is sfnum 
set sfnum = `ls -d sf*`
## go into the sfnum directory
cd $sfnum
## run igt_stats and output into a named file 
igt_stats.dev > ${tnum}_${sfnum}_igtstats.dev.csv

cd ..
if (-d svk_roi_analysis) then
	cp ${sfnum}/${tnum}_${sfnum}_igtstats.dev.csv svk_roi_analysis

endif