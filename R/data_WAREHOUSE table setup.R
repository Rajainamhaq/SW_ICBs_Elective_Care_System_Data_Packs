

if(!require(pacman)) install.packages("pacman")
pacman::p_load(DBI,odbc,tidyverse,dtplyr,ggplot2,dplyr,lubridate,RMySQL,'readxl',reshape2,reactR,tidyr,plotly,gt,scales,DT,here,reshape2,kableExtra,knitr)


setwd("C:/Users/NM2.62TTY4B6/OneDrive - NHS/Documents/Elective Activity/Quarto/System Packs")
# main data from data warehouse (will be replaced with query)
data_RTT <- read_xlsx("data_Warehouse_Apr 25.xlsx")
data_RTT_datamart <- read_xlsx("data_Datamart Apr 2025 with target&baseline.xlsx")

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

###############################################################################
##### create Target and Baseline table to use in RTT Performance Table below ##
###############################################################################
target_basline_lup <- data_RTT_datamart |>
  filter(Data_Source == "Targets and baselines" & Measure_Type == "RTT Performance") |>
  select(Reporting_Period,Organisation_Code,Measure,Metric_Value,ICB)

####################################################
###### Create RTT Performance Table #####
###################################################
 # Baselinev <- 0.581
#  Targetv <- 0.631

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

#get the basline and target values to use below
baseline_value <- target_basline_lup |>
  filter(Organisation_Code == "RH8" & Measure == "Nov-24 baseline") |>
  select(Metric_Value)
  baselinev <- as.numeric(baseline_value)
  
target_value <- target_basline_lup |>
 # filter(Organisation_Code == "RH8" & Measure == "Mar-26 target") |>
  filter( Measure == "Mar-26 target") |>
  select(Metric_Value)
targetv <- mean(target_value$Metric_Value)



# combine above two data frames
RTT_table <- left_join(RTT_numer,RTT_denom, by = "Specialty_Modality")
#calculate RTT performance %
RTT_tablet <- RTT_table |>
  mutate(RTT_percentage = RTT_18weeks/Total_WL) |>
  mutate(Baseline_value = Baselinev,
         Target_value = Targetv) |>
  mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
  mutate(Target = (RTT_percentage - Target_value)*100) |>
  arrange((Baseline)) |>
  select(-5,-6)
  
######## End of RTT Performance Table creation ###############################

###############################################################################
##### Prepare Data for line chart ############################################
##############################################################################

## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator

data_rtt_monthly_num <- data_RTT_datamarta |>
  filter(`Org Short Name` == "R Devon Uni") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 monthly" | FY == "25/26 monthly")
         & Metric_Type == "Numerator") |>
  group_by(Reporting_Period, Month,FY,Organisation_Code,`Org Short Name`) |>
  summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") |>
  arrange(Reporting_Period)

data_rtt_monthly_denom <- data_RTT_datamarta |>
  filter(`Org Short Name` == "R Devon Uni") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 monthly" | FY == "25/26 monthly") 
         & Metric_Type == "Denominator") |>
  group_by(Reporting_Period, Month,FY,Organisation_Code,`Org Short Name`) |>
  summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") |>
  arrange(Reporting_Period)
            
data_rtt_monthly <- left_join(data_rtt_monthly_denom,data_rtt_monthly_num, by = "Reporting_Period", suffix = c("df1","df2"))

data_rtt_monthlyt <- data_rtt_monthly |>
  select(1,2,3,4,5,6,11) |>
  rename(Month = Monthdf1,
         FY = FYdf1,
         rtt_denominator = rtt_perf_numdf1,
         rtt_numerator = rtt_perf_numdf2,
         Organisation_Code = Organisation_Codedf1,
         Org_name = `Org Short Namedf1`) |>
  mutate(perf_perc = rtt_numerator/rtt_denominator) |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  mutate(data_type = "RTT monthly") |>
  select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) #wait for this table to be cbind with others for line plotting
 

## 2nd table WLMDS, for 24/25, 25/26 with numerator and denominator  
 # create table for denominator
data_rtt_wlmds_num <- data_RTTt |>
  filter(`Org Short Name` == "R Devon Uni") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 WLMDS" | FY == "25/26 WLMDS")
         & Metric_Type == "Numerator") |>
  group_by(Reporting_Period ,FY, Month,Organisation_Code,`Org Short Name`) |>
  summarise(wlmds_perf_num = sum(Metric_Value),.groups = "drop") |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  group_by(FY,Month,Month_Yr,Organisation_Code,`Org Short Name`) |>
  summarise(wlmds_perf_num1 = sum(wlmds_perf_num),.groups = "drop" ) 
    #sort by date
