#!/bin/csh -f


## to be run inside of the t number 

set wd = `pwd`
set bnum = `echo $wd | cut -d"/" -f4`
set tnum = `echo $wd | cut -d"/" -f5`

echo "bnum tnum fsea fla t1va t1ca t1diffa fsea_res fla_res t1diffa_res cel t2all nel nec cel_res t2all_res svk svk_anat_tab svk_anat_csv roi_analysis biopsy_has_value_in_tab biopsy_mask_res"


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

cd /data/RECglioma/${bnum}/${tnum}

if (-d svk_roi_analysis) then
  set svk_roi_analysis = 1
  if (-e svk_roi_analysis/${tnum}_roi_flt1cfse.csv) then
    set svk_anat_csv = 1
  else 
    set svk_anat_csv = 0 
  endif
  if (-e svk_roi_analysis/${tnum}_roi_flt1cfse.tab) then 
    set svk_anat_tab = 1
  else 
    set svk_anat_tab = 0
  endif 
else 
  set svk_roi_analysis = 0
  set svk_anat_tab = 'NA'
  set svk_anat_csv = 'NA'
endif 

## Now we will do the biopsy evaluation - three questions: 1) is there an roi_analysis folder? 2) are the screenshots at the correct resolution? 3) is there value in the .tab file for the biopsy? 
## ----------------------------------------------------------------------
## Question1 : is there an roi_analysis folder? 
if (-d roi_analysis) then 
  set roi_analysis = 1
  ## ----------------------------------------------------------------------
  ## Question 2: if there is roi_analysis folder, are ALL of the screenshots at the correct resolution? 
  ## vialid_res 
  ## Find the vialIDs of all the screenshots 
  set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
  ## Find the number of vialIDs (number of biopsys)
  @ bionum = `echo "${#vialID}"`
  @ index = 1 
  ## Initializing to a value that doesn't really make sense right now
  set vialid_res = 3
  ## Using a while loop to cycle through the number of vialIDs
  while ($index <= $bionum)
    ## set the vialID name
    set vialid_index = `echo $vialID[$index]`
    ## find the resolution of the specific vial ID we are looking at 
    set vialid_index_res =  `more roi_analysis/${tnum}_t1ca_${vialid_index}.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
    ## check to see if the resolution is correct; we are also using the condition vialid_res = 0 b/c if it equals 1 already, don't need to check again 
    if (`echo $vialid_index_res` != '1.00000 1.00000 1.50000') then
      set vialid_res = 0
    else if (`echo $vialid_res` == '0' && `echo $vialid_index_res` == '1.00000 1.00000 1.50000') then 
      set vialid_res = 0
    else 
      set vialid_res = 1
    endif
    @ index = $index + 1
  end 
  ## ----------------------------------------------------------------------
  ## Question 3: is there value in the .tab file for the biopsy? 
  ## biopsyval  
  ## This makes sense here b/c we can only evaluate this if there exists an roi_analysis folder
  ## This will only work if there exists an anat.tab file in svk_roi_analysis folder 
  if (-e svk_roi_analysis/${tnum}_roi_flt1cfse.tab) then
    set biopsyval = 0 
    @ index = 1
    ## here we will cycle through the vialIDs and check whether they have value in the flair area
    while ($index <= $bionum)
      set vialid_index = `echo $vialID[$index]`
      ## this will look to see if the biopsy value is zero (so the previous value was zero) AND the next one is not zero, then we will set it; otherwise it won't do anything b/c already 1
      if (`echo $biopsyval` == '0' && `more svk_roi_analysis/${tnum}_roi_flt1cfse.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00') then
        set biopsyval = 1
      endif
      @ index = $index + 1
    end
  else 
    set biopsyval = 'NA'
  endif

else 
  set roi_analysis = 0 
  set biopsyval = 'NA'
  set vialid_res = 'NA'
endif 


echo "$bnum $tnum $fsea $fla $t1va $t1ca $t1diffa $fsea_res $fla_res $t1diffa_res $cel $t2all $nel $nec $cel_res $t2all_res $svk_roi_analysis $svk_anat_tab $svk_anat_csv $roi_analysis $biopsyval $vialid_res"


## check to see if there are values > 0 in the biopsy ROIs in the svk .tab files 