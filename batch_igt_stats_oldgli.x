#!/bin/csh -f

#### Written by J.Cluceru on 05.21.18 
#### Purpose of this script is to generate .csv files using igt_stats into svk_roi_analysis folders
#### This is for a single file only. I will then modify this file to be applicable in the batch setting
#### Finally, I will generate R code to agglomerate all of these data into one single data frame that can 
#### be combined with the other call_getAnat outputs, etc, so that we have information on the percentage
#### of biopsy ROIs in each of the CEL, NEL, and NEC ROIs 

#### NOTE: this is only for within the /data/RECglioma/bnum/tnum, b/c otherwise the following two commands 
#### won't work: 

if ($#argv != 1 ) then
    echo "Please enter the path to the .csv file containing the list of"
    echo "bnum/tnum that you'd like to ensure are processed correctly."
    exit(1)
endif

set n = $1
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`
echo $m 
echo 'i bnum tnum status'
while ($i <= $m)
set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

if (-d /data/bioe4/po1_preop_recur/${bnum}/${tnum}/) then
	cd /data/bioe4/po1_preop_recur/${bnum}/${tnum}/
else 
	@ i = $i + 1 
endif 

set sfnum = `ls -d sf*`
@ sfnum_num = `echo "${#sfnum}"`
if (${sfnum} != "") then
	cd $sfnum
	if (-e ${tnum}_igtstats.csv) then 
		set status = 'already completed'
	else
		igt_stats > ${tnum}_igtstats.csv
		cd ..
		set status = 'igt_stats_completed'
			if (-d roi_analysis) then
				cp ${sfnum}/${tnum}_igtstats.csv roi_analysis
				set status = 'completed_and_copied_into_roi_analysis'
			endif
	endif
else
	set status = 'no_sfnum'
endif
echo $i $bnum $tnum $status
@ i = $i + 1
end