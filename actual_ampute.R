#The code runs after 
full_path="/Users/peterstafford/generalassembly/capstone/capstone_code/"
ampute_data<-function(tData,tCols,tProb)
{
	 tLen=length(tData[,1])
	 tAmpData=tData
	 tCount=round(tLen*tProb)
	 for(i in tCols)
	 {
	 	 t_rows_set_null=sample(c(1:tLen),tCount, replace = FALSE)
	 	 tAmpData[t_rows_set_null,i]<- NA 
	 }
	 tR=list()
	 tR[[1]]=tAmpData
	 tR[[2]]=tData
	 names(tR)=c("amp","data")
	 return (tR)
}

tFileCorr=paste(full_path,"correlation_coefs.csv",sep="")
# read in list of corelations between each feature and target 
td_corr=read.csv(tFileCorr)
dim(td_corr)
tS=sort(td_corr[,1], index.return=TRUE, decreasing=T)
# get the column number for the top five features by correlation. These will be the features that are amputed/imputed
tCols=tS$ix[1:5]
require(MASS)
library(mice)
library(imputeR)
# read in the data whick will be imputed and amputed
tFile=paste(full_path,"training_data_for_ampute.csv",sep="")
td<-read.csv(tFile)
tProp=.05
result1=ampute_data(td,tCols,tProp)
mi <- mice(result1$amp)
train <- complete(mi)
tFile=paste(full_path,"amputed_data_05_5.csv",sep="")
write.csv(result1$amp,tFile,row.names=F)
tFile=paste(full_path,"train_r_05_5.csv",sep="")
write.csv(train,tFile,row.names=F)

# 10 percent
tProp=.10
result1=ampute_data(td,tCols,tProp)
mi <- mice(result1$amp)
train <- complete(mi)

tFile=paste(full_path,"amputed_data_10_5.csv",sep="")
write.csv(result1$amp,tFile,row.names=F)
tFile=paste(full_path,"train_r_10_5.csv",sep="")
write.csv(train,tFile,row.names=F)

#15 percent
tProp=.15
result1=ampute_data(td,tCols,tProp)
mi <- mice(result1$amp)
train <- complete(mi)

tFile=paste(full_path,"amputed_data_15_5.csv",sep="")
write.csv(result1$amp,tFile,row.names=F)
tFile=paste(full_path,"train_r_15_5.csv",sep="")
write.csv(train,tFile,row.names=F)
#50 percent
tProp=.5
result1=ampute_data(td,tCols,tProp)
mi <- mice(result1$amp)
train <- complete(mi)

tFile=paste(full_path,"amputed_data_50_5.csv",sep="")
write.csv(result1$amp,tFile,row.names=F)
tFile=paste(full_path,"train_r_50_5.csv",sep="")
write.csv(train,tFile,row.names=F)

#50 percent impute using mean
tProp=.5
result1=ampute_data(td,tCols,tProp)
train=guess(result1$amp,type='mean')
#write.csv(result1$amp,'/Users/peterstafford/generalAssembly/capstone/capstone_code/amputed_data_50_5.csv',row.names=F)

tFile=paste(full_path,"train_impute_mean_50.csv",sep="")
write.csv(train,tFile,row.names=F)



