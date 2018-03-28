#!/bin/csh -f
#
# example: get_and_align_fse.x t8775
#
# run from within tdirectory
#

set tnum = `pwd | cut -d"/" -f5`
set cwd = `pwd`
# find E and s number
#dcm_exam_info -${tnum} | grep 'CUBE T2'
set Enum = `ls -d E*`
set Snum = `dcm_exam_info -${tnum} | grep 'CUBE T2' | awk 'NR==1{print $1}'`
#set Snum_tmp = `dcm_exam_info -${tnum} | grep 'SAG 3D T2' | awk '{print $1}'`


# get series from research pacs
if (-e ${Enum}/${Snum}/${Enum}S${Snum}I1.DCM) then
	echo "FSE series exists on disk.. skipping to import"
else
	echo "getting FSE series from archive"
	dcm_qr -${tnum} -s $Snum -e $cwd -g
endif

cd images

# import to images directory as .int2
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

