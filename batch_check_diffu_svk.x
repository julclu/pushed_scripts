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


set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`
echo "i bnum tnum svk tabdiffu csvdiffu tabdiffu2 csvdiffu2" 
while ($i <= $m)

    set bnum = `echo ${b} | cut -d" " -f$i`
    set tnum = `echo ${t} | cut -d" " -f$i`
    cd /data/bioe2/REC_HGG/*/${tnum}
    if (-d svk_roi_analysis) then
        set svk = 1
        cd svk_roi_analysis

        if (-e ${tnum}_roi_adcfa1000.tab) then
            set tabdiffu = 1
        else
            set tabdiffu = 0
        endif

        if (-e ${tnum}_roi_adcfa1000.csv) then
            set csvdiffu = 1
        else
            set csvdiffu = 0
        endif

        if (-e ${tnum}_roi_adcfa2000.tab) then
            set tabdiffu2 = 1
        else
            set tabdiffu2 = 0
        endif

        if (-e ${tnum}_roi_adcfa2000.csv) then
            set csvdiffu2 = 1
        else
            set csvdiffu2 = 0
        endif
    else
        set svk = 0
    endif 
echo $i $bnum $tnum $svk $tabdiffu $csvdiffu $tabdiffu2 $csvdiffu2

@ i = $i + 1

end 







