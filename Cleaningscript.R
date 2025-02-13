#                     -- DATA CLEANING --

#Cleaning column names --  

salary <- salary %>% 
  transmute(gender=(kjønn),
            education=(utdanning),
            experience=(erfaring),
            city=(arbeidssted),
            type=(arbeidssituasjon),
            expertise=(fag),
            salary=(lønn),
            bonus=(`bonus?`))

#                       Cleaning categories -- translation -- ENG 

# Gender , 19 entrys none response => 19/2682 = 0.7%  -> delete -- 

salary <- salary %>% 
  filter(gender!="annet / ønsker ikke oppgi") %>% 
  mutate(gender=ifelse(gender=="mann","Male","Female"))

# Education: Education level not specified, only 4=bachelor, 
# 5=master´s. No manipulation in this part, separate analysis. 

#                   --  CITY --

salary <- salary %>% 
  mutate(city=str_replace_all(city,"og","and"))

#                  --  TYPE -- translation -- ENG 

salary <- salary %>% 
  mutate(type=case_when(type=="frilans / selvstendig næringsdrivende"~"Freelancer/ self-employed",
                        type=="in-house, offentlig/kommunal sektor"~"Public/municipal sector",
                        type=="in-house, privat sektor"~"Private sector",
                        type=="konsulent"~"consultant",
                        TRUE ~ type ))

#                 -- EXPERTISE -- translation -- ENG 

salary <- salary %>% 
  mutate(expertise=case_when(expertise=="AI / maskinlæring"~"AI/machine-learning",
                             expertise=="annet"~"Other",
                             expertise=="arkitektur"~"Architecture",
                             expertise=="automatisering"~"Automation",
                             expertise=="devops/drift"~"DevOPS/operations",
                             expertise=="embedded/IOT/ maskinvare"~"Embedded/IoT/hardware",
                             expertise=="ledelse/administrativt"~"Management/administrative",
                             expertise=="programvare"~"Software",
                             expertise=="sikkerhet"~"Security",
                             TRUE ~ expertise))


#                  -- SALARY -- 
# 7 february 2025, 1NOK = 0.08610EUR 

salary <- salary %>% 
  mutate(salaryEUR=salary*0.08610) %>% 
  select(-salary)


#                  -- BONUS -- translate -- ENG 

salary <- salary %>% 
  mutate(bonus=ifelse(bonus=="Ja","Yes","No"))



#                  -- VARS CHR -> FCT -- 

salary <- salary %>% 
  mutate_if(is.character,as.factor)