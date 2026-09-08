library(readr) #To load CSV data file
library(visdat) #Install visdat package to find missing values with vis_miss [In-Text Citation: (Tierney & Hughes, 2023)]
library(dplyr) #To use glimpse function to view data
library(tidyr) #To use pivot_longer function in order to plot nominal variables
library(ggplot2) #To use plots
library(caret) #To use dummyVars function


#Loading data
churn_data_df <- read_csv("churn_clean.csv")
glimpse(churn_data_df)
#NOTE: this file (churn_clean.csv) has no missing values in the columns imputed below
#(Children, Age, Income, Techie, Phone, TechSupport, Tenure, Bandwidth_GB_Year), so the
#imputation steps that follow are a defensive no-op on this particular dataset, purely demonstrative.


#Duplicates Detection: No duplicates found, no treatment necessary
duplicated(churn_data_df)
sum(duplicated(churn_data_df))



#Missing Values Detection
colSums(is.na(churn_data_df))
vis_miss(churn_data_df)

#Treatment of missing values - Imputation since deletion stats conditions were not met
#Children
hist(churn_data_df$Children)#Skewed right distribution calls for median univariate imputation
churn_data_df$Children[is.na(churn_data_df$Children)] <- median(churn_data_df$Children, na.rm=TRUE)
hist(churn_data_df$Children)#To verify distribution is still skewed to the right
#Age
hist(churn_data_df$Age)#Normal/ Uniform distribution calls for mean univariate imputation
churn_data_df$Age[is.na(churn_data_df$Age)] <- mean(churn_data_df$Age, na.rm=TRUE)
hist(churn_data_df$Age)#To verify distribution is still normal/ uniform, spiked
summary(churn_data_df$Age)#Confirmed mean/ stats remained relatively close to original values
#Income
hist(churn_data_df$Income)#Skewed right distribution calls for median univariate imputation
churn_data_df$Income[is.na(churn_data_df$Income)] <- median(churn_data_df$Income, na.rm=TRUE)
hist(churn_data_df$Income)#To verify distribution is still skewed to the right
#Techie - Categorical variable calls for mode univariate imputation
churn_data_df$Techie[is.na(churn_data_df$Techie)] <- (names(which.max(table(churn_data_df$Techie))))
#Phone - Categorical variable calls for mode univariate imputation
churn_data_df$Phone[is.na(churn_data_df$Phone)] <- (names(which.max(table(churn_data_df$Phone))))
#TechSupport - Categorical/ Boolean variable calls for mode univariate imputation
churn_data_df$TechSupport[is.na(churn_data_df$TechSupport)] <- (names(which.max(table(churn_data_df$TechSupport))))
#Tenure
hist(churn_data_df$Tenure)#Bi-modal distribution can use median or mode univariate imputation, using median
churn_data_df$Tenure[is.na(churn_data_df$Tenure)] <- median(churn_data_df$Tenure, na.rm=TRUE)
hist(churn_data_df$Tenure)#To verify distribution is still bi-modal
summary(churn_data_df$Tenure)#Confirmed mean/ stats remained relatively close to original values
#Bandwidth_GB_Year
hist(churn_data_df$Bandwidth_GB_Year)##Bi-modal distribution can use median or mode univariate imputation, using median
churn_data_df$Bandwidth_GB_Year[is.na(churn_data_df$Bandwidth_GB_Year)] <- median(churn_data_df$Bandwidth_GB_Year, na.rm=TRUE)
hist(churn_data_df$Bandwidth_GB_Year)#To verify distribution is still bi-modal
summary(churn_data_df$Bandwidth_GB_Year)#Confirmed mean/ stats remained relatively close to original values

#Confirm no missing values present
colSums(is.na(churn_data_df))



