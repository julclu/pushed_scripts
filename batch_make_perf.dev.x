#!/bin/csh -f

#### Written by Julia Cluceru 08/05/2017

if ($#argv > 1 ) then
    echo " "
    echo "Usage: P01_run_fix_resolution_from_list"
    echo "Read .cvs and copy all patients images in .cvs to droot"
    exit(1)
endif

set n = $1
set broot = /data/bioe2/REC_HGG
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

while ($i <= $m)
set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

echo $i $bnum $tnum 

cd /data/bioe2/*/${bnum}/${tnum}

if (-d perf_topupAligned) then 
	echo "perfusion already processed, skipping."
else
	make_perf.dev $tnum -b -f nonlinear --align w
endif 


@ i = $i + 1

end