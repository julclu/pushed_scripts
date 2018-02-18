#!/bin/csh -f


## Written by J. Cluceru on 02.05.18 

## This script is to check the entire workflow of diffusion and what has been completed 
## Please use input using a path to a .csv file which is formatted to bnum/tnum/DUMMY;
## there should be no header labeling 
## the bnum/tnum. It must be labeled with the number (#) of bnum/tnum as a .#.csv 
## Final version completed on 02.06.18 


if ($#argv < 1 ) then
    echo ""
    echo "This script is for you to understand what has been completed for diffusion scans."
    echo "The output will be a list of what has been completed."
    echo ""
    echo "An example of it's usage would be /pathtoscript/batch.final.diffu_check.x /pathtobnum_tnumlist/bnumtnumlist.#.csv"
    echo ""
    echo "Please input the path to the list of bnum/tnum you'd like to check. Make sure naming conventions are correct."
    echo ""
    echo "b1000_run, b2000_run check whether these were run in dcm_exam_info"
    echo "b1000_adc, b1000_adca, b2000_adc, b2000_adca, b1000_faa, b2000_faa check for existence of these images in respective folders."
    echo "b1000_adca_res and b2000_adca_res check to see if the resolution is properly 1x1x1.5"
    echo "svk_roi_analysis: checks for existence of svk_roi_analysis folder"
    echo "svk_adca1000_tab: checks for existence of _1000_adcfa.tab file in /svk_roi_analysis/"
    echo "the same is true for the tab and csv variables"
    echo "biopsyval: 1 means there exists values for diffusion biopsies that are greater than zero for the FLAIR image;"
    echo "biopsyval = 0 indicates lack of value for the biopsy in the FLAIR image; NA indicates no .tab file to look in."

    exit(1)

endif

set n = $1
set broot = /data/RECglioma
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

#echo "i bnum tnum b1000_run b1000_folder b1000_adc b1000_adca b1000_adca_res b1000_faa b2000_run b2000_folder b2000_adc b2000_adca b2000_adca_res b2000_faa svk_roi_analysis svk_adca1000_tab svk_ev1000_tab svk_adca1000_csv svk_ev1000_csv svk_adca2000_tab svk_ev2000_tab svk_adca2000_csv svk_ev2000_csv roi_analysis biopsyval_adca1000 biopsyval_ev1000 biopsyval_adca2000 biopsyval_ev2000"
echo "i bnum tnum b1000_folder b1000_adc b1000_adca b1000_adca_res b1000_faa b2000_run b2000_folder b2000_adc b2000_adca b2000_adca_res b2000_faa svk_roi_analysis svk_adca1000_tab svk_ev1000_tab svk_adca1000_csv svk_ev1000_csv svk_adca2000_tab svk_ev2000_tab svk_adca2000_csv svk_ev2000_csv roi_analysis biopsyval_adca1000 biopsyval_ev1000 biopsyval_adca2000 biopsyval_ev2000"

while ($i <= $m)

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

cd /data/RECglioma/${bnum}/${tnum}/

## --------------------------- 1000 ---------------------------------
#set b1000_seriesnum = `dcm_exam_info -${tnum} | grep '24' | awk 'NR==1{print $1}'`
#if ($b1000_seriesnum != "") then 
#    set b1000_run = 1
#else 
#    set b1000_run = 0
#endif

#echo "check 1"

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

echo $i $bnum $tnum $b1000_folder $b1000_adc $b1000_adca $b1000_adca_res $b1000_faa $b2000_run $b2000_folder $b2000_adc $b2000_adca $b2000_adca_res $b2000_faa $svk_roi_analysis $svk_adca1000_tab $svk_ev1000_tab $svk_adca1000_csv $svk_ev1000_csv $svk_adca2000_tab $svk_ev2000_tab $svk_adca2000_csv $svk_ev2000_csv $roi_analysis $biopsyval_adca1000 $biopsyval_ev1000 $biopsyval_adca2000 $biopsyval_ev2000

@ i = $i + 1

end










