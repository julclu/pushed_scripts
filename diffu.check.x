#!/bin/csh -f

## run 
set bnum = `pwd | cut -d"/" -f4`
set tnum = `pwd | cut -d"/" -f5`

## --------------------------- 1000 ---------------------------------
if (-d diffusion_b=1000) then 
    set b1000_folder = 1
    ## check if there is an adc file 
    if (-e diffusion_b=1000/${tnum}_1000_adc.idf) then
        set b1000_adc = 1
    else
        set b1000_adc = 0
    endif
    ## check if adc is aligned 
    if (-e diffusion_b=1000/${tnum}_1000_adca.idf) then
        set b1000_adca = 1
        ## check to see if adca is at correct resolution 
        set b1000_adca_res = `more diffusion_b=1000/${tnum}_1000_adca.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
        if (`echo $b1000_adca_res` == '1.00000 1.00000 1.50000') then
            set b1000_adca_res = 1
        else 
            set b1000_adca_res = 0
        endif
    else
        set b1000_adca = 0
    endif
    ## check if faa exists 
    if (-e diffusion_b=1000/${tnum}_1000_faa.idf) then
        set b1000_faa = 1
    else
        set b1000_faa = 0
    endif

else
    set b1000_folder = 0
    set b1000_adc = 'NA'
    set b1000_adca = 'NA'
    set b1000_adca_res = 'NA'
    set set b1000_faa = 'NA'
endif

## --------------------------- 2000 ---------------------------------
set b2000_seriesnum = `dcm_exam_info -${tnum} | grep 'HARDI' | awk 'NR==1{print $1}'`
if ($b2000_seriesnum != '') then 
    set b2000_run = 1
else 
    set b2000_run = 0
endif
#echo b2000_run = $b2000_run

if (-d diffusion_b=2000) then 
    set b2000_folder = 1
    ## check if there is an adc file 
    if (-e diffusion_b=2000/${tnum}_2000_adc.idf) then
        set b2000_adc = 1
    else
        set b2000_adc = 0
    endif
    ## check if adc is aligned 
    if (-e diffusion_b=2000/${tnum}_2000_adca.idf) then
        set b2000_adca = 1
        ## check to see if adca is at correct resolution 
        set b2000_adca_res = `more diffusion_b=2000/${tnum}_2000_adca.idf | grep 'pixelsize(mm):' | awk 'NR<=3{print $8}'`
        if (`echo $b2000_adca_res` == '1.00000 1.00000 1.50000') then
            set b2000_adca_res = 1
        else 
            set b2000_adca_res = 0
        endif
    else
        set b2000_adca = 0
        set b2000_adca_res = 'NA'
    endif
    ## check if faa exists 
    if (-e diffusion_b=2000/${tnum}_2000_faa.idf) then
        set b2000_faa = 1
    else
        set b2000_faa = 0
    endif

else
    set b2000_folder = 0
    set b2000_adc = 'NA'
    set b2000_adca = 'NA'
    set b2000_adca_res = 'NA'
    set b2000_faa = 'NA'
endif

## Here I want to check whether there are diffusion values for the svk analysis; 
## ----------------------------------------------------------------------

if (-d svk_roi_analysis) then
    set svk_roi_analysis = 1
    if (-e svk_roi_analysis/${tnum}_roi_adcfa1000.tab) then
        set svk_adca1000_tab = 1
    else 
        set svk_adca1000_tab = 0 
    endif
    if (-e svk_roi_analysis/${tnum}_roi_ev1ev2ev31000.tab) then 
        set svk_ev1000_tab = 1
    else 
        set svk_ev1000_tab = 0
    endif 
    if (-e svk_roi_analysis/${tnum}_roi_adcfa2000.tab) then
        set svk_adca2000_tab = 1
    else 
        set svk_adca2000_tab = 0
    endif
    if (-e svk_roi_analysis/${tnum}_roi_ev1ev2ev32000.tab) then 
        set svk_ev2000_tab = 1
    else
        set svk_ev2000_tab = 0 
    endif
    if (-e svk_roi_analysis/${tnum}_roi_adcfa1000.csv) then
        set svk_adca1000_csv = 1
    else 
        set svk_adca1000_csv = 0 
    endif
    if (-e svk_roi_analysis/${tnum}_roi_ev1ev2ev31000.csv) then 
        set svk_ev1000_csv = 1
    else 
        set svk_ev1000_csv = 0
    endif 
    if (-e svk_roi_analysis/${tnum}_roi_adcfa2000.csv) then
        set svk_adca2000_csv = 1
    else 
        set svk_adca2000_csv = 0
    endif
    if (-e svk_roi_analysis/${tnum}_roi_ev1ev2ev32000.csv) then 
        set svk_ev2000_csv = 1
    else
        set svk_ev2000_csv = 0 
    endif
else 
  set svk_roi_analysis = 0
  set svk_adca1000_tab = 'NA'
  set svk_ev1000_tab = 'NA'
  set svk_adca2000_tab = 'NA'
  set svk svk_ev2000_tab = 'NA'
  set svk_adca1000_csv = 'NA'
  set svk_ev1000_csv = 'NA'
  set svk_adca2000_csv = 'NA'
  set svk_ev2000_csv = 'NA'
endif 

## Now we will do the biopsy evaluation - three questions: 1) is there an roi_analysis folder? 2) is there value in the diffu.tab file for the biopsy? 
## ----------------------------------------------------------------------
## Question1 : is there an roi_analysis folder? 
if (-d roi_analysis) then 
  set roi_analysis = 1
  ## ----------------------------------------------------------------------
  ## Question 2: is there value in the diffu.tab file for the biopsy? 
  ## biopsyval  
  ## This makes sense here b/c we can only evaluate this if there exists an roi_analysis folder
  ## This will only work if there exists an diffu.tab file in svk_roi_analysis folder 
  set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
  @ bionum = `echo "${#vialID}"`
   ## Value for adcfa1000.tab 
   ## ----------------------------------------------------------------------
  if (-e svk_roi_analysis/${tnum}_roi_adcfa1000.tab) then
    set biopsyval_adca1000 = 0 
    @ index = 1
    ## here we will cycle through the vialIDs and check whether they have value in the flair area
    while ($index <= $bionum)
      set vialid_index = `echo $vialID[$index]`
      ## this will look to see if the biopsy value is zero (so the previous value was zero) AND the next one is not zero, then we will set it; otherwise it won't do anything b/c already 1
      if (`echo $biopsyval_adca1000` == '0' && `more svk_roi_analysis/${tnum}_roi_adcfa1000.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00') then
        set biopsyval_adca1000 = 1
      endif
      @ index = $index + 1
    end
  else 
    set biopsyval_adca1000 = 'NA'
  endif
