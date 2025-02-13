# TUNED logisticreg Norwegian developer salaries 2024 

## Data source: 

https://www.kode24.no/artikkel/her-er-lonnstallene-for-norske-utviklere-2024/81507953


### Project 

This project explores salary trends for Norwegian developers using R, data science, and machine learning. The goal is to explore what really drives salaries and bonuses by cleaning the data, spotting trends, and build a logistic regression model for bonus factor importance. 


## This analysis is structured as follows:

Data cleansing & prep  

EDA – GGPLOT 

Statistical analysis - correlation plots 

Machine learning - Tuned logistic regression model 

## Machine learning results 

Below is a visualization of the estimated contributions of different factors to receiving a salary bonus, based on a tuned LASSO logistic regression model.


![Bonus estimates](https://github.com/HNordholm/TUNED-logisticreg-Norwegian-bonus/blob/main/Estimatesforbonus.png?raw=true)


## ROCAUC 

ROCAUC:0.72, which could be improved. Variable education was omitted due to no information to educational levels.



