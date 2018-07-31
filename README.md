

  # Goal
  
  - Evaluate two implemenatations of an imputation package called MICE. One implemenatation is written for R. It has been around since 2000. The other implementation is written for Python. It is much more recent than the R version.
- The data is from Kaggle. It is the Ames Housing Dataset used for building models that predict sale price.
- To compare the implementations, we used R-square scores. We also calculated an absolute sum of the different between imputed values and the baseline values. In this case, we treated the imputations in the same way predicted values is any regression are compared to actual values. 
- We found that, given a caveat, R MICE and Python MICE perform at the same level. The caveat is that Python MICE fails if the data is correlated (singular) to such a degree that a model with a single solution cannot be found. This is because Python MICE has a single impute model that is a type of linear regression. R Mice has several alternative imputation models. It Random Forest option can handle data with singlarity issues.