## Value for ev1000.tab 
   ## ----------------------------------------------------------------------
  if (-e svk_roi_analysis/${tnum}_roi_ev1ev2ev31000.tab) then
    set biopsyval_ev1000 = 0 
    @ index = 1
    ## here we will cycle through the vialIDs and check whether they have value in the flair area
    while ($index <= $bionum)
      set vialid_index = `echo $vialID[$index]`
      ## this will look to see if the biopsy value is zero (so the previous value was zero) AND the next one is not zero, then we will set it; otherwise it won't do anything b/c already 1
      if (`echo $biopsyval_ev1000` == '0' && `more svk_roi_analysis/${tnum}_roi_ev1ev2ev31000.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00') then
        set biopsyval_ev1000 = 1
      endif
      @ index = $index + 1
    end
  else 
    set biopsyval_ev1000 = 'NA'
  endif
  ## Value for adcfa2000.tab 
   ## ----------------------------------------------------------------------
  if (-e svk_roi_analysis/${tnum}_roi_adcfa2000.tab) then
    set biopsyval_adca2000 = 0 
    @ index = 1
    ## here we will cycle through the vialIDs and check whether they have value in the flair area
    while ($index <= $bionum)
      set vialid_index = `echo $vialID[$index]`
      ## this will look to see if the biopsy value is zero (so the previous value was zero) AND the next one is not zero, then we will set it; otherwise it won't do anything b/c already 1
      if (`echo $biopsyval_adca2000` == '0' && `more svk_roi_analysis/${tnum}_roi_adcfa2000.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00') then
        set biopsyval_adca2000 = 1
      endif
      @ index = $index + 1
    end
  else 
    set biopsyval_adca2000 = 'NA'
  endif
  ## Value for ev2000.tab 
   ## ----------------------------------------------------------------------
  if (-e svk_roi_analysis/${tnum}_roi_ev1ev2ev32000.tab) then
    set biopsyval_ev2000 = 0 
    @ index = 1
    ## here we will cycle through the vialIDs and check whether they have value in the flair area
    while ($index <= $bionum)
      set vialid_index = `echo $vialID[$index]`
      ## this will look to see if the biopsy value is zero (so the previous value was zero) AND the next one is not zero, then we will set it; otherwise it won't do anything b/c already 1
      if (`echo $biopsyval_ev2000` == '0' && `more svk_roi_analysis/${tnum}_roi_ev1ev2ev32000.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00') then
        set biopsyval_ev2000 = 1
      endif
      @ index = $index + 1
    end
  else 
    set biopsyval_ev2000 = 'NA'
  endif
else 
  set roi_analysis = 0 
  set biopsyval_ev2000 = 'NA'
endif 

echo "bnum $bnum" 
echo "tnum $tnum"
echo "b1000_folder $b1000_folder"
echo "b1000_adc_exists $b1000_adc"
echo "b1000_adca_exists $b1000_adca"
echo "b1000_adca_res $b1000_adca_res"
echo "b1000_faa_exists $b1000_faa"
echo "b2000_run $b2000_run" 
echo "b2000_folder $b2000_folder"
echo "b2000_adc_exists $b2000_adc"
echo "b2000_adca_exists $b2000_adca"
echo "b2000_adca_res $b2000_adca_res"
echo "b2000_faa_exists $b2000_faa"
echo "svk_roi_anal_folder_exists $svk_roi_analysis"
echo "svk_adca1000_tab_exists $svk_adca1000_tab"
echo "svk_ev1000_tab_exists $svk_ev1000_tab"
echo "svk_adca1000_csv_exists $svk_adca1000_csv"
echo "svk_ev1000_csv_exists $svk_ev1000_csv"
echo "svk_adca2000_tab_exists $svk_adca2000_tab"
echo "svk_ev2000_tab_exists $svk_ev2000_tab"
echo "svk_adca2000_csv_exists $svk_adca2000_csv"
echo "svk_ev2000_csv_exists $svk_ev2000_csv"
echo "roi_analysis_folder_exists $roi_analysis"
echo "biopsy_has_value_in_adca1000 $biopsyval_adca1000"
echo "biopsy_has_value_in_ev1000 $biopsyval_ev1000"
echo "biopsy_has_value_in_adca2000 $biopsyval_adca2000"
echo "biopsy_has_value_in_ev20000 $biopsyval_ev2000"

