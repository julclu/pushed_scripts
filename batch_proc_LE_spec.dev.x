#!/bin/csh -f
#set verbose
##batch proc_LE_spec.dev.x

## in this script, I want to only read in the numbers that I need 

if ($#argv > 1 ) then
    echo "Please just enter the path name to the file you're interested in processing"
    exit(1)
endif
set n = $1
set broot = /data/bioe2/REC_HGG
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set s = `more $n | cut -d"," -f3`
set bion = `more $n | cut -d"," -f4`
set vialid1 = `more $n | cut -d"," -f5`
set vialid2 = `more $n | cut -d"," -f6`
set vialid3 = `more $n | cut -d"," -f7`
set vialid4 = `more $n | cut -d"," -f8`
set vialid5 = `more $n | cut -d"," -f9`
set vialid6 = `more $n | cut -d"," -f10`
set vialid7 = `more $n | cut -d"," -f11`
set vialid8 = `more $n | cut -d"," -f12`


echo 'all things set well'

@ i = 1
@ m = `echo $n | cut -d"." -f2`
while ($i <= $m)

echo 'this is the first $i'
## here you need to get the specific line 
	set bnum = `echo ${b} | cut -d" " -f$i`
	set tnum = `echo ${t} | cut -d" " -f$i`
	set seo = `echo ${s} | cut -d" " -f$i`
	@ bionum = `echo ${bion} | cut -d" " -f$i`
	set vi1 = `echo ${vialid1} | cut -d" " -f$i`
	set vi2 = `echo ${vialid2} | cut -d" " -f$i`
	set vi3 = `echo ${vialid3} | cut -d" " -f$i`
	set vi4 = `echo ${vialid4} | cut -d" " -f$i`
	set vi5 = `echo ${vialid5} | cut -d" " -f$i`
	set vi6 = `echo ${vialid6} | cut -d" " -f$i`
	set vi7 = `echo ${vialid7} | cut -d" " -f$i`
	set vi8 = `echo ${vialid8} | cut -d" " -f$i`

	cd /data/bioe2/*/${bnum}/${tnum}
	set Enum = `ls -d E*`
	echo 'Enum set'
	set Snum_tmp = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`
	echo 'Snum_tmp set'
	set Snum = $Snum_tmp[1]
	echo 'Snum set'


	if ($seo == 'single') then
		echo 'beginning processing - single cyc'
		proc_single_svk.x ${Enum}/${Snum}_raw/${tnum} $tnum 8 single brain_all fb3t hsvd cal 
		echo 'proc_single_svk.x completed' 
		met_vox_stats.x single ${tnum}_single_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_vox_stats.x completed'
		met_prep128_svk.x ${tnum}_single_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_prep128_svk.x completed'
		met_stats_svk.x ${tnum}_single_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_stats_svk.x completed'
	else if ($seo == 'even') then
		echo 'beginning processing - even lac'
		proc_lac_svk.x ${Enum}/${Snum}_raw/${tnum} $tnum 8 even brain_all fb3t hsvd cal 
		echo 'proc_single_svk.x completed' 
		met_vox_stats.x lac ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_vox_stats.x completed'
		met_prep128_svk.x $tnum ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_prep128_svk.x completed'
		met_stats_svk.x $tnum ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_stats_svk.x completed'
	else 
		echo 'beginning processing - odd lac '
		proc_lac_svk.x ${Enum}/${Snum}_raw/${tnum} $tnum 8 odd brain_all fb3t hsvd cal 
		echo 'proc_single_svk.x completed' 
		met_vox_stats.x lac ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_vox_stats.x completed'
		met_prep128_svk.x $tnum ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_prep128_svk.x completed'
		met_stats_svk.x $tnum ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vi1 $vi2 $vi3 $vi4 $vi5 $vi6 $vi7 $vi8
		echo 'met_stats_svk.x completed'
			
	endif 

	echo 'ending $i'

	@ i = $i + 1

end
