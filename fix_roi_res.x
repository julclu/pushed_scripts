#!/bin/csh -f

## run from within rois dir
set bnum = `pwd | cut -d"/" -f4`
set tnum = `pwd | cut -d"/" -f5`
set roi = $1 


# fix/create ref.idf
# @input_idf = ("$reference_idf\n", "d\n","256 256 140\n", "256 256 210\n", "1.5\n", "${root}_ref\n");
# csi_run_interactive_program("modify_idf_v5", $output_file, @input_idf);
#

cp ../images/${tnum}_t1ca.idf .


resample_image_v5 << EOF
${roi}.byt
${tnum}_t1ca.idf
$roi
t
s
EOF
