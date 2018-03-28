#!/bin/csh -f

## This script is to check the entire workflow of spectroscopy and what has been completed 
## Please use input using a path to a .csv file which is formatted to bnum/tnum/DUMMY;
## there should be no header labeling 
## the bnum/tnum. It must be labeled with the number (#) of bnum/tnum as a .#.csv 
## Final version completed on 02.27.18 

if ($#argv < 1 ) then
    echo ""
    echo "This script is for you to understand what has been completed for diffusion scans."
    echo "The output will be a list of what has been completed."
    echo ""
    echo "An example of it's usage would be /pathtoscript/batch.final.diffu_check.x /pathtobnum_tnumlist/bnumtnumlist.#.csv"
    echo ""
    echo "Please input the path to the list of bnum/tnum you'd like to check. Make sure naming conventions are correct."
    echo ""
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
#echo "i bnum tnum b1000_folder b1000_adc b1000_adca b1000_adca_res b1000_faa b2000_run b2000_folder b2000_adc b2000_adca b2000_adca_res b2000_faa svk_roi_analysis svk_adca1000_tab svk_ev1000_tab svk_adca1000_csv svk_ev1000_csv svk_adca2000_tab svk_ev2000_tab svk_adca2000_csv svk_ev2000_csv roi_analysis biopsyval_adca1000 biopsyval_ev1000 biopsyval_adca2000 biopsyval_ev2000"
echo "i,bnum,tnum,mrsi_run,num_MRSI_series,lac_run,short_run,spectra_f,spec_sing_f,spec_short_f,spec_lac_f,lacemode,svk_spec_lac_tab,svk_spec_lac_csv,svk_spec_single_tab,svk_spec_single_csv,biopsyval_ev2000"

while ($i <= $m)

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

cd /data/RECglioma/${bnum}/${tnum}/

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
#echo 'series done'


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

#echo 'folders done'

## --------------------------- Getting Lacemode ---------------------------------

## this is to see if lactate editing is on 
set cwd = `pwd`
set Enum = `ls -d E*`
set Snum_tmp = `dcm_exam_info -${tnum} | grep 'MRSI' | awk '{print $1}'`

if (`echo x$Snum_tmp` == `echo "x"`) then
    set lacemode = 'no_matching_series'

else 
    set Snum = $Snum_tmp[1]
    if (-d ${Enum}/${Snum}_raw) then
        cd ${Enum}/${Snum}_raw
        if (-e ${tnum}.dat) then
            set lacemode = `more ${tnum}.dat | grep 'lacemode' | awk '{print $3}'`

        else
            set lacemode = 'no_data'
        endif
    else
        set lacemode = "get_series_from_pacs"

    endif
endif 

#echo 'lacemode done'
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
else 
    set svk_roi_analysis = 0
    set svk_spec_lac_tab = 'NA'
    set svk_spec_lac_csv = 'NA'
    set svk_spec_single_tab = 'NA'
    set svk_spec_single_csv = 'NA'
endif

#echo 'tab csv done'
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

#echo 'biopsy eval done'

echo $i,$bnum,$tnum,$mrsi_run,$num_MRSI_series,$lac_run,$short_run,$spectra_f,$spec_sing_f,$spec_short_f,$spec_lac_f,$lacemode,$svk_spec_lac_tab,$svk_spec_lac_csv,$svk_spec_single_tab,$svk_spec_single_csv,$biopsyval

@ i = $i + 1
end
