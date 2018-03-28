#!/bin/csh -f

set bnum = `pwd | cut -d"/" -f4`
set tnum = `pwd | cut -d"/" -f5`
set cwd = `pwd`

set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
@ num_vials = `echo "${#vialID}"`

@ i = 1
while ($i <= ${num_vials})
    perf_biopsy_new.x $tnum $vialID[$i]
    @ i = $i + 1
end
