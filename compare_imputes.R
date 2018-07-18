# Simulate data set with \code{mvrnorm} from package \code{\pkg{MASS}}.
setwd("/Users/peterstafford/generalassembly/capstone/capstone_code")
tFile="training_data_for_ampute.csv"
actual_train_data=read.csv(tFile)
t_r_impute_50=read.csv('train_r_50_5.csv')
sum(abs(t_r_impute_50-actual_train_data))
t_Python_impute_50=read.csv('train_Python_50_5.csv')
sum(abs(t_Python_impute_50-actual_train_data))
t_mean_impute=read.csv("train_impute_mean_50.csv")
sum(abs(t_mean_impute-actual_train_data))


