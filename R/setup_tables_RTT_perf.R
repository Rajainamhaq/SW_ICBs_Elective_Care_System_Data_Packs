#########################################
### Setup the data_WAREHOUSE table ######
########################################

#Join the Org name,ICB and Org Type
data_RTT <- left_join(data_RTT_read,Orgs_lookup, by = c("Organisation_Code" = "Org Code"))

data_RTT$Specialty_Modality <- ifelse(substr(data_RTT$TFC_or_Diagmodality,1,5) == "Other", data_RTT$TFC_or_Diagmodality,
                                      ifelse(is.na(data_RTT$TFC_or_Diagmodality), "",
                                             ifelse(data_RTT$Data_Source == "WLMDS Diagnostics",spec_mod_lookup_Diag$Description1[match(data_RTT$TFC_or_Diagmodality,spec_mod_lookup_Diag$Text)],
                                                    spec_mod_lookup_RTT$`TFC desc`[match(data_RTT$TFC_or_Diagmodality,spec_mod_lookup_RTT$Code1)]
                                             )))
#get the max date for RTT and Diag Data Source col to create other cols
max_date_rtt <- data_RTT_read |>
  filter(Data_Source == "WLMDS RTT") |>
  summarise(max_date_rttd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_rttd)
max_date_diag <- data_RTT_read |>
  filter(Data_Source == "WLMDS Diagnostics") |>
  summarise(max_date_diagd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_diagd)
max_date_starts <- data_RTT_read |>
  filter(Data_Source == "WLMDS Starts") |>
  summarise(max_date_startsd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_startsd)
max_date_stops <- data_RTT_read |>
  filter(Data_Source == "WLMDS Stops") |>
  summarise(max_date_stopsd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_stopsd)

#get the start of current financial year
date_value <- Sys.Date()
# Extract year and month
yr <- as.integer(format(date_value, "%Y"))
mo <- as.integer(format(date_value, "%m"))

# Calculate financial year start
fy_start_date <- if (mo >= 4) {
  as.Date(paste0(yr, "-04-01"))
} else {
  as.Date(paste0(yr - 1, "-04-01"))
}

new_fy_date <- fy_start_date

#create rest of the cols 
data_RTTt <- data_RTT |>
  mutate(Latest_period = ifelse( (data_RTT$Data_Source == "WLMDS RTT") & (Reporting_Period == max_date_rtt) ,1,
                                 ifelse( (data_RTT$Data_Source == "WLMDS Diagnostics") & (Reporting_Period == max_date_diag),1,
                                         ifelse(( data_RTT$Data_Source == "WLMDS Starts") & (Reporting_Period == max_date_starts),1,
                                                ifelse((data_RTT$Data_Source == "WLMDS Stops") & (Reporting_Period == max_date_stops),1,0))))
  )


#set up look table for creating last two columns e.g. Month and FY 
week_ending_selected <- c('28-Apr-24', '02-Jun-24','30-Jun-24','04-Aug-24','01-Sep-24','29-Sep-24','03-Nov-24','01-Dec-24','29-Dec-24','02-Feb-25','02-Mar-25',
                          '30-Mar-25','04-May-25','01-Jun-25','29-Jun-25','03-Aug-25','31-Aug-25','28-Sep-25','02-Nov-25','30-Nov-25','04-Jan-26','01-Feb-26','01-Mar-26','29-Mar-26',
                          '03-May-26','31-May-26','28-Jun-26','02-Aug-26','30-Aug-26','04-Sep-26','01-Nov-26','29-Nov-26','03-Jan-27','31-Jan-27','28-Feb-27','28-Mar-27')



month_year <- c('Apr-24','May-24','Jun-24','Jul-24','Aug-24','Sep-24','Oct-24','Nov-24','Dec-24','Jan-25','Feb-25','Mar-25',
                'Apr-25','May-25','Jun-25','Jul-25','Aug-25','Sep-25','Oct-25','Nov-25','Dec-25','Jan-26','Feb-26','Mar-26',
                'Apr-26','May-26','Jun-26','Jul-26','Aug-26','Sep-26','Oct-26','Nov-26','Dec-26','Jan-27','Feb-27','Mar-27')                  
