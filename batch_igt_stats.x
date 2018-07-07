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
#echo "$i $b $t $sf "
@ m = `echo $n | cut -d"." -f2`
echo $m 
while ($i <= $m)

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
echo $i $bnum $tnum
cd /data/RECglioma/${bnum}/*${tnum}/
set sfnum = `ls -d sf*`
if(${sfnum} != "") then
	cd $sfnum
	igt_stats > ${tnum}_igtstats.dev.csv
	cd ..
		if (-d svk_roi_analysis) then
			cp ${sfnum}/${tnum}_igtstats.dev.csv svk_roi_analysis
			echo "copied into svk_roi_analysis directory"
		endif
endif
@ i = $i + 1

end