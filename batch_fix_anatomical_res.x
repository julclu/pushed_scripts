#!/bin/csh -f

#### Written by Qiuting Wen
#### Edited by JGC 07/05/2017

if ($#argv > 1) then
    echo " "
    echo "Usage: P01_run_fix_resolution_from_list"
    echo "Read .cvs and copy all patients images in .cvs to droot"
    exit(1)
endif
set n = $1
set broot = /data/bioe2/REC_HGG
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set sf = `more $n | cut -d"," -f3`
@ m = `echo $n | cut -d"." -f2`

set flag = 0
@ i = 1
#echo "$i $b $t $sf "

while ($i <= $m)
set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
set sfnum = `echo ${sf} | cut -d" " -f$i`

echo $i $bnum $tnum $sfnum

cd /data/bioe2/*/${bnum}/${tnum}

/home/sf673542/working/scripts/fix_anatomical_res.x $bnum $tnum $sfnum
@ i = $i + 1

end
