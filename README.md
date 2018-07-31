

  # Goal
  
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
