#for UDAL env
#setwd("C:/Users/raja.haq1/OneDrive - NHS/Documents/Elective Activity/Quarto/System Packs") 
#########################################
### Setup the data_WAREHOUSE table ######
#########################################
#source("fun_packages_connect_data_RTT_perf.R")

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
max_date_starts <- data_RTT |>
  filter(Data_Source == "WLMDS Starts") |>
  summarise(max_date_startsd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_startsd)
max_date_stops <- data_RTT |>
  filter(Data_Source == "WLMDS Stops") |>
  summarise(max_date_stopsd = max(Reporting_Period,na.rm = TRUE)) |>
  pull(max_date_stopsd)

new_fy_date <- as.Date("2025-04-01")

#create rest of the cols 
data_RTTt <- data_RTT |>
  mutate(Latest_period = ifelse( (data_RTT$Data_Source == "WLMDS RTT") & (Reporting_Period == max_date_rtt) ,1,
                                 ifelse( (data_RTT$Data_Source == "WLMDS Diagnostics") & (Reporting_Period == max_date_diag),1,
                                      ifelse(( data_RTT$Data_Source == "WLMDS Starts") & (Reporting_Period == max_date_starts),1,
                                            ifelse((data_RTT$Data_Source == "WLMDS Stops") & (Reporting_Period == max_date_stops),1,0))))
  )


## new addition to create Month and FY column as query has changed ##
## setup look up for creating last 2 columns of data frame
#set up look table for creating last two columns e.g. Month and FY 
week_ending_selected <- c('28-Apr-24', '02-Jun-24','30-Jun-24','04-Aug-24','01-Sep-24',
                          '29-Sep-24','03-Nov-24','01-Dec-24','29-Dec-24','02-Feb-25','02-Mar-25',
                          '30-Mar-25','04-May-25','01-Jun-25','29-Jun-25','03-Aug-25','31-Aug-25',
                          '28-Sep-25','02-Nov-25','30-Nov-25','04-Jan-26','01-Feb-26','01-Mar-26','29-Mar-26')
month_year <- c('Apr-24','May-24','Jun-24','Jul-24','Aug-24','Sep-24','Oct-24','Nov-24','Dec-24',
                'Jan-25','Feb-25','Mar-25','Apr-25','May-25','Jun-25','Jul-25','Aug-25','Sep-25',
                'Oct-25','Nov-25','Dec-25','Jan-26','Feb-26','Mar-26')                  
month_name <- c('Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Jan','Feb','Mar',
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
chk_latest_wk_wlmds <-  data.frame(week_ending_selected = c(max(data_RTTt$Reporting_Period)))
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

#data_RTTt <- distinct(data_RTTt)

## replaced code
##|>
 # mutate(Month = month_lookup$Mon_name[match(month(Reporting_Period),month_lookup$Mon_num)]) |>
  #mutate(FY = ifelse(format(Reporting_Period,"%Y-%m") < format(new_fy_date,"%Y-%m") ,"24/25 WLMDS","25/26 WLMDS")) |>
  #mutate(YTD = max_date_rtt) 



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
                                              
  
##########################

## get the max date for RTT Monthly, DM01, JAR, SUS OPA, etc...##
#max data for RTT monthly
max_date_RTT_Monthly <- data_RTT_datamart |>
  filter(Data_Source == "RTT monthly" & Metric_Value != 0) |>
  summarise( max_date_rttd = max(Reporting_Period, na.rm = TRUE)) |>
  pull(max_date_rttd)
#max data for DM01 (diagnostic activity)
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


############### End of data_Datamart table creation ########################      

week_ending <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")
week_ending_fn <- format(max(data_RTTt$Reporting_Period),"%d-%b-%y")


##################################################################
####### setup model health system table ##########################
##################################################################
# get the Org name, ICB and Org type by left join
data_mhst <- data_mhs
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
theatre_data_date <- data_mhs |>
  filter(Data_Source == "National Theatre Data Collection") 
  theatre_data_date_min = min(theatre_data_date$Reporting_Period)
  theatre_data_date_max = max(theatre_data_date$Reporting_Period)
hes_date <- data_mhs |>
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
  
  ## end of MHS table creatoin ##
  
################# End of main data frame creation ################################################


  ##################################################################
  ####### setup SUS OPA table ##########################
  ##################################################################
  # get the Org name, ICB and Org type by left join
  data_SUS_OPAt <- data_SUS_OPA
  
  data_SUS_OPAt <- data_SUS_OPAt |>
    left_join(Orgs_lookup, by = c("Organisation_Code" = "Org Code")) |>
    mutate(Reporting_Period = as.Date(paste0(Der_Activity_Month,"01"),"%Y%m%d")) |>
    mutate(Latest_Period = if_else(Reporting_Period == max(Reporting_Period),1,0)) |>
    mutate(Month = format(Reporting_Period,"%b")) |>
    mutate(
      FY_start_year = if_else(month(Reporting_Period) >= 4, year(Reporting_Period), year(Reporting_Period) - 1),
      FY = paste0(substr(FY_start_year, 3, 4), "/", substr(FY_start_year + 1, 3, 4))
    )
  
 ######################################################################################################################   
    
    
  
  
  
  
  
  
