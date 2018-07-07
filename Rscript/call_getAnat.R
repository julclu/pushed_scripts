#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
source("/home/sf673542/pushed_scripts/Rscript/get_anat_biopsy_data_server.R")
source("/home/sf673542/pushed_scripts/Rscript/get_anat_biopsy_data_newgli.R")

## want this script to be take in arguments 
## [1] /pathtobnumtnum/bnumtnum.txt 
## [2] /pathtooutput/outputfilename.txt 
## [3] measure = median, percent25, percent75, mean, sd, min, max, percent10, percent90, mode, skewness, kurtosis, sum 
## [4] optional, headerlabel = vol(cc),fse,fl,t1v,t1c,t1d,nfse,nfl,nt1v,nt1c,nt1d
## [5] optional, use NEWglioma instead of RECglioma

# test if there is at least one argument: if not, return an error
if (length(args)<=2) {
  stop("At least 3 arguments must be supplied: 
       [1] /pathtobnumtnum/bnumtnum.csv
       [2] /pathtooutput/outputfilename.csv 
       [3] measure = median, percent25, percent75, mean, sd, min, max, percent10, percent90, mode, skewness, kurtosis, sum
       [4] optional, headerlabel = vol(cc),fse,fl,t1v,t1c,t1d,nfse,nfl,nt1v,nt1c,nt1d
       [5] optional, NEWglioma", call.=FALSE)
} else if (length(args)==3) {
  # default output file
  args[4] = NA
  args[5] = NA
  bnum_tnum_df = read.csv(args[1], header=F)
  colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
  data = get_anat_biopsy(bnum_tnum_df, measure= args[3], headerlabel=args[4])
  write.table(data, args[2], sep=",")
} else if (length(args)==4) {
  if(args[4]=="NEWglioma"){
    bnum_tnum_df = read.csv(args[1], header=F)
    colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
    data = get_anat_biopsy_newgli(bnum_tnum_df, measure= args[3], headerlabel=NA)
    write.table(data, args[2], sep=",", row.names=F)
  }
  else{
    bnum_tnum_df = read.csv(args[1], header=F)
    colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
    data = get_anat_biopsy(bnum_tnum_df, measure= args[3], headerlabel=args[4])
    write.table(data, args[2], sep=",", row.names=F)
  }
}


#require(devtools)
#require("getopt", quietly=TRUE)
#spec = matrix(c(
#  "scanlist", "s", 1, "string", 
#  "output", "o", 1, "string", 
#  "measure", "m", 1, "string",
#  "headerlabel", "h", 2, "string", 
#  "rootdir", "r", 2, "string"
##), byrow=TRUE, ncol=4)
#opt = getopt(spec)

#if (is.null(opt$scanlist)){
#  stop("Path to scanlist, plus valid scanlist must be supplied.")
#} else {
#  s <- opt$scanlist
#}
#if (is.null(opt$output)){
#  stop("Path to output must be supplied.")
#} else {
#  o = opt$output
#}
#if (is.null(opt$measure)){
#  stop("Measure you are looking for must be supplied, e.g. 'median'")
#} else {
#  m = opt$measure
#}
#if (is.null(opt$headerlabel)){
#  h = NA
#} else {
 # h = opt$headerlabel
#}
#if (is.null(opt$rootdir)){
#  r = "RECglioma"
#} else {
#  r = opt$rootdir
#}


#bnum_tnum_df = read.csv(s, header=F)
#colnames(bnum_tnum_df)=c("bnum", "tnum", "DUMMY")
#if(r == "RECglioma"){
#  data = get_anat_biopsy(bnum_tnum_df, measure= m, headerlabel=h)
#} else{
#  data = get_anat_biopsy_newgli(bnum_tnum_df, measure= m, headerlabel=h)
#}
