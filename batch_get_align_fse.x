#!/bin/csh -f

if ($#argv < 1 ) then
    echo "This script accepts as an input the output from batch.check.anat.x"
    echo "Please list as your first argument to the script, a path to the output from batch.check.anat.x"
    exit(1)
endif

set n = $1 
set broot = /data/RECglioma
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set f = `more $n | cut -d"," -f3`
set fres = `more $n | cut -d"," -f8`

set flag = 0
@ i = 2
@ m = `echo $n | cut -d"." -f2`

set notefile = $broot/fsea_notefile.csv
if (-e $notefile) then
    mv $notefile $broot/fsea_notefile_lastrun.csv
endif

while ($i <= $m)
set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
set fsea = `echo ${f} | cut -d" " -f$i`
set fsea_res = `echo ${fres} | cut -d" " -f$i`

if (`echo $fsea` == "0")
cd /data/RECglioma/${bnum}/${tnum}

set cwd = `pwd`
# find E and s number
#dcm_exam_info -${tnum} | grep 'CUBE T2'
set Enum = `ls -d E*`
set Snum = `dcm_exam_info -${tnum} | grep 'CUBE T2' | awk 'NR==1{print $1}'`

if (-e ${Enum}/${Snum}/${Enum}S${Snum}I1.DCM) then
    echo "FSE series exists on disk.. skipping to import"
else
    echo "getting FSE series from archive"
    dcm_qr -${tnum} -s $Snum -e $cwd -g
endif

cd images

svk_file_convert -i ../${Enum}/${Snum}/${Enum}S${Snum}I1.DCM -o ${tnum}_fse_sag -t3

#resample to axial
resample_image_v5 << EOF
${tnum}_fse_sag.int2
${tnum}_ref.idf
${tnum}_fse
t
s
EOF

#align to rest of images
echo " starting alignment of fse to t1ca"
align_tool ${tnum}_fse ${tnum}_t1ca ${tnum}_fsea

set fsea_status = "fse_from_archive_resampled_aligned"

else if (`echo $fsea` == "1" && `echo $fsea_res` == "0") then
resample_image_v5 << EOF
${tnum}_fsea.int2
${tnum}_t1ca.idf
${tnum}_fsea
t
s
EOF

set fsea_status = "fsea_resolution_corrected"

else 

set fsea_status = "nothing_needed"

endif

echo "$bnum,$tnum,$fsea,$fsea_res,$fsea_status" >> $notefile
@i = $i +1 

end


