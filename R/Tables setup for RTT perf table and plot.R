

if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2,kableExtra,knitr)


setwd("C:/Users/NM2.62TTY4B6/OneDrive - NHS/Documents/Elective Activity/Quarto/System Packs")
# main data from data warehouse (will be replaced with query)
data_RTT <- read_xlsx("data_Warehouse_Apr 25.xlsx")
data_RTT_datamart <- read_xlsx("data_Datamart_Apr 25.xlsx")

#Lookup Sheet
Orgs_lookup <- read_xlsx("LookUps May25.xlsx",sheet = 1 )
spec_mod_lookup_Diag <- read_xlsx("LookUps May25.xlsx",sheet = 2 )
spec_mod_lookup_RTT <- read_xlsx("LookUps May25.xlsx",sheet = 3)
month_lookup <- read_xlsx("LookUps May25.xlsx",sheet = 4)
YTD_lookup <- read_xlsx("LookUps May25.xlsx", sheet = 5)
#lup_header <- c("Col1","Col2","Col3","Col4","Col5","Col6","Col7","Col8","Col9","Col10","Col11","Col12")
#colnames(YTD_lookup) <- lup_header



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


####################################################
###### Create RTT Performance Table #####
###################################################
   
  Baselinev <- 0.581
  Targetv <- 0.631

# take Denominator metric value     
RTT_denom <- data_RTTt |>
  filter( `Org Short Name` == "R Devon Uni" 
          & Measure == "RTT Performance" 
         & Metric_Type == "Denominator" 
         & !is.na(Specialty_Modality)) |>
  group_by(Specialty_Modality) |>
  summarise(Total_WL = sum(Metric_Value,na.rm = TRUE)) 
 # pull(Total_WL)
# take Numerator metric value
RTT_numer <- data_RTTt |>
  filter( `Org Short Name` == "R Devon Uni" & Measure == "RTT Performance" 
          & Metric_Type == "Numerator"
          & !is.na(Specialty_Modality)) |>
  group_by(Specialty_Modality) |>
  summarise(RTT_18weeks = sum(Metric_Value,na.rm = TRUE)) 
  #pull(RTT_18weeks)

# combine above two data frames
RTT_table <- left_join(RTT_numer,RTT_denom, by = "Specialty_Modality")
#calculate RTT performance %
RTT_tablet <- RTT_table |>
  mutate(RTT_percentage = RTT_18weeks/Total_WL) |>
  mutate(Baseline_value = Baselinev,
         Target_value = Targetv) |>
  mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
  mutate(Target = (RTT_percentage - Target_value)*100) |>
  mutate(RTT_percentage = RTT_percentage*100) |>
  arrange((Baseline)) |>
  select(-5,-6) |>
  rename("Specialty" = Specialty_Modality,
         "0-18 weeks" = RTT_18weeks,
         "Total WL" = Total_WL)

# for last row of Total Pathways, e.g. create data frame to bind with the RTT_table
sum_rtt18weeks <- c(sum(RTT_table$RTT_18weeks))
sum_totalwl <- c(sum(RTT_table$Total_WL))
Specialty_tp <- c("Total pathways")
RTT_table_total_pathways <- data.frame(Specialty_Modality=Specialty_tp,RTT_18weeks=sum_rtt18weeks,Total_WL=sum_totalwl)
RTT_table_total_pathways <- RTT_table_total_pathways |>
  mutate(RTT_percentage = RTT_18weeks/Total_WL) |>
  mutate(Baseline_value = Baselinev,
         Target_value = Targetv) |>
  mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
  mutate(Target = (RTT_percentage - Target_value)*100) |>
  mutate(RTT_percentage = RTT_percentage*100) |>
#  arrange((Baseline)) |>
  select(-5,-6) |>
  rename("Specialty" = Specialty_Modality,
         "0-18 weeks" = RTT_18weeks,
         "Total WL" = Total_WL)
  
#bind the total pathwys df to main df
RTT_tablet <- rbind(RTT_tablet,RTT_table_total_pathways)
  
######## End of RTT Performance Table creation ###############################

###############################################################################
##### Prepare Data for line chart ############################################
##############################################################################

## 1st, monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table

