#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

## want this script to be take in arguments 
## [1] /pathtobnumtnum/bnumtnum.txt 
## [2] /pathtooutput/outputfilename.txt 
## [3] measure = median, percent25, percent75, mean, sd, min, max, percent10, percent90, mode, skewness, kurtosis, sum 
## [4] optional, headerlabel = vol(cc),fse,fl,t1v,t1c,t1d,nfse,nfl,nt1v,nt1c,nt1d

# test if there is at least one argument: if not, return an error
if (length(args)<=2) {
  stop("At least 3 arguments must be supplied: 
       [1] /pathtobnumtnum/bnumtnum.csv
       [2] /pathtooutput/outputfilename.csv 
       [3] measure = median, percent25, percent75, mean, sd, min, max, percent10, percent90, mode, skewness, kurtosis, sum
       [4] optional, headerlabel = vol(cc),cho, cre, naa, lip, lac, cni, ccri, crni, xsch, xscc, 
           xscr, ncho, ncre, nnaa, nlip, nlac, nxsch, nxscc, nxscr.", call.=FALSE)
} else if (length(args)==3) {
  # default output file
  args[4] = NA
}

source("/home/sf673542/pushed_scripts/Rscript/get_spec_biopsy_data_newgli.R")

bnum_tnum_df = read.csv(args[1], header=F)
colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
data = get_spec_biopsy_newgli(bnum_tnum_df, measure= args[3], headerlabel=args[4])
write.table(data, args[2], sep=",")
