#!/bin/csh -f
#
# example: fix_diffu_res.x b2947 t8775 9729
#

set bnum = $1
set tnum = $2


cd /data/RECgli/${bnum}/${tnum}

# fix/create ref.idf
# @input_idf = ("$reference_idf\n", "d\n","256 256 140\n", "256 256 210\n", "1.5\n", "${root}_ref\n");
# csi_run_interactive_program("modify_idf_v5", $output_file, @input_idf);
#


# first check if b=1000 folder exists, if not skip 
if (-d diffusion_b=1000) then
echo "diffusion_b=1000 exists"

cd diffusion_b=1000
echo "changed into directory diffusion_b=1000"

## this part is going to align the images to the new reference image created above 
# resample aligned images to t1ca

cp ../images/$2_t1ca.idf .
echo "copied image t1ca into diffusion directory"

## adca, faa, ev1a, ev2a, ev3a

if (-e $2_1000_adca.int2) then
resample_image_v5 << EOF
$2_1000_adca.int2
$2_t1ca.idf
$2_1000_adca
t
s
EOF
echo "adca1000 resampled"
endif

if (-e $2_1000_faa.int2) then
resample_image_v5 << EOF
$2_1000_faa.int2
$2_t1ca.idf
$2_1000_faa
t
s
EOF
echo "faa1000 resampled"
endif

if (-e $2_1000_ev1a.int2) then
resample_image_v5 << EOF
$2_1000_ev1a.int2
$2_t1ca.idf
$2_1000_ev1a
t
s
EOF
echo "ev1a resampled"
endif

if (-e $2_1000_ev2a.int2) then
resample_image_v5 << EOF
$2_1000_ev2a.int2
$2_t1ca.idf
$2_1000_ev2a
t
s
EOF
echo "ev2a resampled"
endif
	
if (-e $2_1000_ev3a.int2) then
resample_image_v5 << EOF
$2_1000_ev3a.int2
$2_t1ca.idf
$2_1000_ev3a
t
s
EOF
echo "ev3a resampled"
endif

else
	echo "diffusion b=1000 doesn't exist; check this tnum $tnum"

endif 

cd /data/bioe2/*/${bnum}/${tnum}

if (-d diffusion_b=2000) then 

echo "diffusion_b=2000 exists"
cd diffusion_b=2000

cp ../images/$2_t1ca.idf .

	## adca, faa, ev1a, ev2a, ev3a

if (-e $2_2000_adca.int2) then
resample_image_v5 << EOF
$2_2000_adca.int2
$2_t1ca.idf
$2_2000_adca
t
s
EOF
endif

if (-e $2_2000_faa.int2) then
resample_image_v5 << EOF
$2_2000_faa.int2
$2_t1ca.idf
$2_2000_faa
t
s
EOF
endif

if (-e $2_2000_ev1a.int2) then
resample_image_v5 << EOF
$2_2000_ev1a.int2
$2_t1ca.idf
$2_2000_ev1a
t
s
EOF
endif

if (-e $2_2000_ev2a.int2) then
resample_image_v5 << EOF
$2_2000_ev2a.int2
$2_t1ca.idf	
$2_2000_ev2a
t
s
EOF
endif
	
if (-e $2_2000_ev3a.int2) then
resample_image_v5 << EOF
$2_2000_ev3a.int2
$2_t1ca.idf
$2_2000_ev3a
t
s
EOF
endif

	
else
	echo "no diffuion b=2000 folder, check this tnum $tnum"
endif













