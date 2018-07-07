#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)


if (length(args)<=2) {
  stop("At least 3 arguments must be supplied: 
       [1] mandatory: /pathtobnumtnum/bnumtnum.csv
       [2] mandatory: /pathtooutput/outputfilename.csv 
       [3] mandatory: measure = median, percent25, percent75, mean, sd, min, max, percent10, percent90, mode, skewness, kurtosis, sum
       [5] optional, headerlabel = vol.cc.,adc,fa, nadc, nfa
       [6] optional, datatype= adcfa, ev
       note: if you choose datatype = ev, you cannot call headerlabel.
       ", call.=FALSE)
} else if (length(args)==3) {
  # default output file
  args[4] = NA
  args[5] = NA
}

source("/home/sf673542/pushed_scripts/Rscript/get_diffu1000_biopsy_newgli.R")

#if (args[4] == "NEWglioma"){
#  bnum_tnum_df = read.csv(args[1], header=F)
#  colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
#  data = get_diffu1000_biopsy_newgli(bnum_tnum_df, measure= args[3], headerlabel=args[5], datatype=args[6])
#  write.table(data, args[2], sep=",")
#} else{
#  bnum_tnum_df = read.csv(args[1], header=F)
#  colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
#  data = get_diffu1000_biopsy(bnum_tnum_df, measure= args[3], headerlabel=args[4], datatype=args[5])
#  write.table(data, args[2], sep=",")
#}

bnum_tnum_df = read.csv(args[1], header=F)
colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
data = get_diffu1000_biopsy_newgli(bnum_tnum_df, measure= args[3], headerlabel=args[4], datatype=args[5])
write.table(data, args[2], sep=",", row.names=F)
