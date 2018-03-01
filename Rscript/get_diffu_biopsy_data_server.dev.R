## get diffusion biopsy data -- server 
## if we have biopsyabel input and we do have headerlabel input, we will use this: 



get_diffu_biopsy=function(bnum_tnum_df, measure, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    
    ## here we are reading in the csv file from the first element in bnum_tnum_df 
    y=paste("/data/bioe2/REC_HGG/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
    tnum_roi_adcfa1000=read.table(y, sep=",", header=T)
    
    ## here we are going to get the measure block we are looking for 
    tnum_roi_adcfa1000_measure = tnum_roi_adcfa1000[grep(measure, as.character(tnum_roi_adcfa1000$measure)),]
    
    ## here we are going to calculate the number of biopsy just from this data 
    nrow = dim(tnum_roi_adcfa1000_measure)[1]
    
    ## here we are going to extract only the biopsy information rows 
    
    tnum_roi_adcfa1000_measure = data.frame(tnum_roi_adcfa1000_measure, biopsy_binary="0")
    if ("nawm" %in% tnum_roi_adcfa1000_measure$roi.label[1:10]){
      tnum_roi_adcfa1000_m_biopsy = tnum_roi_adcfa1000_measure[12:nrow,]
    }
    else {
      tnum_roi_adcfa1000_m_biopsy = tnum_roi_adcfa1000_measure[11:nrow,]
    }
    
    
    ## and here we are getting the specific header measurement
    ## we have two possible conditions; the header we're looking for exists or doesn't exist in the header (e.g. fse might not be present)
    if(headerlabel %in% colnames(tnum_roi_adcfa1000_m_biopsy)){
      exactheaderlabel=paste("^", headerlabel,"$", sep="")
      h=grep(exactheaderlabel, colnames(tnum_roi_adcfa1000_m_biopsy))
      tnum_roi_adcfa1000_m_r_headl= data.frame(tnum_roi_adcfa1000_m_biopsy[,1:4], headerlabel = tnum_roi_adcfa1000_m_biopsy[,h]) 
      colnames(tnum_roi_adcfa1000_m_r_headl)=c(colnames(tnum_roi_adcfa1000_m_r_headl)[1:4], headerlabel)
    }
    else{
      tnum_roi_adcfa1000_m_r_headl= data.frame(tnum_roi_adcfa1000_m_biopsy[,1:4], headerlabel = NA) 
      colnames(tnum_roi_adcfa1000_m_r_headl)=c(colnames(tnum_roi_adcfa1000_m_r_headl)[1:4], headerlabel)
    }
    
    ## here we are binding the data with the previous measurement 
    data = rbind(data, tnum_roi_adcfa1000_m_r_headl)
  }
  y=paste("/home/sf673542/analysis/purest_data/final_to_merge/REC_HGG_diffu_biopsy_", measure, "_", headerlabel, "_", dim(bnum_tnum_df)[1], ".csv", sep="")
  write.table(data, y, row.names=F)
  return(data)
}

#######################################################################################################################################

