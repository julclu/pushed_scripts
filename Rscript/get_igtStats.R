library(dplyr)

#######################################################################################################################################
get_igt_stats=function(bnum_tnum_df){
  data=data.frame(tnum = NA, sfnum = NA, vialID = NA, index = NA, 
                  X.CEL = NA, X.NEL = NA, X.NEC = NA)
  failure_report = c()
  for(i in 1:dim(bnum_tnum_df)[1]){
    y=paste("/data/RECglioma/", bnum_tnum_df$bnum[i], "/", bnum_tnum_df$tnum[i], sep="")
    tnum_files = list.files(y)
    if ("svk_roi_analysis" %in% tnum_files){
      setwd(paste(y, "/svk_roi_analysis", sep=""))
      svk_csv_files=list.files(pattern="csv")
      igt_stat_csv = paste(bnum_tnum_df$tnum[i], "_igtstats.csv", sep="")
      if (igt_stat_csv %in% svk_csv_files){
        igt_stats = read.csv(igt_stat_csv)
        if((dim(igt_stats)[1]==1 & dim(igt_stats)[2]==1)
           | dim(igt_stats)[1]>5){
          data = data
          print(paste(bnum_tnum_df$bnum[i], bnum_tnum_df$tnum[i], "igt_stats_failure", sep="_"))
        } else{
          igt_stats = igt_stats[,1:7]
          colnames(igt_stats)=c("tnum","sfnum","vialID","index","X.CEL","X.NEL","X.NEC")
          data = rbind(data, igt_stats)
          print(paste(bnum_tnum_df$bnum[i], bnum_tnum_df$tnum[i], "success", sep="_"))
        }
      } else{
        data=data
        print(paste(bnum_tnum_df$bnum[i], bnum_tnum_df$tnum[i], "failure b/c igt_stat file not in svk_roi_analysis", sep = "_"))
      }
    } else{
      data=data
      print(paste(bnum_tnum_df$bnum[i], bnum_tnum_df$tnum[i], "failure b/c no svk_roi_analysis folder", sep = "_"))
    }
  }
  return(data)
}


#######################################################################################################################################