month_name <- c('Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar',
                'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar',
                'Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar')                             
lup_df_month_FY <- data.frame(week_ending_selected,month_year)   

lup_df_month_FY$week_ending_selected <- as.Date(lup_df_month_FY$week_ending_selected,format = "%d-%b-%y")
lup_df_month_FY <- lup_df_month_FY |>
  mutate(Month = str_sub(month_year,1,3)) |>
  mutate(FY = ifelse(month(week_ending_selected) >=4,
                     paste0(year(week_ending_selected), '/',str_sub(year(week_ending_selected)+1,3,4)),
                     paste0(year(week_ending_selected)-1,'/',str_sub(year(week_ending_selected),3,4)))) |>
  mutate(FY = paste(str_sub(FY,3,7),'WLMDS') ) 
#mutate(FY = paste(FY,'WLMDS'))

## script to get the latest week if it not present in look up above for time series plot
chk_latest_wk_wlmds <-  data.frame(week_ending_selected = c(max(data_RTT_read$Reporting_Period)))

chk_latest_wk_wlmds <- chk_latest_wk_wlmds |>
  mutate(week_ending_selected = as.Date(week_ending_selected, origin = "1970-01-01"))

chk_latest_wk_wlmds <- left_join(chk_latest_wk_wlmds,lup_df_month_FY, by = "week_ending_selected")

## if the data frame with latest date has NAs in it then replace them before joining back to main data frame
chk_latest_wk_wlmds <- chk_latest_wk_wlmds |>
  mutate(month_year = ifelse(is.na(chk_latest_wk_wlmds$month_year),
                             paste0(format(chk_latest_wk_wlmds$week_ending_selected,"%b-%y")),chk_latest_wk_wlmds$month_year)) |>
  mutate(Month = str_sub(month_year,1,3)) |>
  mutate(FY = ifelse(month(week_ending_selected) >=4,
                     paste0(year(week_ending_selected), '/',str_sub(year(week_ending_selected)+1,3,4)),
                     paste0(year(week_ending_selected)-1,'/',str_sub(year(week_ending_selected),3,4)))) |>
  mutate(FY = paste(str_sub(FY,3,7),'WLMDS') )

## combine the latest week script to the main look up data frame
lup_df_month_FY <- rbind(lup_df_month_FY,chk_latest_wk_wlmds)
## if latest week is already in look up then delete this duplicate
lup_df_month_FY <- distinct(lup_df_month_FY)


## now join the look up in to main data frame only for Data Sources 'WLMDS RTT' & 'WLMDS Diagnostic' 
## while other data sources like 'WLMDS Starts/Stops just use the Report_Period column instead of created lockup.
## 1st create Month column and then FY

# as reding from excle now so convert POSIXct to date fomrat
data_RTTt$Reporting_Period <- as.Date(data_RTTt$Reporting_Period)

## Create Month Column
data_RTTt <- bind_rows(
  data_RTTt |> filter(Data_Source %in% c("WLMDS RTT", "WLMDS Diagnostics")) |>
    left_join(lup_df_month_FY |> select(week_ending_selected,Month), by = c("Reporting_Period" = "week_ending_selected")),
  data_RTTt |>
    filter(!Data_Source %in% c("WLMDS RTT", "WLMDS Diagnostics")) |>
    mutate(Month = format(as.Date(Reporting_Period),"%b"))
)
## Create FY Column
data_RTTt <- bind_rows(
  data_RTTt |> filter(Data_Source %in% c("WLMDS RTT", "WLMDS Diagnostics")) |>
    left_join(lup_df_month_FY |> select(week_ending_selected,FY), by = c("Reporting_Period" = "week_ending_selected")),
  data_RTTt |>
    filter(!Data_Source %in% c("WLMDS RTT", "WLMDS Diagnostics")) |>
    mutate(FY = ifelse(month(Reporting_Period) >=4,
                       paste0(year(Reporting_Period), '/',str_sub(year(Reporting_Period)+1,3,4)),
                       paste0(year(Reporting_Period)-1,'/',str_sub(year(Reporting_Period),3,4)))) |>
    mutate(FY = paste(str_sub(FY,3,7),'WLMDS') )
)
###############################################################################################################



