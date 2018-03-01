#!/bin/csh -f

set tnum = `pwd | cut -d"/" -f5`

## --------------------------- Series run ---------------------------------

set MRSI_series = `dcm_exam_info -${tnum} | grep 'MRSI' | awk 'NR==1{print $1}'`
set LAC_series = `dcm_exam_info -${tnum} | grep -i 'LAC' | awk 'NR==1{print $1}'`
set short_series = `dcm_exam_info -${tnum} | grep 'MRSI' | grep -i 'short' | awk 'NR==1{print $1}'`
set MRSI_series_total = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`
@ num_MRSI_series = `echo "${#MRSI_series_total}"`
# mrsi 
## indicates that a series including the word "MRSI" was run
if ($MRSI_series != "") then 
    set mrsi_run = 1
else 
    set mrsi_run = 0
endif
## lac_run 
## indicates that a series including the "LAC" acronym was run
if ($LAC_series != "") then 
    set lac_run = 1
else 
    set lac_run = 0
endif
## short_run
## indicates that a series including the "DSC" acronym was run
if ($short_series != "") then 
    set short_run = 1
else 
    set short_run = 0
endif



## --------------------------- Folders & Files ---------------------------------

if (-d spectra) then
    set spectra_f = 1
else
    set spectra_f = 0
endif

if (-d spectra_single) then
    set spec_sing_f = 1
else
    set spec_sing_f = 0 
endif

if (-d spectra_short) then
    set spec_short_f = 1
else
    set spec_short_f = 0
endif

if (-d spectra_lac) then
    set spec_lac_f = 1
else
    set spec_lac_f = 0 
endif

## --------------------------- Getting Lacemode ---------------------------------

## this is to see if lactate editing is on 
set cwd = `pwd`
# find E and s number
set Enum = `ls -d E*`
set Snum_tmp = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`
if (`echo x$Snum_tmp` == `echo "x"` ) then
    set lacemode = 'no_matching_series'
else 
    set Snum = $LAC_series
    if (-d ${Enum}/${Snum}_raw) then
        cd ${Enum}/${Snum}_raw
        if (-e ${tnum}.dat) then
            set lacemode = `more ${tnum}.dat | grep 'lacemode' | awk '{print $3}'`
        else
            set lacemode = 'no_data'
        endif
    else
        # get series from research pacs
        set lacemode = "get_series_from_archive"
    endif
endif 


## Now you know for real whether the lactate editing was on in the machine or not - 

## --------------------------- Biopsy Analysis ---------------------------------
## Begin with only the SVK stuff 
## ----------------------------------------------------------------------

cd /data/RECglioma/*/${tnum}
if (-d svk_roi_analysis) then
    set svk_roi_analysis = 1
    if (-e svk_roi_analysis/${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
        set svk_spec_lac_tab = 1
    else 
        set svk_spec_lac_tab = 0
    endif
    if (-e svk_roi_analysis/${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.csv) then
        set svk_spec_lac_csv = 1
    else 
        set svk_spec_lac_csv = 0
    endif
    if (-e svk_roi_analysis/${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
        set svk_spec_single_tab = 1
    else
        set svk_spec_single_tab = 0
    endif
    if (-e svk_roi_analysis/${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.csv) then
        set svk_spec_single_csv = 1
    else
        set svk_spec_single_csv = 0
    endif
endif
## Biopsy evaluation 
## ----------------------------------------------------------------------

if (-d roi_analysis) then
    set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
    @ bionum = `echo "${#vialID}"`
    if (-e svk_roi_analysis/${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
        set biopsyval = 0
        @ index = 1
        while ($index <= $bionum)
            set vialid_index = `echo $vialID[$index]`
                if (`echo $biopsyval` == '0' && `more svk_roi_analysis/${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00' && `more svk_roi_analysis/${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '') then
                    set biopsyval = 1
                endif
            @ index = $index + 1
        end
    else if (-e svk_roi_analysis/${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
        set biopsyval = 0
        @ index = 1
        while ($index <= $bionum)
            set vialid_index = `echo $vialID[$index]`
                if (`echo $biopsyval` == '0' && `more svk_roi_analysis/${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '0.00' && `more svk_roi_analysis/${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialid_index | awk 'NR==2{print $4}'` != '') then
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
endif 

echo "mrsi_run num_MRSI_series lac_run short_run spectra_f spec_sing_f spec_short_f spec_lac_f lacemode svk_spec_lac_tab svk_spec_lac_csv svk_spec_single_tab svk_spec_single_csv biopsyval"
echo $mrsi_run $num_MRSI_series $lac_run $short_run $spectra_f $spec_sing_f $spec_short_f $spec_lac_f $lacemode $svk_spec_lac_tab $svk_spec_lac_csv $svk_spec_single_tab $svk_spec_single_csv $biopsyval

