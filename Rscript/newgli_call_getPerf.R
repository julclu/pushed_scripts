#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

## want this script to be take in arguments 
## [1] /pathtobnumtnum/bnumtnum.txt 
## [2] /pathtooutput/outputfilename.txt 
## [3] measure = median, percent25, percent75, mean, sd, min, max, percent10, percent90, mode, skewness, kurtosis, sum 
## [4] optional, headerlabel = vol(cc),adc,fa, nadc, nfa

# test if there is at least one argument: if not, return an error
if (length(args)<=1) {
  stop("At least 2 arguments must be supplied: 
       [1] /pathtobnumtnum/bnumtnum.csv
       [2] /pathtooutput/outputfilename.csv 
       [3] optional, headerlabel = ph_nonlin, phn_nonlin... etc. functionality to be added soon.
       note: if you choose datatype = ev, you cannot call headerlabel.", call.=FALSE)
} else if (length(args)==2) {
  # default output file
  args[3] = NA
}

source("/home/sf673542/pushed_scripts/Rscript/get_perf_biopsy_data_newgli.R")
bnum_tnum_df = read.csv(args[1], header=F)
colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
data = get_perf_biopsy(bnum_tnum_df, headerlabel=args[4])
write.table(data, args[2], sep=",")


