#For this script to work, we need to set pwd to the directory the script is run from
setwd('/Users/peterstafford/generalassembly/capstone_repo/capstone/capstone')
library(MASS)
require(MASS)
library(mice)

skew_left=function(t_data,tConstant)
{
	tD=tanh(t_data/max(abs(t_data))+tConstant)
	return (tD)
}
skew_right=function(t_data,tConstant)
{
	tD=sinh(t_data/max(abs(t_data))+tConstant)
	return (tD)
}
convert_counts=function(t_data,t_factor,t_skew_left,t_skew)
{
	t_new_data=0;
	if(t_skew_left==1)
	{
	 	t_new_data=skew_left(t_data,t_skew)
	}
	else 
	{
	 	t_new_data=skew_right(t_data,t_skew)
	}  
	#tD=t_data/max(abs(t_data))
	#tD=tD+2
	tD=t_new_data
	tD=tD*t_factor
	tD=round(tD)
	return (tD)
}
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
get_threshold_r_square<-function(tData,t_thresh)
{
	t_indexes=which(tData<t_thresh)
	t_vct1=tData[t_indexes]
	tSrt=sort(tData,index.return=TRUE,decreasing=T)
	t_max_index=tSrt$ix[1]
	t_max=tSrt$x[t_max_index]
	return (t_max)
}
plot_dist=function(t_actual,t_imputed,t_imputed_indexes)
{
	t_cols=c('col_1','col_2','col_3','col_4','col_5')
	par(mfrow=c(4,2))
    for(i in 2:5)
    {
    	hist(t_imputed[t_imputed_indexes,i],xlab=t_cols[i],main='Imputed')
        hist(t_actual[,i],xlab=t_cols[i],main='Actual')
    }	 
}

d <- data.frame(x1=rnorm(10),
                 x2=rnorm(10),
                 x3=rnorm(10),
                 x4=rnorm(10),
                 x5=rnorm(10))
#cor(d) 
tLM=lm(x1~x2+x3+x4+x5,data=d)
tS=summary(tLM)
tN=names(tS)
tListRsq=vector()
tListData=list()
tListCorr=list()
for(i in 1:2000)
{
	d <- data.frame(x1=rnorm(10),
                 x2=rnorm(10),
                 x3=rnorm(10),
                 x4=rnorm(10),
                 x5=rnorm(10))
    tLM=lm(x1~x2+x3+x4+x5,data=d)
    tS=summary(tLM)
    tListRsq[i]=tS$r.squared
    tListData[[i]]=d
    tListCorr[[i]]=cor(d)
}
t_index=get_threshold_r_square(tListRsq,.9)
t_m=mvrnorm(n = 2000,c(0,0,0,0,0), tListCorr[[t_index]])
t_data=data.frame(t_m)
tLM=lm(x1~skew_right(x2,3)+x3+skew_left(x4,2)+convert_counts(x5,20,0,5),data=t_data)
summary(tLM)
tD=data.frame(t_data$x1,skew_right(t_data$x2,3),skew_left(t_data$x3,2),t_data$x4,convert_counts(t_data$x5,40,0,5))
names(tD)=c('x1','x2','x3','x4','x5')
amp_dt=ampute_data(tD,c(2,3,4,5),.3)
mi <- mice(amp_dt$amp)
train <- complete(mi)
names(train)=c('x1','x2','x3','x4','x5')
tLM=lm(x1~x2+x3+x4+x5,data=train)
summary(tLM)
t_imputed_indexes=which(is.na(amp_dt$amp$x4))
plot_dist(amp_dt$data,train,t_imputed_indexes)
write.csv(amp_dt$amp,file='amp_data.csv',row.names=FALSE)
write.csv(tD,file='sim_data.csv',row.names=FALSE)
write.csv(train,file='imputed_r_30_percent_data.csv',row.names=FALSE)
#par(mfrow=c(4,2))
#hist(train$x4[t_na_indexes],xlab='col_4',main='Imputed')
#hist(tD$x4,xlab='col_4',main='Actual')
