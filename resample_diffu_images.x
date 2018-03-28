#!/bin/csh -f

## Written by JGC on 02/13/2018

## Updated script to get DTI 2000 from archive if not there and subsequently align 

## run from within tdirectory, use 1000 or 2000 as the first input 
## set tnum 
set tnum = `pwd | cut -d"/" -f5`
set diffubnum = $1 

set diffufolder = `echo "diffusion_b="$diffubnum`
cd $diffufolder
mkdir bkup 
cp . bkup

cp ../images/${tnum}_t1ca.idf .

echo "beginning resampling"

if (-e ${tnum}_${diffubnum}_adca.int2) then 
set adca = 1
resample_image_v5 << EOF
${tnum}_${diffubnum}_adca.int2
${tnum}_t1ca.idf
${tnum}_${diffubnum}_adca
t
s
EOF
else 
    set adca = 0
endif
echo "adca resampled = $adca"

if (-e ${tnum}_${diffubnum}_faa.int2) then 
set faa = 1
resample_image_v5 << EOF
${tnum}_${diffubnum}_faa.int2
${tnum}_t1ca.idf
${tnum}_${diffubnum}_faa
t
s
EOF
else 
    set faa = 0
endif
echo "faa resampled = $faa"

if (-e ${tnum}_${diffubnum}_ev1a.int2) then 
set ev1a = 1
resample_image_v5 << EOF
${tnum}_${diffubnum}_ev1a.int2
${tnum}_t1ca.idf
${tnum}_${diffubnum}_ev1a
t
s
EOF
else 
    set ev1a = 0
endif
echo "ev1a resampled = $ev1a"

if (-e ${tnum}_${diffubnum}_ev2a.int2) then 
set ev2a = 1
resample_image_v5 << EOF
${tnum}_${diffubnum}_ev2a.int2
${tnum}_t1ca.idf
${tnum}_${diffubnum}_ev2a
t
s
EOF
else 
    set ev2a = 0
endif
echo "ev2a resampled = $ev2a"

if (-e ${tnum}_${diffubnum}_ev3a.int2) then 
set ev3a = 1
resample_image_v5 << EOF
${tnum}_${diffubnum}_ev3a.int2
${tnum}_t1ca.idf
${tnum}_${diffubnum}_ev3a
t
s
EOF
else 
    set ev3a = 0
endif
echo "ev3a resampled = $ev3a"

if (-e ${tnum}_${diffubnum}_t2dia.int2) then 
set t2dia = 1
resample_image_v5 << EOF
${tnum}_${diffubnum}_t2dia.int2
${tnum}_t1ca.idf
${tnum}_${diffubnum}_t2dia
t
s
EOF
else 
    set t2dia = 0
endif
echo "t2dia resampled = $t2dia"



