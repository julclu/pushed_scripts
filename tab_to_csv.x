#!/bin/csh -f

set tnum = `pwd | cut -d"/" -f5`

if (-d svk_roi_analysis) then
    echo "folder svk_roi_analysis exists, changing into directory"
    cd svk_roi_analysis
    echo "changed into svk_roi_analysis directory"

    ## here we are going to count the number of .tab files 
    @ tabnum = `ls *.tab | wc -l`
    echo $tabnum
    ## here we are initializing a new variable 
    @ k = 1
    ## here I am creating a file called tablist.txt that indexes the .tab files 
    ls *.tab > tablist.txt

    while ($k <= $tabnum)
        set tablist_k = `awk 'NR=='$k'' tablist.txt | cut -d"." -f1`
        tab_to_csv -r $tablist_k
        echo "tab_to_csv $k completed"
        mv summary.csv ${tablist_k}.csv
        echo "summary file $k renamed"
        @ k = $k + 1
    end

else
    echo "no svk_roi_analysis folder, will skip"
endif