#Outliers Detection Using Boxplots
#Count of outliers: 158, range: min whisker= 25.53021, max whisker= 49.28436
Lat_boxplot <- boxplot(churn_data_df$Lat)
#Count of outliers: 273, range: min whisker=-122.56348, max whisker=-65.66785
Lng_boxplot <- boxplot(churn_data_df$Lng)
#Count of outliers: 937, range: min whisker= 0, max whisker= 31795
Population_boxplot <- boxplot(churn_data_df$Population)
#Count of outliers: 302, range: min whisker= 0, max whisker= 7
Children_boxplot <- boxplot(churn_data_df$Children)
#Count of outliers: 0, range: min whisker= 18, max whisker= 89
Age_boxplot <- boxplot(churn_data_df$Age)
#Count of outliers: 758, range: min whisker= 740.66, max whisker= 78272.96
Income_boxplot <- boxplot(churn_data_df$Income)
#Count of outliers: 539, range: min whisker= 1.446910, max whisker= 19.056411
Outage_sec_perweek_boxplot <- boxplot(churn_data_df$Outage_sec_perweek)
#Count of outliers: 38, range: min whisker= 4, max whisker= 20
Email_boxplot <- boxplot(churn_data_df$Email)
#Count of outliers: 8, range: min whisker= 0, max whisker= 5
Contacts_boxplot <- boxplot(churn_data_df$Contacts)
#Count of outliers: 94, range: min whisker= 0, max whisker= 2
Yearly_equip_failure_boxplot <- boxplot(churn_data_df$Yearly_equip_failure)
#Count of outliers: 0, range: min whisker= 1.000259, max whisker= 71.999280
Tenure_boxplot <- boxplot(churn_data_df$Tenure)
#Count of outliers: 5, range: min whisker= 77.50523, max whisker= 297.31580
MonthlyCharge_boxplot <- boxplot(churn_data_df$MonthlyCharge)
#Count of outliers: 0, range: min whisker= 155.5067, max whisker= 7158.9820
Bandwidth_GB_Year_boxplot <- boxplot(churn_data_df$Bandwidth_GB_Year)
#Count of outliers: 442, range: min whisker= 2, max whisker= 5
item1_boxplot <- boxplot(churn_data_df$Item1)
#Count of outliers: 445, range: min whisker= 2, max whisker= 5
item2_boxplot <- boxplot(churn_data_df$Item2)
#Count of outliers: 418, range: min whisker= 2, max whisker= 5
item3_boxplot <- boxplot(churn_data_df$Item3)
#Count of outliers: 433, range: min whisker= 2, max whisker= 5
item4_boxplot <- boxplot(churn_data_df$Item4)
#Count of outliers: 422, range: min whisker= 2, max whisker= 5
item5_boxplot <- boxplot(churn_data_df$Item5)
#Count of outliers: 413, range: min whisker= 2, max whisker= 5
item6_boxplot <- boxplot(churn_data_df$Item6)
#Count of outliers: 454, range: min whisker= 2, max whisker= 5
item7_boxplot <- boxplot(churn_data_df$Item7)
#Count of outliers: 426, range: min whisker= 2, max whisker= 5
item8_boxplot <- boxplot(churn_data_df$Item8)

#Treatment of outliers not retained
#Children column
churn_data_df$Children[churn_data_df$Children > 6] <- NA #Replacing outliers with NA
colSums(is.na(churn_data_df)) #Check NA values
churn_data_df$Children[is.na(churn_data_df$Children)] <- median(churn_data_df$Children, na.rm = TRUE)
colSums(is.na(churn_data_df)) #Check NA values
summary(churn_data_df$Children)#Median and mean stayed relatively the same 
#Income
outliers <- churn_data_df[which(churn_data_df$Income > 78300.00), ]#Excluding to outliers to df
str(outliers)
churn_data_df <- churn_data_df[!(churn_data_df$Income > 78300), ]#Drop outliers from analysis df
str(churn_data_df)
#Outage_sec_perweek
churn_data_df$Outage_sec_perweek[churn_data_df$Outage_sec_perweek > 19] <- NA #Replacing upper bound outliers with NA
churn_data_df$Outage_sec_perweek[churn_data_df$Outage_sec_perweek < 1.5] <- NA #Replacing lower bound outliers with NA
colSums(is.na(churn_data_df)) #Check NA values
churn_data_df$Outage_sec_perweek[is.na(churn_data_df$Outage_sec_perweek)] <- median(churn_data_df$Outage_sec_perweek, na.rm = TRUE)
colSums(is.na(churn_data_df)) #Check NA values
summary(churn_data_df$Outage_sec_perweek)#Median and mean stayed relatively the same
#Email
outliers_Email_Upper <- churn_data_df[which(churn_data_df$Email > 20), ]#Excluding upper bound outliers to df
str(outliers_Email_Upper)
outliers_Email_Lower <- churn_data_df[which(churn_data_df$Email < 4), ]#Excluding lower bound outliers to df
str(outliers_Email_Lower)
churn_data_df <- churn_data_df[!(churn_data_df$Email > 20), ]#Drop upper bound outliers from analysis df
churn_data_df <- churn_data_df[!(churn_data_df$Email < 4), ]#Drop lower bound outliers from analysis df
str(churn_data_df)
#Yearly_equip_failures
churn_data_df$Yearly_equip_failure[churn_data_df$Yearly_equip_failure > 2] <- NA #Replacing outliers with NA
colSums(is.na(churn_data_df)) #Check NA values
churn_data_df$Yearly_equip_failure[is.na(churn_data_df$Yearly_equip_failure)] <- median(churn_data_df$Yearly_equip_failure, na.rm = TRUE)
colSums(is.na(churn_data_df)) #Check NA values
summary(churn_data_df$Yearly_equip_failure)#Median and mean stayed relatively the same



#Data Exploration of chosen variables
variables_subset <- select(churn_data_df, Area, Income, Marital, Gender, Churn, Contract,
                            PaymentMethod, Tenure, MonthlyCharge, Bandwidth_GB_Year)
summary(variables_subset)

#Bar plots showing the distribution of each nominal variable
area_long <- variables_subset %>%
  pivot_longer(c(Area), names_to = "Column", values_to = "value")
ggplot(area_long, aes(value)) + 
  geom_bar() +
  facet_wrap(~Column)

marital_long <- variables_subset %>%
  pivot_longer(c(Marital), names_to = "Column", values_to = "value")
