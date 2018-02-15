#!/bin/csh -f

## Written by JGC on 02/13/2018

## Updated script to get DTI 2000 from archive if not there and subsequently align 

## run from within tdirectory 
## set tnum 
set tnum = `pwd | cut -d"/" -f5`
set cwd = `pwd`
## set Enum to E folder 
set Enum = `ls -d E*`
set Snum = `dcm_exam_info -${tnum} | grep 'HARDI' | awk 'NR==1{print $1}'`

if ($Snum != '') then ## if the 2000 was run 
    set b2000_run = 1
    if (-d diffusion_b=2000) then ## if there exists a diffu_b2000 folder already
        set b2000_process_status = "already_processed"
    else 
        if (-e ${Enum}/${Snum}/${Enum}S${Snum}I1.DCM) then ## if exists on disk, don't import
            set b2000_disk_status = "already_exists"
        else 
            dcm_qr -${tnum} -s $Snum -e $cwd -g
            set b2000_disk_status = "imported"
        endif
        process_DTI_brain ${Enum}/${Snum} ${tnum} 
        set b2000_process_status = "processed_now"
        rm -r ${cwd}/${Enum}/${Snum}
    endif
else 
    set b2000_run = 0
endif


