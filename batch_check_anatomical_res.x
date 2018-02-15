#!/bin/csh -f


if ($#argv > 1 ) then
    echo " "
    echo "Please input the number of scans you want to check."
    exit(1)
endif
set n = $1
set broot = /data/bioe2/REC_HGG
set b = `more /home/sf673542/analysis/purest_data/REC_HGG_fix_anatomical_res_${n}.csv | cut -d"," -f1`
set t = `more /home/sf673542/analysis/purest_data/REC_HGG_fix_anatomical_res_${n}.csv | cut -d"," -f2`
set sf = `more /home/sf673542/analysis/purest_data/REC_HGG_fix_anatomical_res_${n}.csv | cut -d"," -f3`

set flag = 0
@ i = 1
#echo "$i $b $t $sf "
echo "i bnum tnum sfnum fsea fla t1ca t1va t1diffa rois t2all cel nec nel"
while ($i <= $n)
#echo $i

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
set sfnum = `echo ${sf} | cut -d" " -f$i`





################


cd /data/bioe2/*/${bnum}/${tnum}/images

if (-e ${tnum}_t1va.int2) then
  set t1va = 1
else
  set t1va = 0
endif 

if (-e ${tnum}_t1ca.int2) then
  set t1ca = 1
else
  set t1ca = 0
endif 

if (-e ${tnum}_fla.int2) then
  set fla = 1
else
  set fla = 0
endif 

if (-e ${tnum}_fsea.int2) then
  set fsea = 1
else
  set fsea = 0
endif 

if (-e ${tnum}_t1va.int2) then
  set t1diffa = 1
else
  set t1diffa = 0
endif 

cd /data/bioe2/*/${bnum}/${tnum}

if (-d rois) then
set rois = 1
cd /data/bioe2/*/${bnum}/${tnum}/rois

if (-e ${tnum}_t2all.byt) then
  set t2all = 1
else
  set t2all = 0
endif 

if (-e ${tnum}_cel.byt) then
  set cel = 1
else
  set cel = 0
endif 

if (-e ${tnum}_nec.byt) then
  set nec = 1
else
  set nec = 0
endif 

if (-e ${tnum}_nel.byt) then
  set nel = 1
else
  set nel = 0
endif 

else
set rois = 0
set t2all = 0
set cel = 0
set nec = 0
set nel = 0
endif


echo $i $bnum $tnum $sfnum $fsea $fla $t1ca $t1va $t1diffa $rois $t2all $cel $nec $nel


@ i = $i + 1


end