get_diffu_biopsy_noheader=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/bioe2/REC_HGG/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
    tnum_roi_adcfa1000=read.table(y, sep=",", header=T)
    
    ## here we are going to get the measure block we are looking for 
    tnum_roi_adcfa1000_measure = tnum_roi_adcfa1000[grep(measure, as.character(tnum_roi_adcfa1000$measure)),]
    
    ## here we are going to calculate the number of biopsy just from this data 
    nrow = dim(tnum_roi_adcfa1000_measure)[1]
    
    ## here we are going to extract only the biopsy information rows 
    
    tnum_roi_adcfa1000_measure = data.frame(tnum_roi_adcfa1000_measure, biopsy_binary="0")
    if ("nawm" %in% tnum_roi_adcfa1000_measure$roi.label[1:10]){
      tnum_roi_adcfa1000_m_biopsy = tnum_roi_adcfa1000_measure[12:nrow,]
    }
    else {
      tnum_roi_adcfa1000_m_biopsy = tnum_roi_adcfa1000_measure[11:nrow,]
    }
    
    ## now we have two conditions; either we have just adc, fa, nadc, nfa in the file or we have a lot more parameters; if we have
    ## more parameters, let's cut it down to just these four (since most just have these four) -- maybe later we can edit to include NAs 
    ## where the other parameters are
    ## if number of columns is greater than 9, there are extraneous parameters in the data
    
    if (dim(tnum_roi_adcfa1000_m_biopsy)[2]>9){
      tnum_roi_adcfa1000_m_biopsy_tmp = data.frame(tnum_roi_adcfa1000_m_biopsy[,1:5], adc=tnum_roi_adcfa1000_m_biopsy$adc, fa=tnum_roi_adcfa1000_m_biopsy$fa, nadc= tnum_roi_adcfa1000_m_biopsy$nadc, nfa=tnum_roi_adcfa1000_m_biopsy$nfa)
      tnum_roi_adcfa1000_m_biopsy=tnum_roi_adcfa1000_m_biopsy_tmp
    }
    data = rbind(data, tnum_roi_adcfa1000_m_biopsy)
    
  }
  
  y=paste("/home/sf673542/analysis/purest_data/final_to_merge/REC_HGG_diffu_biopsy_", measure, "_allvalues_", dim(bnum_tnum_df)[1],".csv", sep="")
  write.table(data, y, row.names=F, sep=",")
  return(data)
}
#######################################################################################################################################
get_ev_data=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/bioe2/REC_HGG/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_ev1ev2ev31000.csv", sep="")
    tnum_roi_ev1ev2ev31000=read.table(y, sep=",", header=T)
    
    ## here we are going to get the measure block we are looking for 
    tnum_roi_ev1ev2ev31000_measure = tnum_roi_ev1ev2ev31000[grep(measure, as.character(tnum_roi_ev1ev2ev31000$measure)),]
    
    ## here we are going to calculate the number of biopsy just from this data 
    nrow = dim(tnum_roi_ev1ev2ev31000_measure)[1]
    
    ## here we are going to extract only the biopsy information rows 
    
    tnum_roi_ev1ev2ev31000_measure = data.frame(tnum_roi_ev1ev2ev31000_measure, biopsy_binary="0")
    if ("nawm" %in% tnum_roi_ev1ev2ev31000_measure$roi.label[1:10]){
      tnum_roi_ev1ev2ev31000_m_biopsy = tnum_roi_ev1ev2ev31000_measure[8:nrow,]
    }
    else {
      tnum_roi_ev1ev2ev31000_m_biopsy = tnum_roi_ev1ev2ev31000_measure[7:nrow,]
    }
    

    if (dim(tnum_roi_ev1ev2ev31000_m_biopsy)[2]>13){
      tnum_roi_ev1ev2ev31000_m_biopsy_tmp = data.frame(tnum_roi_ev1ev2ev31000_m_biopsy[,1:5], ev1=tnum_roi_ev1ev2ev31000_m_biopsy$ev1, 
                                                       ev2=tnum_roi_ev1ev2ev31000_m_biopsy$ev2, ev3= tnum_roi_ev1ev2ev31000_m_biopsy$ev3, 
                                                       evrad=tnum_roi_ev1ev2ev31000_m_biopsy$evrad, nev1=tnum_roi_ev1ev2ev31000_m_biopsy$nev1, 
                                                       nev2=tnum_roi_ev1ev2ev31000_m_biopsy$nev2, nev3=tnum_roi_ev1ev2ev31000_m_biopsy$nev3, 
                                                       nevrad=tnum_roi_ev1ev2ev31000_m_biopsy$nevrad)
      tnum_roi_ev1ev2ev31000_m_biopsy=tnum_roi_ev1ev2ev31000_m_biopsy_tmp
    }
    data = rbind(data, tnum_roi_ev1ev2ev31000_m_biopsy)
    
  }
  
  y=paste("/home/sf673542/analysis/purest_data/final_to_merge/REC_HGG_ev_biopsy_", measure, "_allvalues_", dim(bnum_tnum_df)[1],".csv", sep="")
  write.table(data, y, row.names=F, sep=",")
  return(data)
}
