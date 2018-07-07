## here we want to clean data ... will make a separate script called call_clean_data that uses directory as input containing all files to clean? 

########## to delete, but for munging purposes: 
setwd("~/Box Sync/lupo/analysis/new_hgg/")
anat = read.csv("results.call_anat.042618.csv")
diffu1000 = read.csv("results.call_diffu1000.042618.csv")
diffu2000 = read.csv("results.call_diffu2000.050818.csv")
perf = read.csv("results.call_perf.043018.csv")
spec = read.csv("results.call_spec.043018.csv")

colnames(anat)
anat_impt = anat[,-c(1,3,5)]
colnames(anat_impt)= c("tnum_anat", colnames(anat_impt)[2:length(colnames(anat_impt))])

colnames(diffu1000_impt)
diffu1000_impt = diffu1000[,-c(1,3,5)]
colnames(diffu1000_impt)=c(paste(colnames(diffu1000_impt)[1], ".1", sep = ""), colnames(diffu1000_impt)[2], paste(colnames(diffu1000_impt)[3:length(colnames(diffu1000_impt))], ".1", sep = ""))

diffu2000_impt = diffu2000[,-c(1,3,5)]
colnames(diffu2000_impt)=c(paste(colnames(diffu2000_impt)[1], ".2", sep = ""), colnames(diffu2000_impt)[2], paste(colnames(diffu2000_impt)[3:length(colnames(diffu2000_impt))], ".2", sep = ""))

perf_impt = perf[,c(1:3,5,7,16,19)]
colnames(perf_impt) = c("bnum_perf", "tnum_perf", "roi.label", "phn_nlin", "cbvn_nlin", "phn_npar", "recov_npar")

spec_impt = spec[,-c(1,3,5,14:16, 22:24)]
colnames(spec_impt)=c("tnum_spec", colnames(spec_impt)[2:length(colnames(spec_impt))])

ad1 = full_join(anat_impt, diffu1000_impt, by = "roi.label")
View(ad1)
ad1d2 = full_join(ad1, diffu2000_impt, by = "roi.label")
View(ad1d2)

adp = full_join(ad1d2, perf_impt, by="roi.label")
View(adp)
adps = full_join(adp, spec_impt, by="roi.label")
View(adps)