ggplot(marital_long, aes(value)) + 
  geom_bar() +
  facet_wrap(~Column)

gender_long <- variables_subset %>%
  pivot_longer(c(Gender), names_to = "Column", values_to = "value")
ggplot(gender_long, aes(value)) + 
  geom_bar() +
  facet_wrap(~Column)

churn_long <- variables_subset %>%
  pivot_longer(c(Churn), names_to = "Column", values_to = "value")
ggplot(churn_long, aes(value)) + 
  geom_bar() +
  facet_wrap(~Column)

contract_long <- variables_subset %>%
  pivot_longer(c(Contract), names_to = "Column", values_to = "value")
ggplot(contract_long, aes(value)) + 
  geom_bar() +
  facet_wrap(~Column)

pm_long <- variables_subset %>%
  pivot_longer(c(PaymentMethod), names_to = "Column", values_to = "value")
ggplot(pm_long, aes(value)) + 
  geom_bar() +
  facet_wrap(~Column)

#Bivariate visualizations for categorical variables
ggplot(variables_subset, aes(x = Churn, fill = Area)) + 
  geom_bar(position = "stack")
ggplot(variables_subset, aes(x = Churn, fill = Marital)) + 
  geom_bar(position = "stack")
ggplot(variables_subset, aes(x = Churn, fill = Gender)) + 
  geom_bar(position = "stack")
ggplot(variables_subset, aes(x = Churn, fill = Contract)) + 
  geom_bar(position = "stack")
ggplot(variables_subset, aes(x = Churn, fill = PaymentMethod)) + 
  geom_bar(position = "stack")



#Data Wrangling
#Transforming each category of Nominal variables Area, Marital, Gender, Churn, Contract, and Payment Method into dummy variables
dummy <- dummyVars("~ .", data = variables_subset)
new_variables_subset <- data.frame(predict(dummy, newdata = variables_subset))
#Removing ChurnNo column to prevent complete separation/ collinearity
new_variables_subset <- new_variables_subset[-c(13)]
glimpse(new_variables_subset)



# Exporting prepared dataset
write.csv(new_variables_subset, "PreparedDatasetTask2.csv", row.names = FALSE) #Relative path (was a hardcoded local user path)



#Logistic regression model
churn_mod_initial <- glm(formula = ChurnYes ~ ., family = binomial, data = new_variables_subset)
summary(churn_mod_initial)
#Removing columns with undefined coefficients due to their multicollinearity
model_data_final <- select(new_variables_subset, -c(AreaUrban,MaritalWidowed,GenderNonbinary,ContractTwo.Year,PaymentMethodMailed.Check))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = model_data_final)
summary(churn_mod)

#Application of Backward Stepwise Elimination Reduction Method
#Removed AreaRural
churn_mod <- glm(ChurnYes ~ .-AreaRural, family = binomial, data = model_data_final)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic.
step2 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step2)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban
step3 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step3)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year
step4 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step4)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year, GenderMale
step5 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year,GenderMale))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step5)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year, GenderMale, GenderFemale
step6 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year,GenderMale,GenderFemale))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step6)
summary(churn_mod)

#LOWEST AIC value: 4404.5 but still has an independent variable with a p value > 0.05, Marital.Separated p value = 0.11263
#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year, GenderMale, GenderFemale, Income
step7 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year,GenderMale,GenderFemale,Income))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step7)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year, GenderMale, GenderFemale, Income, MaritalSeparated
step8 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year,GenderMale,GenderFemale,Income,MaritalSeparated))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step8)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year, GenderMale, GenderFemale, Income, MaritalSeparated, MaritalMarried
step9 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year,GenderMale,GenderFemale,Income,MaritalSeparated,MaritalMarried))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step9)
summary(churn_mod)

#Removed AreaRural, PaymentMethodCredit.Card..automatic., AreaSuburban, ContractOne.year, GenderMale, GenderFemale, Income, MaritalSeparated, MaritalMarried, MaritalDivorced
step10 <- select(model_data_final, -c(AreaRural,PaymentMethodCredit.Card..automatic.,AreaSuburban,ContractOne.year,GenderMale,GenderFemale,Income,MaritalSeparated,MaritalMarried,MaritalDivorced))
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = step10)
summary(churn_mod)



#Predict values using Churn logistic model
final_data_set <- step10
churn_mod <- glm(ChurnYes ~ ., family = binomial, data = final_data_set)
summary(churn_mod)

churn.prob <- predict(churn_mod, type="response")
churn.pred <- ifelse(churn.prob > 0.5, "Yes", "No")
table(churn.pred)

#Created confusion Matrix
conf_matrix <- table(churn_data_df$Churn, churn.pred)
conf_matrix

#Calculating the accuracy
TP <- conf_matrix["Yes", "Yes"]
TN <- conf_matrix["No", "No"]
FP <- conf_matrix["No", "Yes"]
FN <- conf_matrix["Yes", "No"]

Accuracy = (TP + TN) / (TP + FP + TN + FN)
print(Accuracy)
