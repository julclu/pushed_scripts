#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)<2) {
  stop("At least 2 arguments must be supplied: 
       [1] mandatory: /pathtobnumtnum/bnumtnum.csv
       [2] mandatory: /pathtooutput/outputfilename.csv 
       ", call.=FALSE)
}
source("/home/sf673542/pushed_scripts/Rscript/oldgli_get_igtStats.R")
bnum_tnum_df = read.csv(args[1], header=F)
colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
data = get_igt_stats(bnum_tnum_df)
write.table(data, args[2], sep=",", row.names=F)