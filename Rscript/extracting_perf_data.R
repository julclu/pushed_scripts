## first i want to read in the bnum/tnum/vialID dataframe that can be used to extract the data 
setwd("~/Box Sync/lupo/analysis/purest_data/")
withvialid=read.csv("perfusion/REC_HGG_extract_perf.csv", header=F)
colnames(withvialid)=c("bnum", "tnum", "seo", "bion", "vi1", "vi2", "vi3", "vi4")
all50=read.csv("REC_HGG_fix_anatomical_res.50.csv", header=F)
colnames(all50)=c("bnum", "tnum", "sfnum", "DUMMY")
missing_vialID=merge(withvialid, all50, by.x="tnum", by.y = "tnum", all=T)
dim(missing_vialID)
View(missing_vialID)
write.csv(missing_vialID, file="perfusion/manual_add_vialID.csv")
## so here I went in and tried to manually add in the vial IDs by looking at their numbers on the server; 
## NOTE: three b/tnums didn't have sfnumbers on the server

vialIDs=read.csv("perfusion/manual_add_vialID.csv")
dim(vialIDs)
# [1] 47 11

## ok let's figure out how tf we're going to go into each folder & extract the friggin perfusion data. 
