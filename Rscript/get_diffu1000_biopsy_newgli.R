## get diffusion biopsy data -- server 
library(dplyr)
## if we have biopsyabel input and we do have headerlabel input, we will use this: 
get_diffu1000_biopsy_withheader_newgli=function(bnum_tnum_df, measure, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    ## here we are reading in the csv file from the first element in bnum_tnum_df 
    #y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
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

get_diffu1000_biopsy_noheader_newgli=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    #y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_adcfa1000.csv", sep="")
    #tnum_roi_adcfa1000=read.table(y, sep=",", header=T)
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
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
get_ev1000_biopsy_noheader_newgli=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    #y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_ev1ev2ev31000.csv", sep="")
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
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
get_diffu1000_biopsy_newgli = function(bnum_tnum_df, measure, headerlabel=NULL, datatype=NULL){
  ## only want all of adcfa data 
  if(is.null(headerlabel)){
    headerlabel=NA
  }
  if(is.null(datatype)){
    datatype=NA
  }
  if(is.na(headerlabel) && !is.na(datatype)){
    if(datatype == "adcfa"){
      get_diffu1000_biopsy_noheader_newgli(bnum_tnum_df, measure)
    }
    else{
      get_ev1000_biopsy_noheader_newgli(bnum_tnum_df, measure)
    }
  }
  ## want only specific headerlabel of ev 
  else if (!is.na(headerlabel) && is.na(datatype)){
    print("You have specified a headerlabel without a datatype, ev or adcfa.")
    print("Please enter a specific adcfa headerlabel, with datatype='adcfa', or if looking for ev data,")
    print("please use datatype='ev', and get all ev data, then use downstream analysis for the ev of interest.")
  }
  ## want only specific headerlabel for adcfa
  else if (!is.na(headerlabel) && datatype == "adcfa"){
    get_diffu1000_biopsy_withheader_newgli(bnum_tnum_df, measure, headerlabel)
  }
  ## want all the adcfa and all of the ev data 
  else if (is.na(headerlabel) && is.na(datatype)){
    data_adcfa = get_diffu1000_biopsy_noheader_newgli(bnum_tnum_df, measure)
    data_ev = get_ev1000_biopsy_noheader_newgli(bnum_tnum_df, measure) 
    data = full_join(data_adcfa, data_ev, by="roi.label")
    data_new = data.frame(tab.file = paste(as.character(data$tab.file.x), as.character(data$tab.file.y), sep = "&"), 
                          t.num.adcfa = data$t.num.x, t.num.ev = data$t.num.y, roi.label=data$roi.label,
                          measure=as.character(measure), adc = data$adc, fa = data$fa, nadc=data$nadc, 
                          nfa = data$nfa, ev1=data$ev1, ev2=data$ev2, ev3=data$ev3, evrad=data$evrad, nev1=data$nev1, 
                          nev2=data$nev2, nev3=data$nev3, nevrad=data$nevrad)
    return(data_new)
  }
  else{
    print("Please select headerlabel from the following: adc, nadc, fa, nfa")
    print("Or please select datatype from the following: ev, adcfa")
  }
}