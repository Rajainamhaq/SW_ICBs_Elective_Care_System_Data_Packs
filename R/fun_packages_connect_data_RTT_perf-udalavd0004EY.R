################################################
#### Load Libraries and Setup DB Connection#####
################################################

if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2)

parameter_NHS_Blue <- rgb(0,94,184, maxColorValue = 255)

####################################
## Open connection data_WAREHOUSE ##
####################################
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
data_RTT <- DBI::dbGetQuery(conn = con_udal,
                         statement = read_file('data_WAREHOUSE Apr 2025.sql'))
################# End of connection ###########################################

####################################
## Open connection data_WAREHOUSE ##
####################################
source ("personal_credentials_Datamart.R")
con_datamart <-dbConnect(
  drv = odbc(),
  driver = "ODBC Driver 17 for SQL Server",
  server = serv,
  database = db,
  VID = user,
  authentication ="ActiveDirectoryInteractive"
)
#### read the SQL Query ######
data_RTT_datamart <- DBI::dbGetQuery(conn = con_datamart,
                            statement = read_file('data_DATAMART Apr 2025.sql'))
############## End of connection ###################################################

#Look up Sheet
Orgs_lookup <- read_xlsx("LookUps May25.xlsx",sheet = 1 )
spec_mod_lookup_Diag <- read_xlsx("LookUps May25.xlsx",sheet = 2 )
spec_mod_lookup_RTT <- read_xlsx("LookUps May25.xlsx",sheet = 3)
month_lookup <- read_xlsx("LookUps May25.xlsx",sheet = 4)
YTD_lookup <- read_xlsx("LookUps May25.xlsx", sheet = 5)

#####################################################################################

#########################################
### Setup the data_WAREHOUSE table ######
#########################################

#Join the Org name,ICB and Org Type
data_RTT <- left_join(data_RTT,Orgs_lookup, by = c("Organisation_Code" = "Org Code"))

data_RTT$Specialty_Modality <- ifelse(substr(data_RTT$TFC_or_Diagmodality,1,5) == "Other", data_RTT$TFC_or_Diagmodality,
                                      ifelse(is.na(data_RTT$TFC_or_Diagmodality), "",
                                             ifelse(data_RTT$Data_Source == "WLMDS Diagnostics",spec_mod_lookup_Diag$Description1[match(data_RTT$TFC_or_Diagmodality,spec_mod_lookup_Diag$Text)],
                                                    spec_mod_lookup_RTT$`TFC desc`[match(data_RTT$TFC_or_Diagmodality,spec_mod_lookup_RTT$Code1)]
                                             )))
#get the max date for RTT and Diag Data Source col to create other cols
max_date_rtt <- data_RTT |>
  filter(Data_Source == "WLMDS RTT") |>
  summarise(max_date_rttd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_rttd)
max_date_diag <- data_RTT |>
  filter(Data_Source == "WLMDS Diagnostics") |>
  summarise(max_date_diagd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_diagd)

new_fy_date <- as.Date("2025-04-01")

#create rest of the cols 
data_RTTt <- data_RTT |>
  mutate(Latest_period = ifelse( (data_RTT$Data_Source == "WLMDS RTT") & (Reporting_Period == max_date_rtt) ,1,
                                 ifelse( (data_RTT$Data_Source == "WLMDS Diagnostics") & (Reporting_Period == max_date_diag),1,0) ) ) |>
  mutate(Month = month_lookup$Mon_name[match(month(Reporting_Period),month_lookup$Mon_num)]) |>
  mutate(FY = ifelse(format(Reporting_Period,"%Y-%m") < format(new_fy_date,"%Y-%m") ,"24/25 WLMDS","25/26 WLMDS")) |>
  mutate(YTD = max_date_rtt) 



#########################################
### Setup the data_Datamart table #######
#########################################
#Join the Org name,ICB and Org Type
data_RTT_datamart <- left_join(data_RTT_datamart,Orgs_lookup, by = c("Organisation_Code" = "Org Code"))
data_RTT_datamart$Specialty_Modality <- ifelse(data_RTT_datamart$TFC_or_Diagmodality == "","",
                                               ifelse(data_RTT_datamart$Data_Source == "DM01",
                                                      spec_mod_lookup_Diag$Description1[match(data_RTT_datamart$TFC_or_Diagmodality,spec_mod_lookup_Diag$Text)],
                                                      spec_mod_lookup_RTT$`TFC desc`[match(data_RTT_datamart$TFC_or_Diagmodality,spec_mod_lookup_RTT$Code1)]
                                               ))

