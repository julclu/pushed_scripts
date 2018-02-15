#!/bin/csh -f

## run from within tfolder 
set tnum = $1 
set seo = $2 

cd /data/bioe2/REC_HGG/*/${tnum}
set Enum = `ls -d E*`
echo 'Enum set'
set Snum_tmp = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`
echo 'Snum_tmp set'
set Snum = $Snum_tmp[1]
echo 'Snum set'

set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
@ bionum = `echo "${#vialID}"`

echo 'beginning processing - lac even cyc'
proc_lac_svk.x ${Enum}/${Snum}_raw/${tnum} $tnum 8 even brain_all fb3t hsvd cal 
echo 'proc_single_svk.x completed' 
met_vox_stats.x even ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vialID
echo 'met_vox_stats.x completed'
met_prep128_svk.x $tnum ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vialID
echo 'met_prep128_svk.x completed'
met_stats_svk.x $tnum ${tnum}_lac_fbhsvdfcomb empcsa $bionum biopsy $vialID
echo 'met_stats_svk.x completed'






