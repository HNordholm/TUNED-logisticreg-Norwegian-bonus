

              ############################
              #TUNED LASSO LOGISTIC MODEL# 
              ############################




#                -- Data budget for training and testing splits --


set.seed(234) 
salary_split <- initial_split(salary,strata=bonus)
salary_train <- training(salary_split)
salary_test <- testing(salary_split)


#BOOTSTRAPS RESAMPLING


set.seed(345)
salary_boots <- bootstraps(salary_train)

salary_boots

#LOGISTIC MODEL RECIPE 

salary_log_rec <- recipe(bonus~.,salary_train) %>% 
  step_normalize(all_numeric_predictors()) %>% 
  step_zv(all_numeric_predictors()) %>% 
  step_dummy(all_nominal_predictors()) %>% 
  step_rm(education)

#LOGISTIC MODEL SPEC 

log_spec <- logistic_reg(mixture=1,penalty = tune()) %>% 
  set_engine("glmnet") %>% 
  set_mode("classification")

#WORKFLOW 

salary_log_wf <- workflow() %>% 
  add_recipe(salary_log_rec) %>% 
  add_model(log_spec)



#LAMBDA GRID FOR MODEL TUNING 

lambda_grid  <- grid_regular(penalty(),levels=10)

#LAMBDA TUNING 

salary_tune <- tune_grid(object=log_spec,
                         preprocessor = salary_log_rec,
                         resamples = salary_boots,
                         grid = lambda_grid)

# SAVE BEST LAMBDA BY ROC_AUC

best_lambda <- salary_tune %>% select_best(metric="roc_auc")

#FINALIZE LASSO LOGISTIC REGRESSION WORKFLOW 

final_log_wf <- finalize_workflow(salary_log_wf,best_lambda)

#LAST FIT LOGISTIC REGRESSION 

last_log_ml <- last_fit(final_log_wf,salary_split)

#COLLECT EVALUATION METRIC OF LAST LASSO MODEL 

last_log_ml %>% collect_metrics()

#ACCURACY:0.692
#ROC_AUC :0.72 

#ESTIMATES FACTOR IMPORTANCE: TUNED LOGISTIC MODEL

last_log_ml %>% extract_fit_parsnip() %>% 
  tidy() %>% 
  mutate(term=str_replace_all(term,"city_",""),
         term=str_replace_all(term,"expertise_",""),
         term=str_replace_all(term,"type_",""),
         term=str_replace_all(term,"gender_","")) %>% 
  filter(abs(estimate)>0) %>% 
  filter(term!="(Intercept)") %>% 
  ggplot(aes(estimate,fct_reorder(term,estimate),fill=estimate))+
  geom_col(show.legend = FALSE)+
  labs(y=NULL)+
  labs(title="Salary bonus factor importance",
       caption="Source:https://www.kode24.no/artikkel/her-er-lonnstallene-for-norske-utviklere-2024/81507953")