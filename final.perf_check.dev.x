#!/bin/csh -f

## Written by J. Cluceru on 02.06.18 
## This is a script to check the entire workflow of perfusion. 
## In this script, we want to know 




## run from within the tfolder 

set tnum = `pwd | cut -d"/" -f5`

## --------------------------- Which series were run? ---------------------------------

## Was ASL run? 
set asl_run = `dcm_exam_info -${tnum} | grep 'ASL' | awk 'NR==1{print $1}'`
if ($asl_run !='') then 
    set asl_run = 1
else
    set asl_run = 0
endif

## Was DSC run? Was there TOPUP correction?
set dsc_series_run = `dcm_exam_info -${tnum} | grep 'DSC' | awk 'NR==1{print $1}'`
if ($dsc_series_run !='') then 
    set dsc_run = 1
    set dsc_series_run = `dcm_exam_info -${tnum} | grep 'DSC'`
    if (`echo $dsc_series_run | grep 'TOPUP'` != '') then
        set dsc_topup = 1
    else
        set dsc_topup = 0
    endif
else
    set dsc_run = 0
    set dsc_topup = 'NA'
endif

## --------------------------- Which folders are present? ---------------------------------

## Is there a perf folder? 
if (-d perf) then 
    set perf_folder = 1
else 
    set perf_folder = 0 
endif 

## Is there a perf_aligned folder? 
if (-d perf_aligned) then 
    set perf_aligned_folder = 1
else
    set perf_aligned_folder = 0
endif 

## Is there a perf_topupAligned folder? 
if (-d perf_topupAligned) then 
    set perf_topupAligned_folder = 1 
else 
    set perf_topupAligned_folder = 0
endif

## is there a perf_biopsy folder? 
if (-d perf_biopsy) then
    set perf_biopsy_folder = 1
else 
    set perf_biopsy_folder = 0 
endif

echo "asl_run dsc_run dsc_topup perf_folder perf_aligned_folder perf_topupAligned_folder perf_biopsy_folder"
echo $asl_run $dsc_run $dsc_topup $perf_folder $perf_aligned_folder $perf_topupAligned_folder $perf_biopsy_folder








