#!/bin/csh -f

## run from within tfolder 
set bnum = `pwd | cut -d"/" -f4`
set tnum = `pwd | cut -d"/" -f5`

cd images

# fix/create ref.idf
# @input_idf = ("$reference_idf\n", "d\n","256 256 140\n", "256 256 210\n", "1.5\n", "${root}_ref\n");
# csi_run_interactive_program("modify_idf_v5", $output_file, @input_idf);
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
${tnum}_t1ca.idf
$roilistk
t
s
EOF

@ k = $k + 1
end


# fix biopsy masks
#cd ../roi_analysis
#biopsy_make_masks --sf $sfnum -i ../images/${tnum}_t1ca -d 5 # -o ${tnum}_biopsy
