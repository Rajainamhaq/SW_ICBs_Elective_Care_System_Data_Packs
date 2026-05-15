################################################
#### Load Libraries and Setup DB Connection#####
################################################

if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2)

parameter_NHS_Blue <- rgb(0,94,184, maxColorValue = 255)

#####################
## Open connection ##
#####################
source ("personal_credentials_UDAL.R")
con_udal <-dbConnect(
  drv = odbc(),
  driver = "ODBC Driver 17 for SQL Server",
  server = serv,
  database = db,
  VID = user,
  authentication ="ActiveDirectoryInteractive"
)
#### read the SQL Query ######
wlmds <- DBI::dbGetQuery(conn = con_udal,
                         statement = read_file('RTT WLMDS (latest week) Data.sql'))
Orgs_lookup <- read_xlsx("input_Reference.xlsx",sheet = 1 )
TFC_lookup <- read_xlsx("input_Reference.xlsx",sheet = 2 )
wlmds_pathways <- left_join(wlmds,Orgs_lookup, by = c("Organisation_Code" = "Org code"))
wlmds_pathways <- left_join(wlmds_pathways,TFC_lookup, by = c("Treatment_Function_Code" = "TFC_code"))
wlmds_pathways <- wlmds_pathways |>
  select(1:20,24) |>
  rename(Specialty = TFC_RTT_monthly)
wlmds_pathways <- as.data.frame(wlmds_pathways)
current_date <- format(Sys.Date(),"%d-%b-%y") 
week_ending <- format(unique(wlmds_pathways$derWeekEnding),"%d-%b-%y")