#########################################
### Setup the data_Datamart table #######
#########################################

## NOTE ##
# as the plans for new year 26/27 not published yet so will be using the previous year plans until the new one is published.
# for that one will add one year to the current plan data.
# once the new plans are published then will take off this block of code.
## NOTE END ##

## use the previous year plans data if the current financial year not published yet(not appeared in the data)
# 1st get the current year start date
today <- Sys.Date()
year <- as.integer(format(today,"%Y"))
fy_start_date <- as.Date(
  if (today < as.Date(paste0(year,"-04-01"))) {
    paste0(year-1,"-04-01")
  } else {
    paste0(year,"-04-01")
  }
)
# 2nd filter to plan data and check if new plan data is in data set, keep old plan if data exist otherwise add a year in old plan
# to check no of rows in data frame for plans
df_plans_pub <- data_RTT_datamart_read |>
  filter(Data_Source == "Plans") |>
  filter(Reporting_Period >= fy_start_date) #|>
  #filter(Measure == "RTT Performance" | Measure == "Wait to first") 
# use no of rows and add one year to plan if no data for new year to replicate old to new year fy for visuals

if (nrow(df_plans_pub) == 0) {
  data_RTT_datamart_read <- data_RTT_datamart_read |>
    bind_rows(
      data_RTT_datamart_read |>
        filter(Reporting_Period < fy_start_date & Reporting_Period >= (fy_start_date %m-% years(1))) |>
        filter(Data_Source == "Plans") |> # & (Measure == "RTT Performance" | Measure == "Wait to first")) |>
        mutate(Reporting_Period = Reporting_Period %m+% years(1)) #|>
        #filter(Reporting_Period >= fy_start_date)
    ) 
}


#Join the Org name,ICB and Org Type
data_RTT_datamart <- left_join(data_RTT_datamart_read,Orgs_lookup, by = c("Organisation_Code" = "Org Code"))

data_RTT_datamart$Specialty_Modality <- ifelse(data_RTT_datamart$TFC_or_Diagmodality == "","",
                                               ifelse(data_RTT_datamart$Data_Source == "DM01",
                                                      spec_mod_lookup_Diag$Description1[match(data_RTT_datamart$TFC_or_Diagmodality,spec_mod_lookup_Diag$Text)],
                                                      spec_mod_lookup_RTT$`TFC desc`[match(data_RTT_datamart$TFC_or_Diagmodality,spec_mod_lookup_RTT$Code1)]
                                               ))


##########################

diag_lookup <- setNames(spec_mod_lookup_Diag[[3]], spec_mod_lookup_Diag[[1]])   # col 3 by col 1
other_lookup <- setNames(spec_mod_lookup_RTT[[5]], spec_mod_lookup_RTT[[1]]) # col 5 by col 1

# Vectorized result using nested ifelse
data_RTT_datamart$Specialty_Modality1 <- ifelse(
  data_RTT_datamart$Data_Source == "Cancer Waiting Times",
  data_RTT_datamart$TFC_or_Diagmodality,
  ifelse(
    data_RTT_datamart$TFC_or_Diagmodality == "",
    "",
    ifelse(
      data_RTT_datamart$Measure == "Diagnostic activity",
      # Lookup from diag_lookup
      ifelse(!is.na(diag_lookup[data_RTT_datamart$TFC_or_Diagmodality]),
             diag_lookup[data_RTT_datamart$TFC_or_Diagmodality],
             "Other"),
      # Lookup from other_lookup
      ifelse(!is.na(other_lookup[data_RTT_datamart$TFC_or_Diagmodality]),
             other_lookup[data_RTT_datamart$TFC_or_Diagmodality],
             "Other")
    )
  )
)


## get the max date for RTT Monthly, DM01, JAR, SUS OPA, etc...##
#max data for RTT monthly
max_date_RTT_Monthly <- data_RTT_datamart_read |>
  filter(Data_Source == "RTT monthly" & Metric_Value != 0) |>
  summarise( max_date_rttd = max(Reporting_Period, na.rm = TRUE)) |>
  pull(max_date_rttd)
