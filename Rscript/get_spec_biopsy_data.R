#get_spec_data_server.R


#######################################################################################################################################

get_spec_biopsy_noheader=function(bnum_tnum_df, measure){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/bioe2/REC_HGG/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], "/svk_roi_analysis/", sep="")
    setwd(y)
    filenames = Sys.glob("*.csv")
    z = filenames[grep("empcsahl_normxs_sinc.csv", filenames)]
    print(i)
    print(z)
    tnum_sfbens=read.table(z, sep=",", header=T)
    
    ## here we are going to get the measure block we are looking for 
    tnum_sfbens_measure = tnum_sfbens[grep(measure, as.character(tnum_sfbens$measure)),]
    
    ## here we are going to calculate the number of biopsy just from this data 
    nrow = dim(tnum_sfbens_measure)[1]
    
    ## here we are going to extract only the biopsy information rows 
    
    tnum_sfbens_measure = data.frame(tnum_sfbens_measure, biopsy_binary="0")
    if ("nawm" %in% tnum_sfbens_measure$roi.label){
      tnum_sfbens_m_biopsy = tnum_sfbens_measure[16:nrow,]
    }
    else {
      tnum_sfbens_m_biopsy = tnum_sfbens_measure[15:nrow,]
    }
    
    data = rbind(data, tnum_sfbens_m_biopsy)
  }
  y=paste("/home/sf673542/analysis/purest_data/final_to_merge/REC_HGG_spec_", measure, "_noheader_", dim(bnum_tnum_df)[1], ".csv", sep="")
  write.table(data, y, row.names=F, sep=",")
  return(data)
}

##############################################################################################################################


roi_header_spec=function(bnum_tnum_df, measure, biopsyabel, headerlabel){
  data=data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    
    ## here we are reading in the csv file from the first element in bnum_tnum_df 
    y=paste("/data/bioe2/REC_HGG/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i],"/svk_roi_analysis/",bnum_tnum_df$tnum[i],  "_single_fbhsvdfcomb_biopsy_empcsahl_normxs_sinc.csv", sep="")
    
    tnum_sfbens=read.table(y, sep=",", header=T)
    
    ## here we are going to get the measure block we are looking for 
    tnum_sfbens_measure = tnum_sfbens[grep(measure, as.character(tnum_sfbens$measure)),]
    
    ## here we are going to get the biopsyabel row 
    tnum_sfbens_m_biopsy= tnum_sfbens_measure[grep(biopsyabel, as.character(tnum_sfbens_measure$roi.label)),]
    
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
    
    ## here we are binding the data with the previous measurement 
    data = rbind(data, tnum_sfbens_m_r_headl)
  }
  y=paste("/home/sf673542/working/analysis/REC_HGG_spec_", measure, "_", headerlabel, "_", dim(bnum_tnum_df)[1], ".csv", sep="")
  
  write.table(data, y, row.names=F)
  return(data)
}
