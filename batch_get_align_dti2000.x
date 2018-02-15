#!/bin/csh -f

## Written by JGC on 02/15/2018

if ($#argv < 1 ) then
    echo ""
    echo "This script is for calling get_align_dti2000.x for a large number of scans at once."
    echo "It is suggested that you run this either on a vnc server or in a screen in order to ensure"
    echo "that it will continue running even if you locally disconnect from the server."
    echo ""
    echo "Please give as a first argument the path to a bnum/tnum/DUMMY .csv file that includes all"
    echo "of the bnum/tnum you wish to process. It is necessary that the number of scans in your .csv"
    echo "is specified in your .csv name surrounded by "."; e.g. nameofbnumtumlist.#.csv"
    echo ""
    echo "If you have scans from both RECglioma and NEWglioma that you'd like to process, you may either"
    echo "separate these into separate bnum/tnum lists, or you may edit this script to have a * where RECglioma is."
    echo "The latter will take much longer." 
    exit(1)
endif

set n = $1
set broot = /data/RECglioma
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

echo "i bnum tnum "
while ($i <= $m)

    set bnum = `echo ${b} | cut -d" " -f$i`
    set tnum = `echo ${t} | cut -d" " -f$i`

    ## Change "RECglioma here to a * or to NEWglioma or whichever directory your data is stored in."
    cd /data/RECglioma/${bnum}/${tnum}/

    /home/sf673542/analysis/diffu_bnum_comparison/updated_scripts/get_align_dti2000.x 
    
    @ i = $i + 1
end 
