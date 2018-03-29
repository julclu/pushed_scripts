#!/bin/csh -f

## run from within tfolder 
set tnum = `pwd | cut -d"/" -f5` 

set Enum = `ls -d E*`
echo 'Enum set'
set Snum_tmp = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`
echo 'Snum_tmp set'
set Snum = $Snum_tmp[1]
echo 'Snum set'

set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
@ bionum = `echo "${#vialID}"`

echo 'beginning processing - single cyc'
proc_single_svk.x ${Enum}/${Snum}_raw/${tnum} $tnum 8 single brain_all fb3t hsvd cal 
echo 'proc_single_svk.x completed' 
met_vox_stats.x single ${tnum}_single_fbhsvdfcomb empcsa $bionum biopsy $vialID
echo 'met_vox_stats.x completed'
met_prep128_svk.x $tnum ${tnum}_single_fbhsvdfcomb empcsa $bionum biopsy $vialID
echo 'met_prep128_svk.x completed'
met_stats_svk.x $tnum ${tnum}_single_fbhsvdfcomb empcsa $bionum biopsy $vialID
echo 'met_stats_svk.x completed'