data_rtt_wlmds_nums <-  data_rtt_wlmds_num 
data_rtt_wlmds_nums$date_s <- as.Date(paste0("01-",data_rtt_wlmds_nums$Month_Yr),format = "%d-%b-%y")
data_rtt_wlmds_nums <- data_rtt_wlmds_nums |>
  arrange(FY,date_s) |>
  select(1:6)

 # create table for denominator
data_rtt_wlmds_denom <- data_RTTt |>
  filter(`Org Short Name` == "R Devon Uni") |>
  filter(Measure == "RTT Performance" & (FY == "24/25 WLMDS" | FY == "25/26 WLMDS")
         & Metric_Type == "Denominator") |>
  group_by(Reporting_Period ,FY, Month,Organisation_Code,`Org Short Name`) |>
  summarise(wlmds_perf_denom = sum(Metric_Value),.groups = "drop") |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  group_by(FY,Month,Month_Yr,Organisation_Code,`Org Short Name`) |>
  summarise(wlmds_perf_denom1 = sum(wlmds_perf_denom),.groups = "drop" ) 
#sort by date
data_rtt_wlmds_denoms <-  data_rtt_wlmds_denom 
data_rtt_wlmds_denoms$date_s <- as.Date(paste0("01-",data_rtt_wlmds_denom$Month_Yr),format = "%d-%b-%y")
data_rtt_wlmds_denoms <- data_rtt_wlmds_denoms |>
  arrange(FY,date_s) |>
  select(3,6)

data_rtt_wlmdst <- data_rtt_wlmds_nums|>
  left_join(data_rtt_wlmds_denoms, by = "Month_Yr",suffix = c("_denom","_num")) |>
  mutate(data_type = "WLMDS") |>
  mutate(wlmds_perf_perc = wlmds_perf_num1/wlmds_perf_denom1) |>
  #select(1,2,3,8,9) |>
  rename(perf_perc = wlmds_perf_perc,
         Org_name = 'Org Short Name') |>
  select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc)
  
######## End of WLMDS Performance Table creation ###############################

## prepare 3rd table for rtt performance Plans

data_rtt_perf_plan <- data_RTT_datamarta |>
  filter(`Org Short Name` == "R Devon Uni") |>
  filter(Measure == "RTT Performance"  & FY == "25/26 plans") |>
  select(10,2,17,1,16,7,8) |>
 # select(17,1,16,7,8) |>
  pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
  arrange(Reporting_Period) |>
  mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
  mutate(perf_perc = Numerator/Denominator) |>
  mutate(data_type = "Plan") |>
  rename(Org_name = 'Org Short Name') |>
  select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc)
# for sake of line graph back date the 25/26 target line to 24/25
data_rtt_perf_plan$Month_Yr <- ifelse( substr(data_rtt_perf_plan$Month_Yr,5,6) == "25",
                                    paste0(substr(data_rtt_perf_plan$Month_Yr,1,4),"24"),
                                    paste0(substr(data_rtt_perf_plan$Month_Yr,1,4),"25"))

######## End of Plan Performance Table creation ###############################  

## create Performance target table 
data_rtt_target <- data_rtt_perf_plan |>
  select(1,2,4,5) |>
  mutate(FY = "Mar-26 target",
         data_type = "RTT_target",
         perf_perc = 0.631) |>
  select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) 
# for sake of line graph back date the 25/26 target line to 24/25
data_rtt_target$Month_Yr <- ifelse( substr(data_rtt_target$Month_Yr,5,6) == "25",
                                    paste0(substr(data_rtt_target$Month_Yr,1,4),"24"),
                                    paste0(substr(data_rtt_target$Month_Yr,1,4),"25"))
  


#substr(data_rtt_target$Month_Yr,5,6) <- 
  

######################################################
### combine the data tables and plot time series #####
######################################################

df_for_series <- rbind(data_rtt_monthlyt,data_rtt_wlmdst,data_rtt_perf_plan,data_rtt_target)
df_for_series$date <- as.Date(paste0("01-",df_for_series$Month_Yr),format = "%d-%b-%y")

# Plot
df_for_series |>
  select(date, data_type, perf_perc) |>
  ggplot(aes(x = date, y = perf_perc, color = data_type)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b %y") +
  scale_y_continuous(limits = c(0.5, 0.7)) + 
  labs(x = "Month", y = "Percentage", title = "RTT Performance") +
 # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme_minimal()
  
