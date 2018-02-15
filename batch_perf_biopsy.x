#!/bin/csh -f

####
if ($#argv > 1 ) then
    echo "Please enter the path to the biopsies you're looking for. "
    exit(1)
endif
set n = $1
set broot = /data/bioe2
#set b = `less /home/janinel/perf_biopsy_data/P01_NEW_HGG/NEW_HGG_perf_biopsies_$n.csv | cut -d"," -f1`
#set t = `less /home/janinel/perf_biopsy_data/P01_NEW_HGG/NEW_HGG_perf_biopsies_$n.csv | cut -d"," -f2`
#set sf = `less /home/janinel/perf_biopsy_data/P01_NEW_HGG/NEW_HGG_perf_biopsies_$n.csv | cut -d"," -f3`
#set vial = `less /home/janinel/perf_biopsy_data/P01_NEW_HGG/NEW_HGG_perf_biopsies_$n.csv | cut -d"," -f4`

set b = `more $n | cut -d"," -f1`
set t = `more $n | cut -d"," -f2`
set sf = `more $n | cut -d"," -f3`

set notefile = /home/sf673542/analysis/purest_data/perfusion/run_perf_biopsy_notes.csv
if (-e $notefile) then
	mv $notefile /home/sf673542/analysis/purest_data/perfusion/run_perf_biopsy_notes_lastrun.csv
endif
echo "# bnum tnum sfnum vial phn_nlin cbvn_nlin recov_nlin rf_nlin rfn_nlin phn_npar recov_npar phn_nlin_nn cbvn_nlin_nn recov_nlin_nn rf_nlin_nn phn_npar_nn recov_npar_nn phn_nlin_r cbvn_nlin_r recov_nlin_r rf_nlin_r phn_npar_r recov_npar_r" >> $notefile
set flag = 0
@ i = 1
@ m = `echo $n | cut -d"." -f2`

while ($i <= $m)

	set bnum = `echo ${b} | cut -d" " -f$i`
	set tnum = `echo ${t} | cut -d" " -f$i`
	set sfnum = `echo ${sf} | cut -d" " -f$i`
	echo $i $bnum $tnum sf$sfnum

	#need to first find vialID
    cd /data/bioe2/*/${bnum}/${tnum}
    if (-e perf_biopsy) then
    	mv perf_biopsy biopsy_perf.bak
    endif
    	
	#set cwd = `pwd`
	
	set vialID = `ls roi_analysis/${tnum}_t1ca_*.byt | cut -d"/" -f2 | cut -d"_" -f3 | cut -d "." -f1`
	@ num_vials = `echo "${#vialID}"`
	echo "processing perf for ${num_vials} tissue samples"
	@ j = 1
	set flag = 0
	while ($j <= ${num_vials})

		echo "$i $broot/$bnum/$tnum $sfnum $vialID[$j]"
		cd $cwd
		set out = "$i $bnum $tnum $sfnum $vialID[$j]"

	   	pwd
		# check for aligned perfusion
		@ is_perf_aligned = (`ls -d perf* | grep -i aligned | wc -l`)

 		if ( ${is_perf_aligned} > 0 ) then

			echo "@@@@@ perf_biopsy_new.x $tnum $vialID[$j]  @@@@@"
					
			/home/janinel/svn/surbeck/brain/perfusion/trunk/scripts/perf_biopsy_new.x $tnum $vialID[$j] 0 roi_analysis
		    
			pwd
			if(! -e perf_biopsy/${tnum}_$vialID[$j]_ave_curve_nonlinfit.txt) then   # error ocurrs
            
                #check overlap with biopsy & perfusion
                if (-e   perf_biopsy/${tnum}_$vialID[$j]_outside_perfusion  ) then
				
                    set out = "$out no overlap"
				
            	else 
           			echo "************************************"
	           		echo "ERROR! While executing:"
	            	echo "perf_biopsy_new.x $tnum $vialID[$j] "
	            	echo "************************************"
	        		
                    set out = "$out PERF_BIOPSY_ISSUE"
                endif
                          
			else 
			  	set flag = 1  ## results file exist
			  	
			endif
		else
			set out = "$out no_aligned_perfusion"
				
		endif
		
		if ($flag == 1) then
			  echo " writing out results in csv file"
		       set phn_nlin =  `more perf_biopsy/*_$vialID[$j]_ave_curve_nonlinfit.txt | grep -i phn | cut -d' ' -f3`
			   set cbvn_nlin =  `more perf_biopsy/*_$vialID[$j]_ave_curve_nonlinfit.txt | grep -i cbvn | cut -d' ' -f3`
		       set recov_nlin =  `more perf_biopsy/*_$vialID[$j]_ave_curve_nonlinfit.txt | grep -i 'recov ' | cut -d' ' -f3`
		       set rf_nlin =  `more perf_biopsy/*_$vialID[$j]_ave_curve_nonlinfit.txt | grep -i rf | cut -d' ' -f3`
               set phn_npar =  `more perf_biopsy/*_$vialID[$j]_ave_curve_nonparam.txt | grep -i phn | cut -d' ' -f3`
		       set recov_npar =  `more perf_biopsy/*_$vialID[$j]_ave_curve_nonparam.txt | grep -i 'recov ' | cut -d' ' -f3`
               set out = "$out $phn_nlin $cbvn_nlin $recov_nlin $rf_nlin $phn_npar $recov_npar"	
	    endif
	
		echo $out
		echo "$out" >> $notefile
		set flag = 0
		@ j = $j + 1
	
	end
	
	@ i = $i + 1
end