#max data for DM01
max_date_DM01 <- data_RTT_datamart_read |>
  filter(Data_Source == "DM01" & Metric_Value != 0) |>
  summarise( max_date_diagd = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_diagd)
#max data for JAR
max_date_JAR <- data_RTT_datamart_read |>
  filter(Data_Source == "JAR" & Metric_Value != 0) |>
  summarise( max_date_jard = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_jard)
#max data for SUS OPA
max_date_sus_opa <- data_RTT_datamart_read |>
  filter(Data_Source == "SUS OPA" & Metric_Value != 0) |>
  summarise( max_date_susopad = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_susopad)
#max data for 'SUS OPA for Spec Advice'
max_date_sus_opa_adv <- data_RTT_datamart_read |>
  filter(Data_Source == "SUS OPA for Spec Advice" & Metric_Value != 0) |>
  summarise( max_date_susopa_adv = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_susopa_adv)
#max data for Provider EROC
max_date_provid_eroc <- data_RTT_datamart_read |>
  filter(Data_Source == "Provider EROC" & Metric_Value != 0) |>
  summarise( max_date_eroc = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_eroc)
#max data for System EROC
max_date_sys_eroc <- data_RTT_datamart_read |>
  filter(Data_Source == "System EROC" & Metric_Value != 0) |>
  summarise( max_date_syseroc = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_syseroc)
#max data for Plan
max_date_plan <- data_RTT_datamart_read |>
  filter(Data_Source == "Plans" & Metric_Value != 0) |>
  summarise( max_date_pland = max(Reporting_Period, na.rm = TRUE)) |>
  pull( max_date_pland)
# get the min date
min_date_datamart <- data_RTT_datamart_read |>
  summarise(mindate = min(Reporting_Period)) |>
  pull(mindate)


## create data frame dates to get it join with main data frame to get the Latest period
df_dates = data.frame(c("RTT monthly","DM01","JAR","SUS OPA","SUS OPA for Spec Advice","Provider EROC","System EROC","Plans"),
                      c(min_date_datamart),
                      c(max_date_RTT_Monthly,max_date_DM01,max_date_JAR,max_date_sus_opa,max_date_sus_opa_adv,max_date_provid_eroc,
                        max_date_sys_eroc,max_date_plan))
colnames(df_dates) <- c("Data_Source","Earliest_date","Latest_date")

############################################################################################################
# get financial year labels e.g. "24/25 monthly" and 25/26 monthly or 25/26 monthly or 26/27 monthly.
# Determine current FY start year
current_start <- if (mo >= 4) {
  yr
} else {
  yr - 1
}

# Previous FY start year
prev_start <- current_start - 1

# Create labels
last_two_fy_labels_monthly <- c(
  sprintf("%02d/%02d monthly", prev_start %% 100, (prev_start + 1) %% 100),
  sprintf("%02d/%02d monthly", current_start %% 100, (current_start + 1) %% 100)
)
################################################################################################################

# get plan label for the current year e.g. 25/26 plans
# Determine FY start year
start_year <- if (mo >= 4) {
  yr
} else {
  yr - 1
}

# Create label
current_fy_plans_label <- sprintf(
  "%02d/%02d plans",
  start_year %% 100,
  (start_year + 1) %% 100
)
#######################################################################################################



#create a Latest period col
data_RTT_datamarta <- data_RTT_datamart |>
  left_join(df_dates |> select(Data_Source,lookupv = Latest_date), by = "Data_Source") |>
  mutate(Latest_period = if_else(Reporting_Period == lookupv,1,0)) |>           
  #create rest of cols e.g. Month, FY, 
  mutate(Month = month_lookup$Mon_name[match(month(Reporting_Period),month_lookup$Mon_num)]) |>
 # mutate(Month = month_lookup$Mon_name[match(month(as.Date(paste0(Reporting_Period, "01"), "%Y%m%d")),month_lookup$Mon_num)]) |>
  #mutate(FY = ifelse(Data_Source == "Plans","25/26 plans",
  mutate(FY = ifelse(Data_Source == "Plans" ,current_fy_plans_label,                   
                     ifelse(Reporting_Period < new_fy_date, last_two_fy_labels_monthly[1],last_two_fy_labels_monthly[2])
  )) 

