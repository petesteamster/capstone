## The Problem of Missing Data 
Below is a partial data set used to predict sales at a hardware store for a month. The features are ***Rain (1=yes,0=no),Cloudy (1=yes,0=no),Temperature,Customers in a 24 hour period***. The features are used in an attempt to see how weather affects sales. Note that some of the data is flagged as missing. A predictive model cannot be built if we do not fill in the missing data with values. Also, because collecting data takes time and money, we dont want to toss the data out. What values should we use to fill in the missing data?

<p align="left">
  <img src="https://github.com/petesteamster/capstone/blob/master/missing_data01.png" height="300" width="360">
</p>

## Impute Missing Data
The term for guessing/replacing a value for the missing data is **imputation**. A simple imputation method is to calculate the mean or the median of a column that has missing data and then set all the missing data in that column to the value of the calcuation. Of course, the calculation is only performed on the values in the column that are *not missing*. Although this method is used all the time, it has some flaws. A major flaw is it artificailly reduces the variance. This can decrease the size of confidence intervals which can lead to making poor inferences. 
## MICE
MICE is an acronym for *Multivariate Imputation by Chained Equations*. It is an algorithm that relies on regression methods to perform imputations. Below we provide a high level/stepwise description of how MICE works.  
   ### *Step 1*
   Below is the partial dataset with only features. We use the *mean impute* method on all the missing values except 1. This is illustrated in step 2.  
<p align="left">
  <img src="https://github.com/petesteamster/capstone/blob/master/missing_data01_B.png" height="300" width="300">
</p>
  
  ### *Step 2*
  In the dateset below, the missing values in *Customer* and *Temperature* have been replaced with the column mean. The missing value in 
  *Rain* was left *missing*. Now *Rain* can be imputed using a regression method. This is illustrated in step 3. 
<p align="left">
  <img src="https://github.com/petesteamster/capstone/blob/master/missing_data02_B.png" height="300" width="300">
</p>

### *Step 3*
  In this step, the regression prediction replaced the missing value in *Rain*. Also, the mean impute in *Customers* has been set back to *Missing*. Note that *Temperature* was left alone. A regresson is run the imputes a new value for the missing value in *Customers*. This is shown in step 4. 
<p align="left">
  <img src="https://github.com/petesteamster/capstone/blob/master/missing_data03_B.png" height="300" width="300">
</p>

### *Step 4*
  In this step, the regression prediction replaced the missing value in *Customers*. Also, the mean impute in *Temperature* has been set back to *Missing*. Note that *Rain* was left alone. A regresson is run the imputes a new value for the missing value in *Temperature*. This is shown in step 5. 
<p align="left">
  <img src="https://github.com/petesteamster/capstone/blob/master/missing_data04_B.png" height="300" width="300">
</p>
 
 ### *Step 5*
  In this step, the regression prediction replaced the missing value in *Temperature*. All the missing values have been replaced by a regression impute. This is run several times. For example, *Customers* might be set to *Missing* again and the regression rerun. Then *Rain* is reset. Etc. The process can go on for several iterations. This leads to imputed values that do not cause problems with variance reduction and so on. 
<p align="left">
  <img src="https://github.com/petesteamster/capstone/blob/master/missing_data05_B.png" height="300" width="300">
</p>
 
  # Goal: Compare the R and the Python implemtation of MICE
  
  - Evaluate two implemenatations of an imputation package called MICE. One implemenatation is written for R. It has been around since 2000. The other implementation is written for Python. It is much more recent than the R version.
- The data is from Kaggle. It is the Ames Housing Dataset used for building models that predict sale price.
- To compare the implementations, we used R-square scores. We also calculated an absolute sum of the different between imputed values and the baseline values. In this case, we treated the imputations in the same way predicted values is any regression are compared to actual values. 
- We found that, given a caveat, R MICE and Python MICE perform at the same level. The caveat is that Python MICE fails if the data is correlated (singular) to such a degree that a model with a single solution cannot be found. This is because Python MICE has a single impute model that is a type of linear regression. R Mice has several alternative imputation models. It Random Forest option can handle data with singlarity issues.

# Implementation and Analysis

- For the most part, our model was secondary to our goal. We needed a descent model, but the results of the model were not our goal. The model was used as a means to evaluate the imputation process of Python MICE and R MICE. We used a model we created from an earlier project. We tweaked it a bit. We used a log transformation on the target in order to make its distribution more normal. The model has an R-square score in the range of .8. 
- We used the Ame Housing Data. We assumed there was no missing data. An inspection of the data will show several categories with an 'NA' designation. We asuumed 'NA'to be valid. That is, we assumed 'NA' meant 'Not Applicable'. For example, the category 'Alley' indicates the type of alley that borders a given house. Most houses have no contiguous alleys. This the category is 'NA". 
- Assuming there is no missing data allows us to treat it as a baseline. We take this baseline data and randomly
remove points which provides us a set that contains simulated missing data. 
- As with most models, our model was based on features created from raw data. We created a large number of polynomial features. In an effort to trim the feature count down, we removed features that had an absolute correlation with the target (SalePrice) less than .25. We found that .25 gave us the best model. This resulted in approximately 160+ features.
- Each time we train our model, we shuffled the data. Since the mix of the training data changes from run to run, the correlation between each feature and the target changes from run to run. Thus, for each run, different features fall above or below the .25 correlation threshold. Therefore, the feature count varies from run to run. 
- Because features drop in and out from run to run, we decided to use the final training data; that is the data 
built from the features after they were weed out by the coorelation threshold process.
-  We performed the missing data simulation on the features with the top 5 correlations 
