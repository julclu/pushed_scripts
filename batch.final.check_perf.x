#!/bin/csh -f


## Written by J. Cluceru on 02.26.2018

## This script is to check the entire workflow of perfusion and what has been completed 
## Please use input using a path to a .csv file which is formatted to bnum/tnum/DUMMY;
## there should be no header labeling 
## the bnum/tnum. It must be labeled with the number (#) of bnum/tnum as a .#.csv 
## Final version completed on 


if ($#argv < 1 ) then
    echo ""
    echo "This script is for you to understand what has been completed for diffusion scans."
    echo "The output will be a list of what has been completed."
    echo ""
    echo "An example of it's usage would be /pathtoscript/batch.final.perf_check.x /pathtobnum_tnumlist/bnumtnumlist.#.csv"
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
echo "i bnum tnum perf_run dsc_run topup_dsc_run asl_run perf perf_aligned perf_topupAligned nonparam ph_np recov_np nonlin ph_nl recov_nl perf_biopsy bio_nonparam_fit bio_nonlin_fit"

while ($i <= $m)

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

cd /data/RECglioma/${bnum}/${tnum}/

## First we want to just check what kind of perfusion processing has been run 

## Just by running dcm_exam_info 
## --------------------------- Which perfusion series run? ---------------------------------
set perf_series = `dcm_exam_info -${tnum} | grep 'Perfusion' | awk 'NR==1{print $1}'`
set dsc_series = `dcm_exam_info -${tnum} | grep 'DSC' | awk 'NR==1{print $1}'`
set topup_dsc_series = `dcm_exam_info -${tnum} | grep 'DSC' | grep 'TOPUP' | awk 'NR==1{print $1}'`
set asl_series = `dcm_exam_info -${tnum} | grep 'ASL' | awk 'NR==1{print $1}'`

## perf_run 
## indicates that a series including the word "perfusion" was run
if ($perf_series != "") then 
    set perf_run = 1
else 
    set perf_run = 0
endif
## dsc_run 
## indicates that a series including the "DSC" acronym was run
if ($dsc_series != "") then 
    set dsc_run = 1
else 
    set dsc_run = 0
endif
## topup.dsc_run
## indicates that a series including the "DSC" acronym was run
if ($topup_dsc_series != "") then 
    set topup_dsc_run = 1
else 
    set topup_dsc_run = 0
endif
## asl_run
## indicates that a series including the "ASL" acronym was run
if ($asl_series != "") then 
    set asl_run = 1
else 
    set asl_run = 0
endif
#echo "series run:"
#echo "Perfusion DSC_Perf DSC_TopUp ASL"


## --------------------------- Which perfusion folders exist? ---------------------------------
if (-d perf) then
    set perf_folder = 1
else
    set perf_folder = 0
endif

if (-d perf_topupAligned) then
    set perf_topupAligned_f = 1
    set perf_aligned_f = 0
    cd perf_topupAligned
    if (-d non_parametric) then 
        set non_param_f = 1
        cd non_parametric 
        if (-e ${tnum}_ph.idf) then 
            set ph_np_idf = 1
        else
            set ph_np_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_np_idf = 1
        else
            set recov_np_idf = 0
        endif
        cd ..
    else
        set non_param_f = 0
    endif
    if (-d nonlin_fit) then
        set nonlin_fit_f = 1
        cd nonlin_fit 
        if (-e ${tnum}_ph.idf) then 
            set ph_nl_idf = 1
        else
            set ph_nl_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_nl_idf = 1
        else
            set recov_nl_idf = 0
        endif
        cd ..
    else
        set nonlin_fit_f = 0 
    endif
    cd ..
else if (-d perf_aligned) then
    set perf_aligned_f = 1
    set perf_topupAligned_f = 0
    cd perf_aligned
    if (-d non_parametric) then 
        set non_param_f = 1
        cd non_parametric 
        if (-e ${tnum}_ph.idf) then 
            set ph_np_idf = 1
        else
            set ph_np_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_np_idf = 1
        else
            set recov_np_idf = 0
        endif
        cd ..
    else
        set non_param_f = 0
        set ph_np_idf = 'NA'
        set recov_np_idf = 'NA'
    endif
    if (-d nonlin_fit) then
        set nonlin_fit_f = 1
        cd nonlin_fit 
        if (-e ${tnum}_ph.idf) then 
            set ph_nl_idf = 1
        else
            set ph_nl_idf = 0
        endif
        if (-e ${tnum}_recov.idf) then
            set recov_nl_idf = 1
        else
            set recov_nl_idf = 0
        endif
        cd ..
    else
        set nonlin_fit_f = 0 
        set ph_nl_idf = 'NA'
        set recov_nl_idf = 'NA'
    endif
    cd ..
else
    set perf_aligned_f = 0
    set perf_topupAligned_f = 0
    set non_param_f = 'NA'
    set nonlin_fit_f = 'NA'
    set ph_nl_idf = 'NA'
    set recov_nl_idf = 'NA'
    set ph_np_idf = 'NA'
    set recov_np_idf = 'NA'
endif


if (-d roi_analysis) then
    set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
    @ bionum = `echo "${#vialID}"`
endif 

if (-d perf_biopsy) then
    set perf_biopsy_f = 1

    ## here I want to check if for all vialIDs in the roi_analysis folder, if there are corresponding folders in perf_biopsy
    if (-d roi_analysis) then
        cd perf_biopsy
        @ j = 1
        while ($j <= $bionum)
            set tmp_dir = $vialID[$j]
            if (-d $tmp_dir) then
                set vialID_f = 1
                if (-e ${tnum}_${tmp_dir}_ave_curve_nonlinfit.txt) then
                    set bio_nonlin_fit_f = 1
                else 
                    set bio_nonlin_fit_f = 0
                endif
                if (-e ${tnum}_${tmp_dir}_ave_curve_nonparam.txt) then
                    set bio_nonparam_fit_f = 1
                else
                    set bio_nonparam_fit_f = 0
                endif
            else
                set vialID_f = 0
                set bio_nonparam_fit_f = "NA"
                set bio_nonlin_fit_f = "NA"
                break
            endif
            @ j = $j + 1 
        end
    endif
else 
    set perf_biopsy_f = 0 
    set vialID_f = 'NA'
    set bio_nonparam_fit_f = "NA"
    set bio_nonlin_fit_f = "NA"
endif

#echo "perf perf_topupAligned perf_aligned non_parametric nonlin_fit ph_np recov_np ph_nl recov_nl perf_biospy vials_in_perf_biopsy"
#echo $perf_folder $perf_topupAligned_f $perf_aligned_f $non_param_f $nonlin_fit_f $ph_np_idf $recov_np_idf $ph_nl_idf $recov_nl_idf $perf_biopsy_f $vialID_f



## --------------------------- Which files that we are interested in exist? ---------------------------------

## 
echo $i $bnum $tnum $perf_run $dsc_run $topup_dsc_run $asl_run $perf_folder $perf_topupAligned_f $perf_aligned_f $non_param_f $nonlin_fit_f $ph_np_idf $recov_np_idf $ph_nl_idf $recov_nl_idf $perf_biopsy_f $bio_nonparam_fit_f $bio_nonlin_fit_f

@ i = $i + 1
end 