data_rtt_monthly_num <- data_RTT_datamarta |>
  filter(ICB == "Devon") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 monthly" | FY == "25/26 monthly")
         & Metric_Type == "Numerator") |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  group_by(FY, Month,Month_Yr) |>
  summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") 

data_rtt_monthly_denom <- data_RTT_datamarta |>
  filter(ICB == "Devon") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 monthly" | FY == "25/26 monthly") 
         & Metric_Type == "Denominator") |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  group_by(FY, Month,Month_Yr) |>
  summarise(rtt_perf_denom = sum(Metric_Value),.groups = "drop") 

#combine two tables into one to calculate perf_perc
data_rtt_monthlyt <- data_rtt_monthly_num |>
  left_join(data_rtt_monthly_denom, by = "Month_Yr",suffix = c("_denom","_num")) |>
  mutate(perf_perc = rtt_perf_num/rtt_perf_denom) |>
  mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
  select(9,2,3,1,8) |>
  mutate(data_tye = "RTT Monthly") |>
  rename(FY = FY_denom,
         Month = Month_denom) |>
  
  select(Reporting_Period,Month,Month_Yr,FY,,data_tye, perf_perc)
##########################################
            
## 2nd table WLMDS, for 24/25, 25/26 with numerator and denominator  
 # create table for Numerator
data_rtt_wlmds_num <- data_RTTt |>
  #filter(`Org Short Name` == "R Devon Uni") |>
   filter(ICB == "Devon") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 WLMDS" | FY == "25/26 WLMDS")
         & Metric_Type == "Numerator") |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  group_by(FY, Month,Month_Yr) |>
  summarise(wlmds_perf_num = sum(Metric_Value),.groups = "drop") 
# create table for denominator
data_rtt_wlmds_denom <- data_RTTt |>
  filter(ICB == "Devon") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 WLMDS" | FY == "25/26 WLMDS")
         & Metric_Type == "Denominator") |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  group_by(FY, Month,Month_Yr) |>
  summarise(wlmds_perf_denom = sum(Metric_Value),.groups = "drop") 
#combine two tables into one to calculate perf_perc
data_rtt_wlmdst <-data_rtt_wlmds_num |>
  left_join(data_rtt_wlmds_denom, by = "Month_Yr",suffix = c("_denom","_num")) |>
  mutate(perf_perc = wlmds_perf_num/wlmds_perf_denom) |>
  mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
  select(9,2,3,1,8) |>
  mutate(data_tye = "WLMDS") |>
  rename(FY = FY_denom,
         Month = Month_denom) |>
         
  select(Reporting_Period,Month,Month_Yr,FY,,data_tye, perf_perc)
  
######## End of WLMDS Performance Table creation ###############################

## prepare 3rd table for rtt performance Plans
data_rtt_perf_plan <- data_RTT_datamarta |>
 # filter(`Org Short Name` == "R Devon Uni") |>
  filter(ICB == "Devon") |>
  filter(Measure == "RTT Performance"  & FY == "25/26 plans") |>
  select(10,2,17,1,16,7,8) |>
 # select(17,1,16,7,8) |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  
  group_by(FY,Reporting_Period,Month) |>
  summarise(Denom_sum = sum(Denominator),
            Nume_sum = sum(Numerator),.groups = "drop") |>
 # arrange(Reporting_Period) |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  mutate(perf_perc = Nume_sum/Denom_sum) |>
  mutate(data_type = "Plan") |>
  select(Reporting_Period, Month,Month_Yr,FY, data_type,perf_perc) |>
# for sake of line graph back date the 25/26 target line to 24/25
  mutate(Reporting_Period = Reporting_Period %m-% years(1))
data_rtt_perf_plan$Reporting_Period <- as.Date(data_rtt_perf_plan$Reporting_Period)

######## End of Plan Performance Table creation ###############################  

# 4th table
## create Performance target table 
data_rtt_target <- data_rtt_perf_plan |>
  select(1,2,3) |>
  mutate(FY = "Mar-26 target",
         data_type = "RTT_target",
         perf_perc = 0.631)
 # select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) 
