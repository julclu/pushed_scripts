#!/bin/csh -f

## The purpose of this script is to delete space on the server
## IF there is a file tnum_1000_adca.int2 in the diffusion_b=1000 folder
## go and delete the dicoms from that particular b=1000 series number 

if ($#argv > 0 ) then
    echo " "
    echo "Usage: P01_run_fix_resolution_from_list"
    echo "Read .cvs and copy all patients images in .cvs to droot"
    exit(1)
endif

## run from REC_HGG 

@ dirnum = `ls -d */*/diffusion_b=1000 | wc -l`
echo $dirnum
ls -d */*/diffusion_b=1000 > DTI1000.txt
@ i = 1

while ($i <= $dirnum)
    cd /data/bioe2/REC_HGG
    set dir_i = `awk 'NR=='$i'' DTI1000.txt`
    set bnum = `awk 'NR=='$i'' DTI1000.txt | cut -d"/" -f1`
    set tnum = `awk 'NR=='$i'' DTI1000.txt | cut -d"/" -f2`
    cd $dir_i
    echo "changed into b=1000 directory"
    
    if (-e ${tnum}_1000_adca.int2) then
        echo "aligned DTI 1000 exists"
        cd ..
        set Enum = `ls -d E*`
        set Snum_tmp = `dcm_exam_info -${tnum} | grep '1000' | awk '{print $1}'`
        set Snum = $Snum_tmp[1]
        echo "Enum and Snum set"
        if (-d ${Enum}/${Snum}) then
            echo "Series number $Snum exists in E folder"
            cd $Enum
            rm -r $Snum
            set status = "Series $Snum removed from $Enum"
            echo $status
        else
            set status = "There is no series $Snum in the E folder"
            echo $status
        endif 
    else
        set status = "There is more to be processed - check this out"
        echo $status
    endif

    echo $i $bnum $tnum $status
    if ($i == 8) then 
        @ i = $i + 2
    else if ($i == 43) then
        @ i = $i + 2
    else 
        @ i = $i + 1
    endif

end



