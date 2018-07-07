#!/bin/csh
cd  ./

echo $1

if($1 == single)then
set spec_dir = spectra_single
else if($1 == asymmetric)then
set spec_dir = spectra_asymmetric
else if($1 == short)then
set spec_dir = spectra_short
else if($1 == lac)then
set spec_dir = spectra_lac
endif

cd $spec_dir

if($1 == lac) then

vox_biopsy_spectra_lac.x $2 $5 

set nloop = $4
set iloop = 1
echo $nloop
mv $2*$5*.ddf ../brain_analysis_$2/.
mv $2*$5*.cmplx ../brain_analysis_$2/.

cd ../brain_analysis_$2

while($iloop <= $nloop)

echo $iloop
echo $nloop
echo $2
echo $3
if($iloop == 1) then
vox_spectra_lac.x $2 $3 $5_$6 
endif
if($iloop == 2) then
vox_spectra_lac.x $2 $3 $5_$7
endif
if($iloop == 3) then
vox_spectra_lac.x $2 $3 $5_$8
endif
if($iloop == 4) then
vox_spectra_lac.x $2 $3 $5_$9
endif
if($iloop == 5) then
vox_spectra_lac.x $2 $3 $5_$10
endif
if($iloop == 6) then
vox_spectra_lac.x $2 $3 $5_$11
endif
if($iloop == 7) then
vox_spectra_lac.x $2 $3 $5_$12
endif
if($iloop == 8) then
vox_spectra_lac.x $2 $3 $5_$13
endif
if($iloop == 9) then
vox_spectra_lac.x $2 $3 $5_$14
endif
if($iloop == 10) then
vox_spectra_lac.x $2 $3 $5_$15
endif
if($iloop == 11) then
vox_spectra_lac.x $2 $3 $5_$16
endif
if($iloop == 12) then
vox_spectra_lac.x $2 $3 $5_$17
endif
if($iloop == 13) then
vox_spectra_lac.x $2 $3 $5_$18
endif
if($iloop == 14) then
vox_spectra_lac.x $2 $3 $5_$19
endif
if($iloop == 15) then
vox_spectra_lac.x $2 $3 $5_$20
endif

@ iloop = $iloop + 1

end

else

vox_biopsy_spectra_single.x $2 $5 

set nloop = $4
set iloop = 1
echo $nloop
mv $2*$5*.ddf ../brain_analysis_$2/.
mv $2*$5*.cmplx ../brain_analysis_$2/.

cd ../brain_analysis_$2

while($iloop <= $nloop)

echo $iloop
echo $nloop
if($iloop == 1) then
vox_spectra_single.x $2 $3 $5_$6
endif
if($iloop == 2) then
vox_spectra_single.x $2 $3 $5_$7
endif
if($iloop == 3) then
vox_spectra_single.x $2 $3 $5_$8
endif
if($iloop == 4) then
vox_spectra_single.x $2 $3 $5_$9
endif
if($iloop == 5) then
vox_spectra_single.x $2 $3 $5_$10
endif
if($iloop == 6) then
vox_spectra_single.x $2 $3 $5_$11
endif
if($iloop == 7) then
vox_spectra_single.x $2 $3 $5_$12
endif
if($iloop == 8) then
vox_spectra_single.x $2 $3 $5_$13
endif
if($iloop == 9) then
vox_spectra_single.x $2 $3 $5_$14
endif
if($iloop == 10) then
vox_spectra_single.x $2 $3 $5_$15
endif
if($iloop == 11) then
vox_spectra_single.x $2 $3 $5_$16
endif
if($iloop == 12) then
vox_spectra_single.x $2 $3 $5_$17
endif
if($iloop == 13) then
vox_spectra_single.x $2 $3 $5_$18
endif
if($iloop == 14) then
vox_spectra_single.x $2 $3 $5_$19
endif
if($iloop == 15) then
vox_spectra_single.x $2 $3 $5_$20
endif

@ iloop = $iloop + 1

end

endif

