#!/bin/csh -f

#### Written by Julia Cluceru
# Updated 02.15.18

## the purpose of this script is to make a robust transformation of all 
## .tab files in a folder (namely svk_roi_analysis) and 
## convert each .tab file to a csv using the function tab_to_csv

## To be honest I'm not sure what this thing does, but I'm keeping it here
if ($#argv != 1) then
    echo " "
    echo "Usage: convert tab to csv "
    echo "Please input list to convert."
    exit(1)
endif

## usage would be batch_tab_to_csv.dev.x [here put rownum (n) of REC_HGG_tab_to_csv_${n}]
## e.g. batch_tab_to_csv.dev.x 35 if want to call REC_HGG_tab_to_csv_35

set n = $1
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

while ($i <= $m)
	set bnum = `echo ${b} | cut -d" " -f$i`
	set tnum = `echo ${t} | cut -d" " -f$i`
	echo $i $bnum $tnum

	cd /data/RECglioma/*${bnum}/*${tnum}

	if (-d svk_roi_analysis) then
		echo "folder svk_roi_analysis exists, changing into directory"
		cd svk_roi_analysis
		echo "changed into svk_roi_analysis directory"

		## here we are going to count the number of .tab files 
		@ tabnum = `ls *.tab | wc -l`
		echo $tabnum
		## here we are initializing a new variable 
		@ k = 1
		## here I am creating a file called tablist.txt that indexes the .tab files 
		ls *.tab > tablist.txt

		while ($k <= $tabnum)
			set tablist_k = `awk 'NR=='$k'' tablist.txt | cut -d"." -f1`
			tab_to_csv -r $tablist_k
			echo "tab_to_csv $k completed"
			mv summary.csv ${tablist_k}.csv
			echo "summary file $k renamed"
			@ k = $k + 1
		end

	else
		echo "no svk_roi_analysis folder, will skip"
	endif
	@ i = $i + 1
end
