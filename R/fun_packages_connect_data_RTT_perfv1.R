################################################
#### Load Libraries and Setup DB Connection#####
################################################

if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',
               reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2,openxlsx)

library(here)
here()

#setwd("C:/Users/raja.haq1/Documents/GitHub/Elective_Care_System_Data_Packs") 

#Look up Sheet
Orgs_lookup <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 1 )
spec_mod_lookup_Diag <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 2 )
spec_mod_lookup_RTT <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 3)
month_lookup <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 4)
YTD_lookup <- read_xlsx( here("data", "LookUps May25.xlsx"), sheet = 5)


#### load the RTT weekly saved data ######
data_RTT_read <- read_excel(here("data", "RTT_weekly_data.xlsx"),sheet = 1)
data_RTT_read$Reporting_Period <- as.Date(data_RTT_read$Reporting_Period)

#### load the RTT monthly saved data ######
data_RTT_datamart_read <- read_excel(here("data","RTT_monthly_data.xlsx"),sheet = 1)
data_RTT_datamart_read$Reporting_Period <- as.Date(data_RTT_datamart_read$Reporting_Period)

#### load the SUS_OPA saved data ######
data_SUS_OPA_read <- read_excel(here("data","RTT_SUS_OPA_data.xlsx"),sheet = 1)
data_SUS_OPA_read$Reporting_Period <- as.Date(data_SUS_OPA_read$Reporting_Period)

#### load the RTT weekly saved data ######
data_mhs_read <- read_excel(here("data","mhs_data.xlsx"),sheet = 1)
data_mhs_read$Reporting_Period <- as.Date(data_mhs_read$Reporting_Period)

#### load the ebi saved data ######

ebi_national_read <- read_excel(here("data","ebi_national_data.xlsx"),sheet = 1)
ebi_national_read$Reporting_Period <- as.Date(ebi_national_read$Reporting_Period)

############## End of connection ###################################################

# targets and baseline file extract
#target_baseline_file <- read_xlsx("data/data_RTT_target_baseline.xlsx",sheet=2)

## add this to data mart output form query
#data_RTT_datamart <- rbind(data_RTT_datamart,target_baseline_file)

#######################################################################################