############### End of data_Datamart table creation ########################      

week_ending <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")
week_ending_fn <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")


##################################################################
####### setup model health system table ##########################
##################################################################
# get the Org name, ICB and Org type by left join
data_mhst <- data_mhs_read
data_mhst <- left_join(data_mhst,Orgs_lookup, by = c("Organisation_Code" = "Org Code"))

# get the Specialty_Modality using look up sheet.
# and lookup table to be used is spec_mod_lookup_RTT
spec_mod_lookup_RTT_mhs <- spec_mod_lookup_RTT |>
  rename(tf_title = `Treatment Function Title`)

data_mhst <- data_mhst |>
  left_join(spec_mod_lookup_RTT_mhs, by = c("TFC_or_Diagmodality" = "Code1")) |>
  mutate(
    Specialty_Modality = case_when(
      TFC_or_Diagmodality == "All" ~ "",
      !is.na(tf_title) ~ tf_title,  
      TRUE ~ TFC_or_Diagmodality
    )
  )

# get the min and max dates for HES and National Theater Data_Source to create latest period flag.
theatre_data_date <- data_mhs_read |>
  filter(Data_Source == "National Theatre Data Collection") 
theatre_data_date_min = min(theatre_data_date$Reporting_Period)
theatre_data_date_max = max(theatre_data_date$Reporting_Period)
hes_date <- data_mhs_read |>
  filter(Data_Source == "HES") 
hes_date_min = min(hes_date$Reporting_Period)
hes_date_max = max(hes_date$Reporting_Period)  

# now create 'Latest Period' column with the help of dates above
data_mhst <- data_mhst |>
  mutate(latest_period = case_when(
    Data_Source == "HES" & Reporting_Period == hes_date_max ~ 1,
    Data_Source == "National Theatre Data Collection" &
      theatre_data_date_max == Reporting_Period ~ 1,
    .default = 0
  ))

# create a Month column with short month name
data_mhst <- data_mhst |>
  mutate(Reporting_Period = as.Date(Reporting_Period)) |>
  mutate(Month = format(Reporting_Period,"%b"))

# create FY column.
data_mhst <- data_mhst |>
  mutate(
    FY_start_year = if_else(month(Reporting_Period) >= 4, year(Reporting_Period), year(Reporting_Period) - 1),
    FY = paste0(substr(FY_start_year, 3, 4), "/", substr(FY_start_year + 1, 3, 4))
  )

# match the column names as in table and remove extra columns not needed
data_mhst <- data_mhst |>
  rename(`Org name` = `Org Short Name`) |>
  select(-Code2, -tf_title, -Group, -`TFC desc`, -FY_start_year)

## end of MHS table creation ##

# create EBI Procedure table
# data for ebi national procedures.
ebi_national <- ebi_national_read |>
  filter(Reporting_Period == max(Reporting_Period)) |>
  select(ebi_Procedure,`National median`)

################# End of main data frame creation #############


##################################################################
####### setup SUS OPA table ##########################
##################################################################
# get the Org name, ICB and Org type by left join
data_SUS_OPAt <- data_SUS_OPA_read

data_SUS_OPAt <- data_SUS_OPAt |>
  left_join(Orgs_lookup, by = c("Organisation_Code" = "Org Code")) |>
  mutate(Reporting_Period = as.Date(Reporting_Period)) |>
  mutate(Latest_Period = if_else(Reporting_Period == max(Reporting_Period),1,0)) |>
  mutate(Month = format(Reporting_Period,"%b")) |>
  mutate(
    FY_start_year = if_else(month(Reporting_Period) >= 4, year(Reporting_Period), year(Reporting_Period) - 1),
    FY = paste0(substr(FY_start_year, 3, 4), "/", substr(FY_start_year + 1, 3, 4))
  )

######################################################################################################################   

