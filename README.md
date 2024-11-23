You could see the result of this analysis in [romanlanda11.github.io/time_series/](https://romanlanda11.github.io/time_series/)

 
# Structure
```
├───fitted              # fitted models
|
|
└───index_files         # html elements
```

# Introduction

The Monthly Economic Activity Estimator (EMAE) reflects the monthly evolution of
the economic activity across all national productive sectors. This is a provisional 
indicator of GDP evolution at 2004 constant prices, released with a lag of 50 to
60 days after the end of the reference month.

The indicator is a Laspeyres index that provides an outline of real economic 
activity behavior with greater frequency than the quarterly GDP at constant prices. 
Its calculation is based on the aggregation of value added at basic prices for 
each economic activity, plus taxes net of product subsidies, using the weights 
of the 2004 base national accounts of the Argentine Republic. It aims to replicate
the quarterly and/or annual GDP calculation methods, as far as the availability 
of data sources for a shorter period allows.

It is important to note that EMAE is compiled with partial and provisional 
information —since some data may be corrected and/or completed by the source— or 
with alternative indicators to those used for quarterly calculation, as they 
have been evaluated as adequate approximations. Since the quarterly GDP estimate
compiles a larger volume of data, closing and publishing around 30 days after 
the EMAE, it is common to observe differences between the quarterly variations 
of both indicators.

# Objective

The objective of this project is to practically apply the analytical tools acquired
in the Time Series course, through a descriptive and predictive analysis of 
real-world time series. This report seeks to strengthen the understanding of the
methods studied and their application to economic data, assessing both historical
trends and potential short- and medium-term projections of economic behavior.

# Data

The Argentine Time Series API provides access to chronologically evolving 
indicators published in open formats by agencies of the National Public 
Administration. We will use this API to retrieve the series [EMAE. Base 2004](https://datos.gob.ar/series/api/series/?ids=143.3_NO_PR_2004_A_21).

# Bibliography

Both in the course and in this work, we rely on the following books:

* [Forecasting: Principles and Practice (3rd ed)](https://otexts.com/fpp3/) by Rob J Hyndman 
and George Athanasopoulos

* *Time Series Analysis: Univariate and Multivariate Methods* (2nd ed) by William Wei