# for sake of line graph back date the 25/26 target line to 24/25
  #      Reporting_Period = Reporting_Period %m-% years(1))
  data_rtt_target$Reporting_Period <- as.Date(data_rtt_target$Reporting_Period)


#substr(data_rtt_target$Month_Yr,5,6) <- 
  

######################################################
### combine the data tables and plot time series #####
######################################################

names(data_rtt_target) <- names(data_rtt_monthlyt)
names(data_rtt_perf_plan) <- names(data_rtt_monthlyt)  
df_for_series <- rbind(data_rtt_monthlyt,data_rtt_wlmdst,data_rtt_perf_plan,data_rtt_target) 

df_for_series <- df_for_series |>
  mutate(date_timeseries = ifelse(FY != "25/26 WLMDS",Reporting_Period,Reporting_Period %m-% years(1)))
df_for_series$date_timeseries <- as.Date(df_for_series$date_timeseries)

###############################################################################
# get values for the box both for RTT monthly and wlmmds. e.g. perf % latest (max date)
box_monthly_RTT <- df_for_series |>
  filter(data_tye == "RTT Monthly") 
max_monthly_rtt_date <- max(box_monthly_RTT$Reporting_Period)
max_rtt_date_box <- as.character(format(max_monthly_rtt_date,"%b-%y"))
box_monthly_RTT <- box_monthly_RTT |>
  filter(Reporting_Period == max_monthly_rtt_date) 
  box_monthly_RTT_perf = as.numeric(box_monthly_RTT[1,6])
  
  box_wlmds_RTT <- df_for_series |>
    filter(data_tye == "WLMDS") 
  max_wlmds_rtt_date <- max(box_wlmds_RTT$Reporting_Period)
  max_wlmds_date_box <- as.character(format(max_wlmds_rtt_date,"%d-%b-%y"))
  box_wlmds_RTT <- box_wlmds_RTT |>
    filter(Reporting_Period == max_wlmds_rtt_date) 
  box_wlmds_RTT_perf = as.numeric(box_wlmds_RTT[1,6])  
  
  
  
  max_wlmds_date <- data_RTTt
  
  
########################################################################
  source("fun_for_box_value.R")
  box_value_test <- fun_for_box_value(df_for_series)

#df_for_series$date <- as.Date(paste0("01-",df_for_series$Month_Yr),format = "%d-%b-%y")

#get the perf_perc for lable "25/26 plan" line. 
value_2526_plan <- df_for_series[36,6]

# Plot
df_for_series |>
  select(date_timeseries, FY, perf_perc) |>
  ggplot(aes(x = date_timeseries, y = perf_perc, color = FY, linetype = FY)) +
  geom_line(size=1) +
  scale_x_date(date_labels = "%b",
               date_breaks = "1 month") +
  scale_linetype_manual(values = c("dashed", "dashed", "solid", "solid","dotted")) +  # Specify dotted lines
  scale_color_manual(values = c("#005EB8", "#768692", "#AE2573", "#00aaff","red")) + 
  #  geom_text(aes(label = round(perf_perc, 1)), position = position_nudge(y = 5), size = 3) +
  geom_text(
    aes(x = as.Date("2025-02-01"), y = 0.587, label = "25/26 plans"),  # Specify coordinates and text for "Group 2"
    color = "#AE2573", size = 3, fontface = "bold"  # Text styling for "Group 2"
  ) +
  geom_text(
    aes(x = as.Date("2025-02-01"), y = 0.634, label = "Mar-26 target"),  # Specify coordinates and text for "Group 2"
    color = "red", size = 3  # Text styling for "Group 2"
  ) +
  scale_y_continuous(limits = c(0.54, 0.65)) + 
  labs(x = NULL, y = NULL, title = "RTT Performance") +
  # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_bw() +
  theme(
    legend.position = "bottom",          # Move legend to bottom
    legend.title = element_blank(),      # Optional: remove legend title
    axis.text.x = element_text(angle = 45, hjust = 1),  # Optional: rotate x labels
    #   axis.text.y = element_text(fontface = "bold"),
    panel.grid.major.x = element_blank(),  # Remove major Y grid lines
    panel.grid.minor.x =  element_blank()  # Remove minor Y grid lines
  )

  
