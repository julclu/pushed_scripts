#!/bin/csh -f


## to be run inside of the t number 

set wd = `pwd`
set bnum = `echo $wd | cut -d"/" -f4`
set tnum = `echo $wd | cut -d"/" -f5`

echo "bnum tnum fsea fla t1va t1ca t1diffa fsea_res fla_res t1diffa_res cel t2all nel nec cel_res t2all_res svk svk_anat_tab svk_anat_csv"


## check to see which anatomical images are in the images folder

cd images

# fsea
if (-e ${tnum}_fsea.int2) then
  set fsea = 1
  ## check to see the resolution of fsea image is correct 
  set fsea_res = `more ${tnum}_fsea.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
  if (`echo $fsea_res` == '1.00000 1.00000 1.50000') then 
    set fsea_res = 1
  else 
    set fsea_res = 0
  endif 
else
  set fsea = 0
  set fsea_res = 'NA'
endif

# fla
if (-e ${tnum}_fla.int2) then
  set fla = 1
  set fla_res = `more ${tnum}_fla.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
  if (`echo $fla_res` == '1.00000 1.00000 1.50000') then 
    set fla_res = 1
  else 
    set fla_res = 0
  endif     
else
  set fla = 0
  set fla_res = 'NA'
endif 

# t1va
if (-e ${tnum}_t1va.int2) then
  set t1va = 1
  set t1va_res = `more ${tnum}_t1va.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
  if (`echo $t1va_res` == '1.00000 1.00000 1.50000') then 
    set t1va_res = 1
  else 
    set t1va_res = 0
  endif     
else
  set t1va = 0
  set t1va_res = 'NA'
endif

# t1ca
if (-e ${tnum}_t1ca.int2) then
  set t1ca = 1
  set t1ca_res = `more ${tnum}_t1ca.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
  if (`echo $t1ca_res` == '1.00000 1.00000 1.50000') then 
    set t1ca_res = 1
  else 
    set t1ca_res = 0
  endif     
else
  set t1ca = 0
  set t1ca_res = 'NA'
endif

if (-e ${tnum}_t1diffa.int2) then
  set t1diffa = 1
  set t1diffa_res = `more ${tnum}_t1diffa.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
  if (`echo $t1diffa_res` == '1.00000 1.00000 1.50000') then 
    set t1diffa_res = 1
  else 
    set t1diffa_res = 0
  endif     
else
  set t1diffa = 0
  set t1diffa_res = 'NA'
endif




## check to see which rois are in the rois folder
cd /data/RECglioma/${bnum}/${tnum}

if (-d rois) then
    cd /data/RECglioma/${bnum}/${tnum}/rois
    set rois = 1

    if (-e ${tnum}_cel.byt) then
        set cel = 1
        ## check to see the resolution of each roi is correct 
        set cel_res = `more ${tnum}_cel.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
        if (`echo $cel_res` == '1.00000 1.00000 1.50000') then 
            set cel_res = 1
        else 
            set cel_res = 0
        endif     
    else
        set cel = 0
        set cel_res = 'NA'
    endif 

    if (-e ${tnum}_t2all.byt) then
        set t2all = 1
        ## check to see the resolution of each roi is correct 
        set t2all_res = `more ${tnum}_t2all.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
        if (`echo $t2all_res` == '1.00000 1.00000 1.50000') then 
            set t2all_res = 1
        else 
            set t2all_res = 0
        endif     
    else
        set t2all = 0
        set t2all_res = 'NA'
    endif 

    if (-e ${tnum}_nel.byt) then
        set nel = 1
        ## check to see the resolution of each roi is correct 
        set nel_res = `more ${tnum}_nel.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
        if (`echo $nel_res` == '1.00000 1.00000 1.50000') then 
            set nel_res = 1
        else 
            set nel_res = 0
        endif     
    else
        set nel = 0
        set nel_res = 'NA'
    endif 

    if (-e ${tnum}_nec.byt) then
        set nec = 1
        ## check to see the resolution of each roi is correct 
        set nec_res = `more ${tnum}_nec.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
        if (`echo $nec_res` == '1.00000 1.00000 1.50000') then 
            set nec_res = 1
        else 
            set nec_res = 0
        endif     
    else
        set nec = 0
        set nec_res = 'NA'
    endif 


else 
    set rois = 0
endif 


## check to see if svk_roi_analysis has been run on these
cd /data/RECglioma/${bnum}/${tnum}

if (-d svk_roi_analysis) then
    set svk = 1
    cd svk_roi_analysis
    if (-e ${tnum}_roi_flt1cfse.tab) then 
        set svk_anat_tab = 1
    else 
        set svk_anat_tab = 0
    endif
    if (-e ${tnum}_roi_flt1cfse.csv) then 
        set svk_anat_csv = 1
    else
        set svk_anat_csv = 0 
    endif
else
    set svk = 0 
    set svk_anat_tab = 'NA'
    set svk_anat_csv = 'NA'
endif 

echo "$bnum $tnum $fsea $fla $t1va $t1ca $t1diffa $fsea_res $fla_res $t1diffa_res $cel $t2all $nel $nec $cel_res $t2all_res $svk $svk_anat_tab $svk_anat_csv"


## check to see if there are values > 0 in the biopsy ROIs in the svk .tab files 