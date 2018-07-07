## ## get anatomical biopsy data -- server 

## in this script i will write something that will take as input the bnum_tnum_df and find the biopsy data 
library(dplyr)
## we don't need an roilabel since we are only extracting biopsies
get_anat_biopsy_withheader_newgli=function(bnum_tnum_df, measure, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    
    ## here we are reading in the csv file from the first element in bnum_tnum_df 
    #y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", bnum_tnum_df$tnum[i],  "_roi_flt1cfse.csv", sep="")
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    ## here we are going to check if svk_roi_analysis exists, and only if so will we find out if the .csv file we're looking for also exists
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_files=list.files(pattern="csv")
      anat_csv = paste(bnum_tnum_df$tnum[i],  "_roi_flt1cfse.csv", sep="")
      ## only if the csv we're looking for exists do we move forward with extracting the data 
      if (anat_csv %in% svk_files){
        tnum_roi_flt1cfse=read.table(anat_csv, sep=",", header=T)
        ## here we are going to get the measure block we are looking for 
        tnum_roi_flt1cfse_measure = tnum_roi_flt1cfse[grep(measure, as.character(tnum_roi_flt1cfse$measure)),]
        ## here we are going to calculate the number of biopsies just from this data 
        nrow = dim(tnum_roi_flt1cfse_measure)[1]
        ## here we are going to extract only the biopsy information rows 
        tnum_roi_flt1cfse_measure = data.frame(tnum_roi_flt1cfse_measure)
        if ("nawm" %in% tnum_roi_flt1cfse_measure$roi.label[1:10]){
          tnum_roi_flt1cfse_m_biopsies = tnum_roi_flt1cfse_measure[12:nrow,]
        }
        else {
          tnum_roi_flt1cfse_m_biopsies = tnum_roi_flt1cfse_measure[11:nrow,]
        }
        
        ## and here we are getting the specific header measurement
        ## we have two possible conditions; the header we're looking for exists or doesn't exist in the header (e.g. fse might not be present)
        if(headerlabel %in% colnames(tnum_roi_flt1cfse_m_biopsies)){
          exactheaderlabel=paste("^", headerlabel,"$", sep="")
          h=grep(exactheaderlabel, colnames(tnum_roi_flt1cfse_m_biopsies))
          tnum_roi_flt1cfse_m_r_headl= data.frame(tnum_roi_flt1cfse_m_biopsies[,1:4], headerlabel = tnum_roi_flt1cfse_m_biopsies[,h]) 
          colnames(tnum_roi_flt1cfse_m_r_headl)=c(colnames(tnum_roi_flt1cfse_m_r_headl)[1:4], headerlabel)
        }
        else{
          tnum_roi_flt1cfse_m_r_headl= data.frame(tnum_roi_flt1cfse_m_biopsies[,1:4], headerlabel = NA) 
          colnames(tnum_roi_flt1cfse_m_r_headl)=c(colnames(tnum_roi_flt1cfse_m_r_headl)[1:4], headerlabel)
        }
        ## here we are binding the data with the previous measurement 
        data = rbind(data, tnum_roi_flt1cfse_m_r_headl)
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

## NOTES: 
## bnum_tnum_df must be read in as bnum_tnum_df, must have colnames bnum and tnum at least 
## options for measure: median, percent25, percent75, mean, sd, min, max, kurtosis, mode, percent10, percent90, skewness, sum 
## options for headerlabel: vol.cc.      fse       fl      t1v      t1c       t1d    nfse     nfl    nt1v    nt1c    nt1d


get_anat_biopsy_noheader_newgli=function(bnum_tnum_df, measure){
  #=data.frame(colnames=c("tab.file","t.num measure","roi.label","vol.cc.","fse","fl","t1v","t1c","t1d", "nfse","nfl","nt1v", "nt1c","nt1d"))
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    #y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i],"/svk_roi_analysis/",bnum_tnum_df$tnum[i],  "_roi_flt1cfse.csv", sep="")
    if ("svk_roi_analysis" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_files=list.files(pattern="csv")
      anat_csv = paste(bnum_tnum_df$tnum[i],  "_roi_flt1cfse.csv", sep="")
      if(anat_csv %in% svk_files){
        tnum_roi_flt1cfse=read.table(anat_csv, sep=",", header=T)
        
        ## here we are going to get the measure block we are looking for 
        tnum_roi_flt1cfse_measure = tnum_roi_flt1cfse[grep(measure, as.character(tnum_roi_flt1cfse$measure)),]
        
        ## here we are going to calculate the number of biopsies just from this data 
        nrow = dim(tnum_roi_flt1cfse_measure)[1]
        
        ## here we are going to extract only the biopsy information rows 
        if ("nawm" %in% tnum_roi_flt1cfse_measure$roi.label[1:10]){
          tnum_roi_flt1cfse_m_biopsies = tnum_roi_flt1cfse_measure[12:nrow,]
        }
        else {
          tnum_roi_flt1cfse_m_biopsies = tnum_roi_flt1cfse_measure[11:nrow,]
        }
        
        ## now we have two conditions; either fse was in the table or it wasn't (I think), so we have two missing columns (fse and nfse) occasionally
        ## if this is the case, then we need to have two separate conditions 
        
        #    if ( 'fse' %in% colnames(tnum_roi_flt1cfse_measure)){
        #      data = rbind(data, tnum_roi_flt1cfse_m_biopsies)
        #    }
        #    else {
        #      tnum_roi_flt1cfse_m_biopsies= data.frame(tnum_roi_flt1cfse_m_biopsies[,1:5], fse=NA, tnum_roi_flt1cfse_m_biopsies[,6:9], nfse=NA, tnum_roi_flt1cfse_m_biopsies[,10:dim(tnum_roi_flt1cfse_m_biopsies)[2]])
        #      data = rbind(data, tnum_roi_flt1cfse_m_biopsies)
        #    }
        data = bind_rows(data, tnum_roi_flt1cfse_m_biopsies)
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

get_anat_biopsy_newgli = function(bnum_tnum_df, measure, headerlabel){
  if(is.na(headerlabel)){
    ## want to create the data frame like this 
    get_anat_biopsy_noheader_newgli(bnum_tnum_df, measure)
  }
  else{
    get_anat_biopsy_withheader_newgli(bnum_tnum_df, measure, headerlabel)
  }
}