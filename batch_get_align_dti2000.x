#!/bin/csh -f

## Written by JGC on 02/15/2018

if ($#argv < 1 ) then
    echo ""
    echo "This script is for calling get_align_dti2000.x for a large number of scans at once."
    echo "It is suggested that you run this either on a vnc server or in a screen in order to ensure"
    echo "that it will continue running even if you locally disconnect from the server."
    echo ""
    echo "Please give as a first argument the path to a bnum/tnum/DUMMY .csv file that includes all"
    echo "of the bnum/tnum you wish to process. It is necessary that the number of scans in your .csv"
    echo "is specified in your .csv name surrounded by "."; e.g. nameofbnumtumlist.#.csv"
    echo ""
    echo "If you have scans from both RECglioma and NEWglioma that you'd like to process, you may either"
    echo "separate these into separate bnum/tnum lists, or you may edit this script to have a * where RECglioma is."
    echo "The latter will take much longer." 
    exit(1)
endif

set n = $1
set broot = /data/RECglioma
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

echo "i bnum tnum b2000_run b2000_process_status b2000_disk_status"
while ($i <= $m)

    set bnum = `echo ${b} | cut -d" " -f$i`
    set tnum = `echo ${t} | cut -d" " -f$i`

    ## Change "RECglioma here to a * or to NEWglioma or whichever directory your data is stored in."
    cd /data/RECglioma/${bnum}/${tnum}/

    set Enum = `ls -d E*`
    set Snum = `dcm_exam_info -${tnum} | grep 'HARDI' | awk 'NR==1{print $1}'`

if ($Snum != '') then ## if the 2000 was run 
    set b2000_run = 1
    if (-d diffusion_b=2000) then ## if there exists a diffu_b2000 folder already
        set b2000_process_status = "already_processed"
        set b2000_disk_status = "NA"
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
    echo $i $bnum $tnum $b2000_run $b2000_process_status $b2000_disk_status
    @ i = $i + 1
end 
