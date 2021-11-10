here::i_am("R/Zika_Tables.R")

#Only install necessary packages if user has not yet installed them  (to read in SAS dataset and summarize/graph data)
if (!require("sas7bdat")) install.packages("sas7bdat")
if (!require("dplyr")) install.packages("dplyr")
if (!require("table1")) install.packages("table1")
if (!require("ggplot2")) install.packages("ggplot2")

#Load package to read SAS dataset into R
library("sas7bdat")

#Load packages to summarize and graph data
library("dplyr")
library("table1")
library("ggplot2")

#Create working dataset in R
zika_data <- read.sas7bdat("Data/zika_simulated_data.sas7bdat")


#Review structure of dataset by looking at the first 6 rows
head(zika_data)

#Print variable names
names(zika_data)


###Create categorical variables from continuous variables for table reporting

#Maternal age
zika_data$mat_age_cat <- as.factor(ifelse(zika_data$mat_age < 20, 1, #<20 years old
                                   ifelse(zika_data$mat_age <= 35, 2, #20-35 years old
                                   ifelse(zika_data$mat_age >= 36, 3, NA)))) #> 35 years old

#Maternal education (collapse into further categories)
zika_data$edu_cat <- as.factor(ifelse(zika_data$education == 1, 1, #no formal schooling, illiterate
                                   ifelse(zika_data$education <= 10, 2, #primary/secondary (nursery school through 12th grade/GED)
                                   ifelse(zika_data$education <= 18, 3, #university+
                                   ifelse(zika_data$education >= 98, NA, NA))))) #refused, don't know, missing

#Gestational age (GA) at maternal study entry
zika_data$ga_entry_cat <- as.factor(ifelse(zika_data$ga_study_entry < 14, 1, #0-13weeks,6days
                                    ifelse(zika_data$ga_study_entry < 29 , 2, #14-28weeks,6days
                                    ifelse(zika_data$ga_study_entry >= 29, 3, NA)))) #29 weeks or more

#Gravidity (previous pregnancies/deliveries)
zika_data$gravidity_cat <- as.factor(ifelse(zika_data$tot_prior_preg==0, 1, #no prior pregnancies (0)
                                    ifelse(zika_data$tot_prior_preg <= 2, 2, #1 or 2 prior pregnancies
                                    ifelse(zika_data$tot_prior_preg >= 3, 3, NA)))) #3 or more prior pregnancies

#Check variable creation
  #Maternal age
  zika_data %>% group_by(mat_age_cat) %>% summarize(min_mat_age=min(mat_age),max_mat_age=max(mat_age))
  #Maternal education
  zika_data %>% count(education)
  zika_data %>% group_by(edu_cat) %>% summarize(min_edu=min(education),max_edu=max(education))  
  #GA at maternal study entry
  zika_data %>% group_by(ga_entry_cat) %>% summarize(min_ga_entry=min(ga_study_entry),max_ga_entry=max(ga_study_entry))  
  #Parity
  zika_data %>% group_by(gravidity_cat) %>% summarize(min_gravidity=min(tot_prior_preg),max_gravidity=max(tot_prior_preg))


#Create variable of % of women enrolled in the first trimester for paragraph below
percent_trim <- zika_data %>%
  group_by(ga_entry_cat) %>%
  summarise(cnt = n()) %>%
  mutate(perc = round(((cnt / sum(cnt))*100),1)) %>% 
  filter(ga_entry_cat==1)

percent_1st_trim <- percent_trim[1,3]



###Create maternal descriptive statistics table 1 (make new dataset since changing variable type from numeric to character for table printing)
zika_data_table1 <- zika_data

#Add labels to numeric categorical variables
zika_data_table1$mat_age_cat <- factor(zika_data_table1$mat_age_cat, levels=c("1","2","3"), labels=c("<20","20-35",">35"))
zika_data_table1$edu_cat <- factor(zika_data_table1$edu_cat, levels=c("1","2","3"), labels=c("No formal schooling, illiterate","Primary/secondary","University+"))
zika_data_table1$ga_entry_cat <- factor(zika_data_table1$ga_entry_cat, levels=c("1","2","3"), labels=c("0-13","14-28",">=29"))
zika_data_table1$gravidity_cat <- factor(zika_data_table1$gravidity_cat, levels=c("1","2","3"), labels=c("0","1-2","3+"))
zika_data_table1$site <- factor(zika_data_table1$site, levels=c("1","2","3","4","5"), labels=c("Site 1","Site 2","Site 3","Site 4","Site 5"))

