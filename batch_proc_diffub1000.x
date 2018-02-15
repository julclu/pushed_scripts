#!/bin/csh -f

#### Written by J.Cluceru on 10.29.2017
#### Purpose of this script is to make sure that all the diffusion_b=1000 files are processed properly 

if ($#argv > 1 ) then
    echo "Please enter the path to the .csv file containing the list of"
    echo "bnum/tnum that you'd like to ensure are processed correctly."
    exit(1)
endif

set n = $1
set broot = /data/bioe2/REC_HGG
set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set sf = `more $n | cut -d"," -f3`

set flag = 0
@ i = 1

@ m = `echo $n | cut -d"." -f2`
echo "m set"

while ($i <= $m)


set bnum = `echo ${b} | cut -d" " -f$i`
set tnum = `echo ${t} | cut -d" " -f$i`
set sfnum = `echo ${sf} | cut -d" " -f$i`

if (-d /data/bioe2/REC_HGG/${bnum}/${tnum}/diffusion_b=1000) then
	cd /data/bioe2/REC_HGG/${bnum}/${tnum}/diffusion_b=1000
	echo "Changed into diffusion directory of $bnum $tnum"
	if (-e ${tnum}_1000_adca.idf) then
		set diffu_status = "Processed."
		echo $diffu_status

	else if (-e ${tnum}_1000_adc.idf) then 
		 align_DTI $tnum t1va
		 set diffu_status = "Aligned."
		 echo $diffu_status
	endif
else 
	cd /data/bioe2/REC_HGG/${bnum}/${tnum}
	set Enum = `ls -d E*`
	set Snum_tmp = `dcm_exam_info -${tnum} | grep '24' | awk '{print $1}'`		
	set Snum = $Snum_tmp[1]
	if (-e ${Enum}/${Snum}/${Enum}S${Snum}I1.DCM) then
		echo "DTI b=1000 series exists on disk.. skipping to import."
	else
		echo "getting DTI b=1000 series from archive"
		dcm_qr -${tnum} -s $Snum -e $cwd -g
		process_DTI_brain ${Enum}/${Snum} ${tnum}
		rm -r ${cwd}/${Enum}/${Snum}
	endif
endif

@ i = $i + 1
end