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

while ($i <= $m)


set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

set Snum_tmp = `dcm_exam_info -${tnum} | grep 'HARDI' | awk '{print $1}'`      
set Snum = $Snum_tmp[1]
if (`echo $Snum` != '') then
    @ b2000_run = 1
else
    @ b2000_run = 0
endif 

if (-d /data/RECglioma/${bnum}/${tnum}/diffusion_b=2000) then
    cd /data/RECglioma/${bnum}/${tnum}/diffusion_b=2000
    echo "Changed into diffusion directory of $bnum $tnum"
    if (-e ${tnum}_2000_adca.idf) then
        set diffu_status = "Processed."
        echo $diffu_status
    else if (-e ${tnum}_2000_adc.idf) then 
         align_DTI $tnum t1va
         set diffu_status = "Aligned."
         echo $diffu_status
    else 
        set diffu_status = "Dir_b2000_exists, look into."
        echo $diffu_status
    endif
else 
    cd /data/RECglioma/${bnum}/${tnum}
    set Enum = `ls -d E*`
    if (-e ${Enum}/${Snum}/${Enum}S${Snum}I1.DCM) then
        echo "DTI b=2000 series exists on disk.. skipping to import."
    else
        if (${b2000_run} == 1) then 
            echo "getting DTI b=2000 series from archive"
            dcm_qr -${tnum} -s $Snum -e $cwd -g 
            echo "processing DTI b=2000"
            process_DTI_brain ${Enum}/${Snum} ${tnum}
            rm -r ${cwd}/${Enum}/${Snum}
        else
            set diffu_status = "b2000_not_run"
        endif
    endif
endif

@ i = $i + 1
end