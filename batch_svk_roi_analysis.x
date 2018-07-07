#!/bin/csh -f

#### Written by Julia Cluceru
#### Note: usage is like batch_svk_roi_analysis # 

#### where # represents the number of bnum/tnum you want to analyse


if ($#argv > 1 ) then
    echo " "
    echo "Please enter the path to the .csv file with Bnum/Tnum you'd like to evaluate."
    exit(1)
endif
set n = $1
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`

set flag = 0
@ i = 1
#echo "$i $b $t $sf "
@ m = `echo $n | cut -d"." -f2`

while ($i <= $m)
set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`

echo $i $bnum $tnum $sfnum

cd /data/bioe2/REC_HGG/${bnum}/*${tnum}/

svk_roi_analysis -$tnum -s $sfnum
@ i = $i + 1

end
