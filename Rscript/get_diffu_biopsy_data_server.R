## get diffusion biopsy data -- server 
library(dplyr)
## if we have biopsyabel input and we do have headerlabel input, we will use this: 
get_diffu1000_biopsy_withheader=function(bnum_tnum_df, measure, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    ## here we are reading in the csv file from the first element in bnum_tnum_df 
    #y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
    y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_files=list.files(pattern="csv")
      diffu_csv = paste(bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
      ## only if the csv we're looking for exists do we move forward with extracting the data 
      if (diffu_csv %in% svk_files){
        tnum_roi_adcfa1000=read.table(diffu_csv, sep=",", header=T)
        
        ## here we are going to get the measure block we are looking for 
        tnum_roi_adcfa1000_measure = tnum_roi_adcfa1000[grep(measure, as.character(tnum_roi_adcfa1000$measure)),]
        
        ## here we are going to calculate the number of biopsy just from this data 
        nrow = dim(tnum_roi_adcfa1000_measure)[1]
        
        ## here we are going to extract only the biopsy information rows 
        
        tnum_roi_adcfa1000_measure = data.frame(tnum_roi_adcfa1000_measure)
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
      else{
        data=data
      }
    }
    else{
      data=data
    }
    
  }
  return(data)
}

#######################################################################################################################################

get_diffu1000_biopsy_noheader=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    #y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
    #tnum_roi_adcfa1000=read.table(y, sep=",", header=T)
    y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_files=list.files(pattern="csv")
      diffu_csv = paste(bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
      ## only if the csv we're looking for exists do we move forward with extracting the data 
      if (diffu_csv %in% svk_files){
        tnum_roi_adcfa1000=read.table(diffu_csv, sep=",", header=T)
        ## here we are going to get the measure block we are looking for 
        tnum_roi_adcfa1000_measure = tnum_roi_adcfa1000[grep(measure, as.character(tnum_roi_adcfa1000$measure)),]
        
        ## here we are going to calculate the number of biopsy just from this data 
        nrow = dim(tnum_roi_adcfa1000_measure)[1]
        
        ## here we are going to extract only the biopsy information rows 
        
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
        data = bind_rows(data, tnum_roi_adcfa1000_m_biopsy)
      }
      else{
        data = data
      }
    }
    else{
      data = data 
    }
    
    
  }
  return(data)
}
#######################################################################################################################################
get_ev1000_biopsy_noheader=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    #y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_ev1ev2ev31000.csv", sep="")
    y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_files=list.files(pattern="csv")
      ev_csv = paste(bnum_tnum_df$tnum[i],  "_roi_ev1ev2ev31000.csv", sep="")
      if (ev_csv %in% svk_files){
        tnum_roi_ev1ev2ev31000=read.table(ev_csv, sep=",", header=T)
        
        ## here we are going to get the measure block we are looking for 
        tnum_roi_ev1ev2ev31000_measure = tnum_roi_ev1ev2ev31000[grep(measure, as.character(tnum_roi_ev1ev2ev31000$measure)),]
        
        ## here we are going to calculate the number of biopsy just from this data 
        nrow = dim(tnum_roi_ev1ev2ev31000_measure)[1]
        
        ## here we are going to extract only the biopsy information rows 
        
        tnum_roi_ev1ev2ev31000_measure = data.frame(tnum_roi_ev1ev2ev31000_measure)
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
      else{
        data = data
      }
    }
    else{
      data = data
    }
  }
  return(data)
}

## here I want to create a function where if you specify datatype = adcfa or ev, you can choose either to get one or the other; 
## however, if you want both types of information, you can set datatype to "all" and retrieve all of it 
get_diffu_biopsy = function(bnum_tnum_df, measure, headerlabel, datatype){
  if(is.na(headerlabel) && datatype == "adcfa"){
    ## want to create the data frame like this 
    get_diffu_biopsy_noheader(bnum_tnum_df, measure)
  }
  else if (is.na(headerlabel) && datatype == "ev"){
    get_ev_biopsy_noheader(bnum_tnum_df, measure)
  }
  else if (!is.na(headerlabel) && datatype == "ev"){
    print("Please set headerlabel =NA and then proceed.")
  }
  else if (!is.na(headerlabel) && datatype == "adcfa"){
    get_diffu_biopsy_withheader(bnum_tnum_df, measure, headerlabel)
  }
  else if (is.na(headerlabel) && datatype == "all"){
    diffu_data = get_diffu_biopsy_noheader(bnum_tnum_df, measure)
    ev_data = get_ev_biopsy_noheader(bnum_tnum_df, measure)
    data = bind_cols(diffu_data, ev_data, by="")
  }
}
