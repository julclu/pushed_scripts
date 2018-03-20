
library(dplyr)
## if we have biopsyabel input and we do have headerlabel input, we will use this: 
get_perf_biopsy_withheader=function(bnum_tnum_df, measure, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
   ## here we're going to read the text file for perfusion 
    y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("perf_biopsy" %in% tnum_files && "roi_analysis" %in% tnum_files){
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
