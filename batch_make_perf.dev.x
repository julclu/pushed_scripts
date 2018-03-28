#!/bin/csh -f

#### Written by Julia Cluceru 08/05/2017

## here we want to take as an input batch.final.perf_check.date.#scans.csv 

set n = $1
set b = `more $n | cut -d"," -f2`
set t = `more $n | cut -d"," -f3`
set perf_run = `more $n | cut -d"," -f4`
set asl_run = `more $n | cut -d"," -f5`
set dsc_run = `more $n | cut -d"," -f6`
set dsc_topup = `more $n | cut -d"," -f7`
set perf_folder = `more $n | cut -d"," -f8`
set perf_aligned = `more $n | cut -d"," -f9`
set perf_topupAligned = `more $n | cut -d"," -f10`
set perf_biopsy_folder = `more $n | cut -d"," -f11`

set flag = 0
@ i = 2
@ m = `echo $n | cut -d"." -f2`

echo "i bnum tnum status"
while ($i <= $m)
set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
set perf = `echo ${perf_run} | cut -d" " -f$i`
set asl = `echo ${asl_run} | cut -d" " -f$i`
set dsc = `echo ${dsc_run} | cut -d" " -f$i`
set topup = `echo ${dsc_topup} | cut -d" " -f$i`
set perf_f = `echo ${perf_folder} | cut -d" " -f$i`
set perf_aligned_f = `echo ${perf_aligned} | cut -d" " -f$i`
set perf_topupAligned_f = `echo ${perf_topupAligned} | cut -d" " -f$i`
set perf_biopsy_f = `echo ${perf_biopsy_folder} | cut -d" " -f$i`
@ j = $i - 1 

cd /data/RECglioma/${bnum}/${tnum}

## for calculating the perfusion using topup, nontopup, or not at all
if ($perf == "0") then 
	set perf_status = "no_perf_run_skipping"
else ## if perf has been run 
    if ($perf_aligned_f == "0") then ## to be processed
        if ($topup == "NA") then ## if there is no topup correction
            make_perf.dev $tnum -b -f nonlinear --align w --no_topup -n ## run no topup make_perf.dev
            set perf_status = "yes_perf;no_topup;nonrigid_alignment_performed"
        else if ($topup == "1") then ## if there is a topup correction
            make_perf.dev $tnum -b -f nonlinear --align r -n ## run make perf w/ rigid alignment and topup correction
        endif
    else if ($perf_aligned_f == "1" | $perf_topupAligned_f =="1") then ## if the perf_aligned folder exists already
        set perf_status = "perf_aligned_or_topupAligned_f_exists;no_make_perf_run"
    else 
        set perf_status = "unclear;investigate_this"
    endif 
endif 

echo $j $bnum $tnum $perf_status

@ i = $i + 1
end

## for calculating perf_biopsy
#if ($perf_biopsy_f = "0") then ## there is no perf_biopsy folder already
#    ## if perf wasn't run at all 
#    if ($perf = "0") then
#        set perf_biopsy_status = "no_perf;no_perf_biopsy"
#    ## if perf was run, no perf biopsy folder yet 
#    else 
#        ## change into directory, get the biopsy values
#        cd /data/*/${bnum}/${tnum}
#        set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
#        @ num_vials = `echo "${#vialID}"`
#        @ k = 1
#        ## going to cycle through the vialIDs and calculate relevant parameters 
#        while ($k <= ${num_vials})
#            ## calculating results 
#            perf_biopsy_new.x $tnum $vialID[$j] 0 roi_analysis
#            ## if nonlin fit didn't work then there won't exist a nonlinfit curve; perf_biopsy didn't work
#            if(! -e perf_biopsy/${tnum}_$vialID[$j]_ave_curve_nonlinfit.txt) then
#                ## if outside_perfusion does exist though
#               
##                if (-e perf_biopsy/${tnum}_$vialID[$j]_outside_perfusion) then
 #                   set out = "no_overlap"
 #               else 
 #                   set out = "PERF_BIOPSY_ISSUE"
 #               endif
 #           endif
#
#            @ k = $k + 1
#        end
#    endif
#else
##    set perf_biopsy_status = "perf_biopsy_already_exists;no_processing_needed"
#endif
#
#@ i = $i + 1

#end