################################################
#### Load Libraries and Setup DB Connection#####
#### Save the data to be use for all qmd files #
################################################

if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',writexl, 
               reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2,openxlsx)
parameter_NHS_Blue <- rgb(0,94,184, maxColorValue = 255)
library(here)
here()
####################################
## Open connection data_WAREHOUSE ##
####################################
source(here("R","personal_credentials.R"))
con_warehouse <-
  DBI::dbConnect(
    drv = odbc::odbc(),
    driver = "ODBC Driver 18 for SQL Server",
    server = serv_warehouse,
    database = db_warehouse,
    VID = user,
    authentication ="ActiveDirectoryInteractive"
  )

#### read the SQL Query ######
data_RTT <- DBI::dbGetQuery(conn = con_warehouse,
                            statement = read_file(here("data","data_WAREHOUSE May 2025.sql")))

write.xlsx(data_RTT, file = here("data", "RTT_weekly_data.xlsx"), overwrite = TRUE)

################# End of connection ###########################################

# targets and baseline file extract
target_baseline_file <- read_xlsx(here("data", "data_RTT_target_baseline.xlsx"),sheet=2)

####################################
## Open connection data_Datamart ##
####################################
source(here("R","personal_credentials.R"))
con_datamart <-
  DBI::dbConnect(
    drv = odbc::odbc(),
    driver = "ODBC Driver 18 for SQL Server",
    server = serv_datamart,
    database = db_datamart,
    VID = user,
    authentication ="ActiveDirectoryInteractive"
  )

#### read the SQL Query ######
data_RTT_datamart_data <- DBI::dbGetQuery(conn = con_datamart,
                                          statement = read_file(here("data","data_DATAMART Dec 2025.sql")))

data_RTT_datamart <- rbind(data_RTT_datamart_data,target_baseline_file)

write.xlsx(data_RTT_datamart,file = here("data","RTT_monthly_data.xlsx"), overwrite = TRUE)

#### read the SQL Query ######
#### read the SQL Query ######
data_SUS_OPA <- DBI::dbGetQuery(conn = con_datamart,
                                statement = read_file(here("data","data_SUS_OPA Feb 2026.sql")))

write.xlsx(data_SUS_OPA,file = here("data","RTT_SUS_OPA_data.xlsx"),overwrite = TRUE)
############## End of connection ###################################################

#################################### 
## Open connection MHS ##
####################################

#data_mhs <- read_xlsx("data/data_mhs_20260220.xlsx")

source(here("R","personal_credentials_mhs.R"))
con_mhs <-
  DBI::dbConnect(
    drv = odbc::odbc(),
    driver = "ODBC Driver 17 for SQL Server",
    server = serv_mhs,
    database = db_mhs,
    uid = user_mhs,
    pwd = pwd_mhs
  #  authentication ="sq"
  )
#### read the SQL Query ######
data_mhs <- DBI::dbGetQuery(conn = con_mhs,
                                     statement = read_file(here("data","data_MHS Feb 2026.sql")))
write.xlsx(data_mhs, file = here("data","mhs_data.xlsx"), overwrite = TRUE)

### to get the EBI National median use query instead of excel file
ebi_national_data <- DBI::dbGetQuery(conn = con_mhs,
                                     statement = read_file(here("data","National Median EBI procedures.sql")))
write.xlsx(ebi_national_data,file = here("data","ebi_national_data.xlsx"),overwrite = TRUE)

############## End of connection ###################################################

#data_SUS_OPA <- read_xlsx("data/data_SUS_OPA_20260216.xlsx")
#data_Plans <- read_xlsx("data/data_Plans_20260216.xlsx")

#Look up Sheet
Orgs_lookup <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 1 )
spec_mod_lookup_Diag <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 2 )
spec_mod_lookup_RTT <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 3)
month_lookup <- read_xlsx( here("data", "LookUps May25.xlsx"),sheet = 4)
YTD_lookup <- read_xlsx( here("data", "LookUps May25.xlsx"), sheet = 5)

#####################################################################################