## get the max date for RTT Monthly, DM01, JAR, SUS OPA, etc...##
#max data for RTT monthly
max_date_RTT_Monthly <- data_RTT_datamart |>
  filter(Data_Source == "RTT monthly" & Metric_Value != 0) |>
  summarise( max_date_rttd = max(Reporting_Period, na.rm = TRUE)) |>
  pull(max_date_rttd)
#max data for DM01
max_date_DM01 <- data_RTT_datamart |>
  filter(Data_Source == "DM01" & Metric_Value != 0) |>
  summarise( max_date_diagd = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_diagd)
#max data for JAR
max_date_JAR <- data_RTT_datamart |>
  filter(Data_Source == "JAR" & Metric_Value != 0) |>
  summarise( max_date_jard = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_jard)
#max data for SUS OPA
max_date_sus_opa <- data_RTT_datamart |>
  filter(Data_Source == "SUS OPA" & Metric_Value != 0) |>
  summarise( max_date_susopad = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_susopad)
#max data for 'SUS OPA for Spec Advice'
max_date_sus_opa_adv <- data_RTT_datamart |>
  filter(Data_Source == "SUS OPA for Spec Advice" & Metric_Value != 0) |>
  summarise( max_date_susopa_adv = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_susopa_adv)
#max data for Provider EROC
max_date_provid_eroc <- data_RTT_datamart |>
  filter(Data_Source == "Provider EROC" & Metric_Value != 0) |>
  summarise( max_date_eroc = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_eroc)
#max data for System EROC
max_date_sys_eroc <- data_RTT_datamart |>
  filter(Data_Source == "System EROC" & Metric_Value != 0) |>
  summarise( max_date_syseroc = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_syseroc)
#max data for Plan
max_date_plan <- data_RTT_datamart |>
  filter(Data_Source == "Plans" & Metric_Value != 0) |>
  summarise( max_date_pland = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_pland)
# get the min date
min_date_datamart <- data_RTT_datamart |>
  summarise(mindate = min(Reporting_Period)) |>
  pull(mindate)


## create data frame dates to get it join with main data frame to get the Latest period
df_dates = data.frame(c("RTT monthly","DM01","JAR","SUS OPA","SUS OPA for Spec Advice","Provider EROC","System EROC","Plans"),
                      c(min_date_datamart),
                      c(max_date_RTT_Monthly,max_date_DM01,max_date_JAR,max_date_sus_opa,max_date_sus_opa_adv,max_date_provid_eroc,
                        max_date_sys_eroc,max_date_plan))
colnames(df_dates) <- c("Data_Source","Earliest_date","Latest_date")

#create a Latest period col
data_RTT_datamarta <- data_RTT_datamart |>
  left_join(df_dates |> select(Data_Source,lookupv = Latest_date), by = "Data_Source") |>
  mutate(Latest_period = if_else(Reporting_Period == lookupv,1,0)) |>           
  #create rest of cols e.g. Month, FY, 
  mutate(Month = month_lookup$Mon_name[match(month(Reporting_Period),month_lookup$Mon_num)]) |>
  mutate(FY = ifelse(Data_Source == "Plans","25/26 plans",
                     ifelse(Reporting_Period < new_fy_date,"24/25 monthly","25/26 monthly")
  )) 
### create YTD columns ###
#data_RTT_datamartb <- data_RTT_datamarta |>
# mutate(YTD = ifelse(Data_Source == "Plans",0,
#  ifelse(Reporting_Period < new_fy_date,0,
#      {
#         lookup_val <- df_dates$Latest_date[match(Data_Source,df_dates$Data_Source)]
#          row_index <- match(Month,YTD_lookup$Month)
#          col_index <- match(lookup_val,colnames(YTD_lookup))
#        YTD_lookup[row_index,col_index]
#       }     )))

############### End of data_Datamart table creation ########################      

week_ending <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")



################# End of main data frame creation #############



