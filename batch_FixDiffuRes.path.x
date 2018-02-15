#!/bin/csh -f

#### Written by J.Cluceru on 10.9.2017

if ($#argv > 1 ) then
    echo " "
    echo "Please input the path to the list you'd like to fix."
    exit(1)
endif

### Usage: Input batch_FixDiffuRes_b1000.x PathToCsvWithBnumTnumList
### E.g.: batch_FixDiffuRes_b1000.x /home/sf673542/analysis/purest_data/REC_HGG_fix_diffu_res.2.csv


set n = $1
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set sf = `more $n | cut -d"," -f3`

set flag = 0
@ i = 1
#echo "$i $b $t $sf "

@ m = `echo $n | cut -d"." -f2`


while ($i <= $m)

set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
set sfnum = `echo ${sf} | cut -d" " -f$i`

echo $i $bnum $tnum $sfnum

cd /data/bioe2/*/${bnum}/${tnum}

/home/sf673542/pushed_scripts/fix_diffu_res.x $bnum $tnum 


@ i = $i + 1

end
