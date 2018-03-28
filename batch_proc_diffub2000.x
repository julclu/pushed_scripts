#!/bin/csh -f

#### Written by J.Cluceru on 10.29.2017
#### Purpose of this script is to make sure that all the diffusion_b=1000 files are processed properly 

if ($#argv > 1 ) then
    echo "Please enter the path to the .csv file containing the list of"
    echo "bnum/tnum that you'd like to ensure are processed correctly."
    exit(1)
endif

set n = $1
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1

@ m = `echo $n | cut -d"." -f2`
echo "m set"

echo "i bnum tnum b2000_process_status"

while ($i <= $m)


set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
cd /data/RECglioma/*/${tnum}

set Snum = `dcm_exam_info -${tnum} | grep 'HARDI' | awk 'NR==1{print $1}'`

if ($Snum != '') then ## if the 2000 was run 
    set b2000_run = 1
    if (-d diffusion_b=2000) then ## if there exists a diffu_b2000 folder already
        set b2000_process_status = "already_processed"
    else
        if (-d ${Enum}/${Snum}) then
            set b2000_process_status = "on_disk_unprocessed"
            process_DTI_brain ${Enum}/${Snum} ${tnum}
            rm -r ${cwd}/${Enum}/${Snum}
        else 
            dcm_qr -${tnum} -s $Snum -e $cwd -g
            process_DTI_brain ${Enum}/${Snum} ${tnum}
            set b2000_process_status = "not_on_disk_unprocessed"
            rm -r ${cwd}/${Enum}/${Snum}
        endif
    endif
else 
    set b2000_run = 0
endif

echo $i $bnum $tnum $b2000_process_status
@ i = $i + 1
end