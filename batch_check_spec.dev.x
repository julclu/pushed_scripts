#!/bin/csh -f

#### Written by J.Cluceru on 11.9.2017

if ($#argv > 1 ) then
    echo "Please input the path to the list of bnum/tnum you'd like to check."
    exit(1)
endif

## path should be formatted bnum tnum seo 
set n = $1
set broot = /data/bioe2/REC_HGG
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set s = `more $n | cut -d"," -f3`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`
echo "i bnum tnum seo svk_exists singlespec lacspec valueinbiopsies" 
while ($i <= $m)

    set bnum = `echo ${b} | cut -d" " -f$i`
    set tnum = `echo ${t} | cut -d" " -f$i`
    set seo = `echo ${s} | cut -d" " -f$i`
    cd /data/bioe2/REC_HGG/*/${tnum}
    if (-d svk_roi_analysis) then
        set svk = 1
        cd svk_roi_analysis

        if ($seo == "single") then
            if (-e ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
                set specsingle = 1
                set speclac = 0
                ## here I'm going to try to see if I can identify if there are zero values for everythin in the biopsies 
                cd ..
                set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
                @ bionum = `echo "${#vialID}"`
                cd svk_roi_analysis
                @ j = 1
                while ($j <= $bionum)
                    set biopsystatus = `more ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialID[$j]`
                    echo $biopsystatus
                    echo "Does this have any value? please type y or n"
                    set answer = $<
                    if ($answer == "y") then
                        set value = 1
                        break
                    else
                        set value = 0
                    endif
                    @ j = $j + 1 
                end
            else if (-e ${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
                set specsingle = 0
                set speclac = 1
                while ($j <= $bionum)
                    set biopsystatus = `more ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialID[$j]`
                    echo $biopsystatus
                    echo "Does this have any value? please type y or n"
                    set answer = $<
                    if ($answer == "y") then
                        set value = 1
                        break
                    else
                        set value = 0
                    endif
                    @ j = $j + 1 
                end
            else
                set specsingle = 0
                set speclac = 0
            endif 
        else if ($seo == "even") then 
            if (-e ${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
                set specsingle = 0
                set speclac = 1
                while ($j <= $bionum)
                    set biopsystatus = `more ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialID[$j]`
                    echo $biopsystatus
                    echo "Does this have any value? please type y or n"
                    set answer = $<
                    if ($answer == "y") then
                        set value = 1
                        break
                    else
                        set value = 0
                    endif
                    @ j = $j + 1 
                end
            else if (-e ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
                set specsingle = 1
                set speclac = 0
                while ($j <= $bionum)
                    set biopsystatus = `more ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialID[$j]`
                    echo $biopsystatus
                    echo "Does this have any value? please type y or n"
                    set answer = $<
                    if ($answer == "y") then
                        set value = 1
                        break
                    else
                        set value = 0
                    endif
                    @ j = $j + 1 
                end
            else
                set specsingle = 0
                set speclac = 0
            endif
        else
            if (-e ${tnum}_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
                set specsingle = 0
                set speclac = 1
                while ($j <= $bionum)
                    set biopsystatus = `more ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialID[$j]`
                    echo $biopsystatus
                    echo "Does this have any value? please type y or n"
                    set answer = $<
                    if ($answer == "y") then
                        set value = 1
                        break
                    else
                        set value = 0
                    endif
                    @ j = $j + 1 
                end
            else if (-e ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab) then
                set specsingle = 1
                set speclac = 0
                while ($j <= $bionum)
                    set biopsystatus = `more ${tnum}_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.tab | grep $vialID[$j]`
                    echo $biopsystatus
                    echo "Does this have any value? please type y or n"
                    set answer = $<
                    if ($answer == "y") then
                        set value = 1
                        break
                    else
                        set value = 0
                    endif
                    @ j = $j + 1 
                end
            else
                set specsingle = 0
                set speclac = 0
            endif
        endif 

    else
        set svk = 0
    endif 
echo $i $bnum $tnum $seo $svk $specsingle $speclac $value > /home/sf673542/analysis/new_data_extraction/tmpfile.txt
cat /home/sf673542/analysis/new_data_extraction/tmpfile.txt >> /home/sf673542/analysis/new_data_extraction/specrecord.txt
@ i = $i + 1

end 







