#!/bin/csh -f

## run from within rois dir
set bnum = `pwd | cut -d"/" -f4`
set tnum = `pwd | cut -d"/" -f5`
set roi = $1 

# 

cp ${tnum}_t1ca.idf ../rois
cd ../rois
@ roinum = `ls *.byt | wc -l`
echo $roinum
## here we are initializing a new variable 
@ k = 1
## here I am creating a file called roilist.txt that indexes the .byt files 
ls *.byt > roilist.txt
## here I want to cycle through each roi and resample it 
while ($k <= $roinum)

set roilistk = `awk 'NR=='$k'' roilist.txt | cut -d"." -f1`

resample_image_v5 << EOF
$roilistk.byt
${tnum}_fsea.idf
$roilistk
t
s
EOF

@ k = $k + 1
end


# fix biopsy masks
cd /data/bioe2/*/${bnum}/${tnum}/roi_analysis
rm ${tnum}_t1ca.i*
biopsy_make_masks --sf $sfnum -i ../images/${tnum}_t1ca -d 5 # -o ${tnum}_biopsy

cd /data/bioe2/*/${bnum}/${tnum}/
=======
cp ../images/${tnum}_t1ca.idf .


resample_image_v5 << EOF
${roi}.byt
${tnum}_t1ca.idf
$roi
t
s
EOF
>>>>>>> master
