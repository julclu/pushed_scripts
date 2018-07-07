#get_spec_data_server.R

library(dplyr)
#######################################################################################################################################
get_spec_biopsy_noheader_newgli=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_csv_files=list.files(pattern="csv")
      spec_single_csv = paste(bnum_tnum_df$tnum[i],  "_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.csv", sep="")
      spec_lac_csv = paste(bnum_tnum_df$tnum[i],  "_lac_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.csv", sep="")
      
      if (spec_single_csv %in% svk_csv_files){
        spec_csv = spec_single_csv
        tnum_sfbens=read.table(spec_csv, sep=",", header=T)
        ## here we are going to get the measure block we are looking for 
        tnum_sfbens_measure = tnum_sfbens[grep(measure, as.character(tnum_sfbens$measure)),]
        ## here we are going to calculate the number of biopsy just from this data 
        nrow = dim(tnum_sfbens_measure)[1]
        ## here we are going to extract only the biopsy information rows 
        if ("nawm" %in% tnum_sfbens_measure$roi.label){
          tnum_sfbens_m_biopsy = tnum_sfbens_measure[16:nrow,]
        }
        else {
          tnum_sfbens_m_biopsy = tnum_sfbens_measure[15:nrow,]
        }
        data = rbind(data, tnum_sfbens_m_biopsy)
      }
      else if(spec_lac_csv %in% svk_csv_files ){
        spec_csv = spec_lac_csv
        tnum_sfbens=read.table(spec_csv, sep=",", header=T)
        ## here we are going to get the measure block we are looking for 
        tnum_sfbens_measure = tnum_sfbens[grep(measure, as.character(tnum_sfbens$measure)),]
        ## here we are going to calculate the number of biopsy just from this data 
        nrow = dim(tnum_sfbens_measure)[1]
        ## here we are going to extract only the biopsy information rows 
        if ("nawm" %in% tnum_sfbens_measure$roi.label){
          tnum_sfbens_m_biopsy = tnum_sfbens_measure[16:nrow,]
        }
        else {
          tnum_sfbens_m_biopsy = tnum_sfbens_measure[15:nrow,]
        }
        data = rbind(data, tnum_sfbens_m_biopsy)
        
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

##############################################################################################################################


get_spec_biopsy_withheader_newgli=function(bnum_tnum_df, measure, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_csv_files=list.files(pattern="csv")
      spec_csv = paste(bnum_tnum_df$tnum[i],  "_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.csv", sep="")
      if (spec_csv %in% svk_csv_files){
        tnum_sfbens=read.table(spec_csv, sep=",", header=T)
        ## here we are going to get the measure block we are looking for 
        tnum_sfbens_measure = tnum_sfbens[grep(measure, as.character(tnum_sfbens$measure)),]
        ## here we are going to calculate the number of biopsy just from this data 
        nrow = dim(tnum_sfbens_measure)[1]
        ## here we are going to extract only the biopsy information rows 
        if ("nawm" %in% tnum_sfbens_measure$roi.label){
          tnum_sfbens_m_biopsy = tnum_sfbens_measure[16:nrow,]
        }
        else {
          tnum_sfbens_m_biopsy = tnum_sfbens_measure[15:nrow,]
        }
        ## and here we are getting the specific header measurement
        ## we have two possible conditions; the header we're looking for exists or doesn't exist in the header (e.g. fse might not be present)
        if(headerlabel %in% colnames(tnum_sfbens_m_biopsy)){
          exactheaderlabel=paste("^", headerlabel,"$", sep="")
          h=grep(exactheaderlabel, colnames(tnum_sfbens_m_biopsy))
          tnum_sfbens_m_r_headl= data.frame(tnum_sfbens_m_biopsy[,1:4], headerlabel = tnum_sfbens_m_biopsy[,h]) 
          colnames(tnum_sfbens_m_r_headl)=c(colnames(tnum_sfbens_m_r_headl)[1:4], headerlabel)
        }
        else{
          tnum_sfbens_m_r_headl= data.frame(tnum_sfbens_m_biopsy[,1:4], headerlabel = NA) 
          colnames(tnum_sfbens_m_r_headl)=c(colnames(tnum_sfbens_m_r_headl)[1:4], headerlabel)
        }
        
        data = rbind(data, tnum_sfbens_m_r_headl)
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

##############################################################################################################################

get_spec_biopsy_newgli = function(bnum_tnum_df, measure, headerlabel){
  if(is.na(headerlabel)){
    ## want to create the data frame like this 
    get_spec_biopsy_noheader_newgli(bnum_tnum_df, measure)
  }
  else{
    get_spec_biopsy_withheader_newgli(bnum_tnum_df, measure, headerlabel)
  }
}

