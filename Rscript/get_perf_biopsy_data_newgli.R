
library(dplyr)
## if we have biopsyabel input and we do have headerlabel input, we will use this: 

#######################################################################################################################################

get_perf_biopsy_noheader=function(bnum_tnum_df){
  data = data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    #for(i in c(20,30)){
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("perf_biopsy" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/perf_biopsy", sep=""))
      ## getting the nonlinear fit data 
      curve_nonlin_files=list.files(pattern="curve_nonlinfit.txt")
      if(length(curve_nonlin_files)>0){
        curve_nonlin_files_split = strsplit(curve_nonlin_files, split="_", fixed = FALSE, perl = FALSE, useBytes = FALSE)
        vialid=c()
        data_nonlin=data.frame()
        for(j in 1:length(curve_nonlin_files_split)){
          vialid[j]=curve_nonlin_files_split[[j]][2]
          nonlin_file = paste(bnum_tnum_df$tnum[i], "_", vialid[j], "_ave_curve_nonlinfit.txt", sep = "")
          nonlin_table=read.table(nonlin_file)
          row.names(nonlin_table)=nonlin_table$V1
          nonlin_table=t(nonlin_table)
          nonlin_table=data.frame(bnum=bnum_tnum_df$bnum[i], tnum=bnum_tnum_df$tnum[i],
                                  vialid=vialid[j], nonlin_table)
          data_nonlin=bind_rows(data_nonlin, nonlin_table[2,])
        }
        ## getting the nonparametric data 
        curve_nonparam_files=list.files(pattern="curve_nonparam.txt")
        curve_nonparam_files_split = strsplit(curve_nonparam_files, split="_", fixed = FALSE, perl = FALSE, useBytes = FALSE)
        data_nonparam=data.frame()
        for(j in 1:length(curve_nonparam_files_split)){
          vialid[j]=curve_nonparam_files_split[[j]][2]
          nonparam_file = paste(bnum_tnum_df$tnum[i], "_", vialid[j], "_ave_curve_nonparam.txt", sep = "")
          nonparam_table=read.table(nonparam_file)
          row.names(nonparam_table)=nonparam_table$V1
          nonparam_table=t(nonparam_table)
          #nonparam_table=data.frame(bnum=bnum_tnum_df$bnum[i], tnum=bnum_tnum_df$tnum[i],
          #                       vialid=vialid[j], nonparam_table)
          data_nonparam=bind_rows(data_nonparam, nonparam_table[2,])
        }
        data_i = bind_cols(data_nonlin, data_nonparam)
        colnames(data_i)=c("bnum", "tnum", "vialid",
                           "ph_nonlin", "phn_nonlin",
                           "cbv_nonlin", "cbvn_nonlin",
                           "recov_nonlin", "recovn_nonlin",
                           "rf_nonlin", "rfn_nonlin",
                           "ttp_nonlin", "fwhm_nonlin", "rsquare_nonlin", 
                           ## and the nonparam data: 
                           "ph_nonpar", "phn_nonpar", "pbs_nonpar", 
                           "pbsn_nonpar","recov_nonpar", "recovn_nonpar",
                           "acorr_nonpar")
        data = bind_rows(data, data_i)
      }
      else{
        data=data
      }
      
    }
    else{
      data = data
    }
  }
  return(data)
}

#######################################################################################################################################
#######################################################################################################################################


get_perf_biopsy_withheader=function(bnum_tnum_df, headerlabel){
  data = data.frame()
  for(i in 1:dim(bnum_tnum_df)[1]){
    #   for (i in c(1,20, 21,30)){
    y=paste("/data/NEWglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("perf_biopsy" %in% tnum_files && "roi_analysis" %in% tnum_files){
      setwd(paste(y, "/perf_biopsy", sep=""))
      ## getting the nonlinear fit data 
      curve_nonlin_files=list.files(pattern="curve_nonlinfit.txt")
      if(length(curve_nonlin_files)>0){
        curve_nonlin_files_split = strsplit(curve_nonlin_files, split="_", fixed = FALSE, perl = FALSE, useBytes = FALSE)
        vialid=c()
        data_nonlin=data.frame()
        for(j in 1:length(curve_nonlin_files_split)){
          vialid[j]=curve_nonlin_files_split[[j]][2]
          nonlin_file = paste(bnum_tnum_df$tnum[i], "_", vialid[j], "_ave_curve_nonlinfit.txt", sep = "")
          nonlin_table=read.table(nonlin_file)
          row.names(nonlin_table)=nonlin_table$V1
          nonlin_table=t(nonlin_table)
          nonlin_table=data.frame(bnum=bnum_tnum_df$bnum[i], tnum=bnum_tnum_df$tnum[i],
                                  vialid=vialid[j], nonlin_table)
          data_nonlin=bind_rows(data_nonlin, nonlin_table[2,])
        }
        ## getting the nonparametric data 
        curve_nonparam_files=list.files(pattern="curve_nonparam.txt")
        curve_nonparam_files_split = strsplit(curve_nonparam_files, split="_", fixed = FALSE, perl = FALSE, useBytes = FALSE)
        data_nonparam=data.frame()
        for(j in 1:length(curve_nonparam_files_split)){
          vialid[j]=curve_nonparam_files_split[[j]][2]
          nonparam_file = paste(bnum_tnum_df$tnum[i], "_", vialid[j], "_ave_curve_nonparam.txt", sep = "")
          nonparam_table=read.table(nonparam_file)
          row.names(nonparam_table)=nonparam_table$V1
          nonparam_table=t(nonparam_table)
          #nonparam_table=data.frame(bnum=bnum_tnum_df$bnum[i], tnum=bnum_tnum_df$tnum[i],
          #                       vialid=vialid[j], nonparam_table)
          data_nonparam=bind_rows(data_nonparam, nonparam_table[2,])
        }
        data_i = bind_cols(data_nonlin, data_nonparam)
        colnames(data_i)=c("bnum", "tnum", "vialid",
                           "ph_nonlin", "phn_nonlin",
                           "cbv_nonlin", "cbvn_nonlin",
                           "recov_nonlin", "recovn_nonlin",
                           "rf_nonlin", "rfn_nonlin",
                           "ttp_nonlin", "fwhm_nonlin", "rsquare_nonlin", 
                           ## and the nonparam data: 
                           "ph_nonpar", "phn_nonpar", "pbs_nonpar", 
                           "pbsn_nonpar","recov_nonpar", "recovn_nonpar",
                           "acorr_nonpar")
        data = bind_rows(data, data_i)
        if(headerlabel %in% colnames(data)){
          exactheaderlabel=paste("^", headerlabel,"$", sep="")
          h=grep(exactheaderlabel, colnames(data))
          data_headl= data.frame(data[,1:3], headerlabel = data[,h]) 
          colnames(data_headl)=c(colnames(data_headl)[1:3], headerlabel)
          data=data_headl
        }
        else{
          data = data.frame(data[,1:3], headerlabel = NA) 
          colnames(data)=c(colnames(data)[1:3], headerlabel)
        }
      }
      else{
        data=data
      }
    }
    else{
      data = data
      print(i)
    }
    return(data)
  }
}

#######################################################################################################################################
#######################################################################################################################################

get_perf_biopsy = function(bnum_tnum_df, headerlabel){
  if(is.na(headerlabel)){
    ## want to create the data frame like this 
    get_perf_biopsy_noheader(bnum_tnum_df)
  }
  else{
    print("Sorry, functionality of with_header will be added soon.")
    print("Please use no header and gather all data.")
    #get_perf_biopsy_withheader(bnum_tnum_df, headerlabel)
  }
}