#Add units to applicable variables
units(zika_data_table1$mat_age_cat) <- "years"
units(zika_data_table1$ga_entry_cat) <- "weeks"

#Apply labels to variable names
label(zika_data_table1$mat_age_cat) <- "Maternal age"
label(zika_data_table1$edu_cat) <- "Maternal education"
label(zika_data_table1$ga_entry_cat) <- "Gestational age"
label(zika_data_table1$gravidity_cat) <- "Gravidity"

#Create table 1 - descriptive statistics of maternal characteristics at enrollment
mat_table <- table1(~ mat_age_cat + edu_cat+ ga_entry_cat + gravidity_cat | site, data=zika_data_table1)

#Save table 1 as an r object to be used in markdown file
save(mat_table, file = here::here('Output', "maternal_table.rdata"))


#Look at infant data (and make sure all variable levels are 0/1)
table(zika_data$infant_micro)
table(zika_data$infant_sga)
table(zika_data$infant_lbw)
table(zika_data$preterm)
table(zika_data$fetal_demise_1to20)
table(zika_data$fetal_demise_20plus)
table(zika_data$fetal_demise_delivery)
table(zika_data$neonatal_demise_6wks)
table(zika_data$adverse_fetal)
table(zika_data$infant_seizure)
table(zika_data$arthrogryposis)
table(zika_data$infant_congen_malform)
table(zika_data$ophtho_screen_fail)
table(zika_data$audio_screen_fail)

#Collapse microcephaly & severe microcephaly into one level
zika_data$infant_micro_update <- as.factor(ifelse(zika_data$infant_micro == 0, 0,
                                           ifelse(zika_data$infant_micro >= 1, 1, NA)))

#Collpse infant ZIKV exposure
zika_data$infant_exposure <- as.factor(ifelse(zika_data$infant_zikv_exposure == 1, 1,
                                           ifelse(zika_data$infant_zikv_exposure >= 2, 0, NA)))


###Create infant chi-square table (make new dataset since changing variable type from numeric to character for table printing)
zika_data_table2 <- zika_data

#Add labels to numeric categorical variables
zika_data_table2$infant_micro_update <- factor(zika_data_table2$infant_micro_update, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$infant_sga <- factor(zika_data_table2$infant_sga, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$infant_lbw <- factor(zika_data_table2$infant_lbw, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$preterm <- factor(zika_data_table2$preterm, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$adverse_fetal <- factor(zika_data_table2$adverse_fetal, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$infant_seizure <- factor(zika_data_table2$infant_seizure, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$arthrogryposis <- factor(zika_data_table2$arthrogryposis, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$infant_congen_malform <- factor(zika_data_table2$infant_congen_malform, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$ophtho_screen_fail <- factor(zika_data_table2$ophtho_screen_fail, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$audio_screen_fail <- factor(zika_data_table2$audio_screen_fail, levels=c("0","1"), labels=c("No","Yes"))
zika_data_table2$infant_exposure <- factor(zika_data_table2$infant_exposure, levels=c("0","1"), labels=c("Unexposed","Exposed"))

#Apply labels to variable names
label(zika_data_table2$infant_micro_update) <- "Microcephaly"
label(zika_data_table2$infant_sga) <- "Small for gestational age"
label(zika_data_table2$infant_lbw) <- "Low birth weight"
label(zika_data_table2$preterm) <- "Preterm birth"
label(zika_data_table2$adverse_fetal) <- "Adverse fetal outcome"
label(zika_data_table2$infant_seizure) <- "Seizure"
label(zika_data_table2$arthrogryposis) <- "Arthrogryposis"
label(zika_data_table2$infant_congen_malform) <- "Congenital Malformation"
label(zika_data_table2$ophtho_screen_fail) <- "Ophthalmological Failure"
label(zika_data_table2$audio_screen_fail) <- "Audiological Failure"


#Create table 1 - descriptive statistics of infant characteristics
inf_table <- table1(~ infant_micro_update + infant_sga + infant_lbw + preterm + adverse_fetal + infant_seizure + arthrogryposis + infant_congen_malform + ophtho_screen_fail + audio_screen_fail | infant_exposure, data=zika_data_table2)

#Save table 1 as an r object to be used in markdown file
save(inf_table, file = here::here('Output', "infant_table.rdata"))

