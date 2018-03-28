#!/bin/csh -f

# run from within tdir
set tnum = `pwd | cut -d"/" -f5`
set cwd = `pwd`
set Enum = `ls -d E*`
set Snum_tmp = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`

if (`echo x$Snum_tmp` == `echo "x"`) then
    set lacemode_tmp = 'no_matching_series'
    echo $lacemode_tmp
else 
    set Snum = $Snum_tmp[1]
    if (-d ${Enum}/${Snum}_raw) then
        cd ${Enum}/${Snum}_raw
        if (-e ${tnum}.dat) then
            set lacemode_tmp = `more ${tnum}.dat | grep 'lacemode' | awk '{print $3}'`
            echo $lacemode_tmp 
        else
            set lacemode_tmp = 'no_data'
            echo $lacemode_tmp
        endif
    else
        set lacemode_tmp = "get_series_from_pacs"
        echo $lacemode_tmp
    endif
endif 