#!/bin/csh -f

## Written by JGC on 02/13/2018

## Updated script to get DTI 2000 from archive if not there and subsequently align 

## run from within tdirectory 
## set tnum 
set bnum = `pwd | cut -d"/" -f4`
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
            echo $b2000_disk_status
        else 
            echo "importing from disk"
            dcm_qr -${tnum} -s $Snum -e $cwd -g
            set b2000_disk_status = "imported"
        endif
        echo "beginning processing"
        process_DTI_brain ${Enum}/${Snum} ${tnum} > tmp_bproc.txt
        set b2000_process_status = "processed_now"
        echo $b2000_process_status
        rm -r ${Enum}/${Snum}
        echo "removed from disk"
    endif
else 
    set b2000_run = 0
    set b2000_process_status = "NA"
    set b2000_disk_status = "NA"
endif