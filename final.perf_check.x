#!/bin/csh -f


## This is to check in a single tnum if you have all the things you want in your perfusion data


## First we want to just check what kind of perfusion processing has been run 

## Just by running dcm_exam_info 
## --------------------------- Which perfusion series run? ---------------------------------
set tnum = `pwd | cut -d"/" -f5`
set perf_series = `dcm_exam_info -${tnum} | grep 'Perfusion' | awk 'NR==1{print $1}'`
set dsc_series = `dcm_exam_info -${tnum} | grep 'DSC' | awk 'NR==1{print $1}'`
set topup_dsc_series = `dcm_exam_info -${tnum} | grep 'DSC' | grep 'TOPUP' | awk 'NR==1{print $1}'`
set asl_series = `dcm_exam_info -${tnum} | grep 'ASL' | awk 'NR==1{print $1}'`

## perf_run 
## indicates that a series including the word "perfusion" was run
if ($perf_series != "") then 
    set perf_run = 1
else 
    set perf_run = 0
endif
## dsc_run 
## indicates that a series including the "DSC" acronym was run
if ($dsc_series != "") then 
    set dsc_run = 1
else 
    set dsc_run = 0
endif
## topup.dsc_run
## indicates that a series including the "DSC" acronym was run
if ($topup_dsc_series != "") then 
    set topup_dsc_run = 1
else 
    set topup_dsc_run = 0
endif
## asl_run
## indicates that a series including the "ASL" acronym was run
if ($asl_series != "") then 
    set asl_run = 1
else 
    set asl_run = 0
endif


## --------------------------- Which perfusion folders exist? ---------------------------------
if (-d perf) then
    set perf_folder = 1
else
    set perf_folder = 0
endif

if (-d perf_topupAligned) then
    set perf_topupAligned_f = 1
    set perf_aligned_f = 0
    cd perf_topupAligned
    if (-d non_parametric) then 
        set non_param_f = 1
        cd non_parametric 
        if (-e ${tnum}_ph.idf) then 
            set ph_np_idf = 1
        else
            set ph_np_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_np_idf = 1
        else
            set recov_np_idf = 0
        endif
        cd ..
    else
        set non_param_f = 0
    endif
    if (-d nonlin_fit) then
        set nonlin_fit_f = 1
        cd nonlin_fit 
        if (-e ${tnum}_ph.idf) then 
            set ph_nl_idf = 1
        else
            set ph_nl_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_nl_idf = 1
        else
            set recov_nl_idf = 0
        endif
        cd ..
    else
        set nonlin_fit_f = 0 
    endif
    cd ..
else if (-d perf_aligned) then
    set perf_aligned_f = 1
    set perf_topupAligned_f = 0
    cd perf_aligned
    if (-d non_parametric) then 
        set non_param_f = 1
        cd non_parametric 
        if (-e ${tnum}_ph.idf) then 
            set ph_np_idf = 1
        else
            set ph_np_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_np_idf = 1
        else
            set recov_np_idf = 0
        endif
        cd ..
    else
        set non_param_f = 0
        set ph_np_idf = 'NA'
        set recov_np_idf = 'NA'
    endif
    if (-d nonlin_fit) then
        set nonlin_fit_f = 1
        cd nonlin_fit 
        if (-e ${tnum}_ph.idf) then 
            set ph_nl_idf = 1
        else
            set ph_nl_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_nl_idf = 1
        else
            set recov_nl_idf = 0
        endif
        cd ..
    else
        nonlin_fit_f = 0 
        set ph_nl_idf = 'NA'
        set recov_nl_idf = 'NA'
    endif
    cd ..
else
    set perf_aligned_f = 0
    set perf_topupAligned_f = 0
    set non_param_f = 'NA'
    set nonlin_fit_f = 'NA'
    set ph_nl_idf = 'NA'
    set recov_nl_idf = 'NA'
    set ph_np_idf = 'NA'
    set recov_np_idf = 'NA'
endif


echo "checked folders"

if (-d roi_analysis) then
    set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
    @ bionum = `echo "${#vialID}"`
endif 

if (-d perf_biopsy) then
    set perf_biopsy_f = 1

    ## here I want to check if for all vialIDs in the roi_analysis folder, if there are corresponding folders in perf_biopsy
    if (-d roi_analysis) then
        cd perf_biopsy
        @ j = 1
        while ($j <= $bionum)
            set tmp_dir = $vialID[$j]
            if (-d $tmp_dir) then
                set vialID_f = 1
                if (-e ${tnum}_${tmp_dir}_ave_curve_nonlinfit.txt) then
                    set bio_nonlin_fit_f = 1
                else 
                    set bio_nonlin_fit_f = 0
                endif
                if (-e ${tnum}_${tmp_dir}_ave_curve_nonparam.txt) then
                    set bio_nonparam_fit_f = 1
                else
                    set bio_nonparam_fit_f = 0
                endif
            else
                set vialID_f = 0
                set bio_nonparam_fit_f = "NA"
                set bio_nonlin_fit_f = "NA"
                break
            endif
            @ j = $j + 1 
        end
    endif
else 
    set perf_biopsy_f = 0 
    set vialID_f = 'NA'
    set bio_nonparam_fit_f = "NA"
    set bio_nonlin_fit_f = "NA"
endif

echo "perf perf_topupAligned perf_aligned non_parametric nonlin_fit ph_np recov_np ph_nl recov_nl perf_biospy bio_nonparam_fit bio_nonlin_fit "
echo $perf_folder $perf_topupAligned_f $perf_aligned_f $non_param_f $nonlin_fit_f $ph_np_idf $recov_np_idf $ph_nl_idf $recov_nl_idf $perf_biopsy_f $bio_nonparam_fit_f $bio_nonlin_fit_f



## --------------------------- Which files that we are interested in exist? ---------------------------------

## 


