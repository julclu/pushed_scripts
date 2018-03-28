#!/bin/csh -f

## Written by J. Cluceru on 02.06.18 
## This is a script to check the entire workflow of perfusion. 

if ($#argv < 1 ) then
    echo ""
    echo "This script is for you to understand what has been completed for perfusion processing" 
    echo "An example of it's usage would be /pathtoscript/batch.final.diffu_check.x /pathtobnum_tnumlist/bnumtnumlist.#.csv"
    echo ""
    echo "Please input the path to the list of bnum/tnum you'd like to check. Make sure naming conventions are correct."
    echo ""
    exit(1)
endif

set n = $1
set broot = /data/RECglioma
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

echo "i,bnum,tnum,perf_run,asl_run,dsc_run,dsc_topup,perf_folder,perf_aligned_folder,perf_topupAligned_folder,perf_biopsy_folder"

while ($i <= $m)

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

cd /data/RECglioma/${bnum}/${tnum}/

## --------------------------- Which series were run? ---------------------------------
## Was there a series at all run w/ term "Perf in there?"
set perf_run = `dcm_exam_info -${tnum} | grep 'Perfusion' -i | awk 'NR==1{print $1}'`
if ($perf_run !='') then 
    set perf_run = 1
else
    set perf_run = 0
endif

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

echo $i,$bnum,$tnum,$perf_run,$asl_run,$dsc_run,$dsc_topup,$perf_folder,$perf_aligned_folder,$perf_topupAligned_folder,$perf_biopsy_folder

@ i = $i + 1

end