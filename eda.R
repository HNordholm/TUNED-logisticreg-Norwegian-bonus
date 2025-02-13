


                       #EDA SCRIPT --

salary %>% skim()

#Which expertise correspons to higher median salaries? 

salary %>% 
  ggplot(aes(salaryEUR,fct_reorder(expertise,salaryEUR),fill=expertise))+
  geom_boxplot(show.legend = FALSE)+
  scale_x_continuous(labels=label_dollar(prefix="€"))+
  labs(x="Annual in EUR",y=NULL)

# Median salaries by working city -- 

salary %>% 
  ggplot(aes(salaryEUR,fct_reorder(city,salaryEUR),fill=city))+
  geom_boxplot(show.legend = FALSE)+
  scale_x_continuous(labels=label_dollar(prefix="€"))+
  labs(x="Annual in EUR",y=NULL)

#Is there a difference in salaries between  public and private sector?

salary %>% 
  filter(type=="Private sector"|type=="Public/municipal sector") %>% 
  ggplot(aes(log(salaryEUR),fill=type))+
  geom_density(alpha=0.5)+
  labs(fill="Sector",x="EURsalary logscale")+
  geom_vline(data = salary %>% filter(type == "Private sector"),
             aes(xintercept = mean(log(salaryEUR),)),
             color="red",linetype="dashed")+
  geom_vline(data=salary%>%filter(type=="Public/municipal sector"),
             aes(xintercept = mean(log(salaryEUR))),
             color="darkgreen",linetype="dashed")


#            --  GENDER BONUS PROPORTION --


# Whats the proportion of bonuses between genders ?

salary %>% 
  group_by(gender) %>% 
  count(bonus) %>% 
  mutate(prop_percent=n/sum(n))


salary %>% 
  group_by(gender) %>% 
  count(bonus) %>% 
  mutate(prop_percent=n/sum(n)) %>% 
  ggplot(aes(prop_percent,gender,fill=bonus))+
  geom_col()+
  scale_x_continuous(labels=scales::percent_format())+
  labs(fill="Bonus?")