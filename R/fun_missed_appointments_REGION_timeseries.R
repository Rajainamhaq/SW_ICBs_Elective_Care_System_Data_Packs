#####################################################################
#### function to create data frames for each Organization ###########
###  Create PIFU Utilisaton time series chart table ######
####################################################################

#create_main_df 
fun_missed_appointments_REGION_timeseries <- function() {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >= get_last_two_fy_start())
    #filter(ICB == icb_name)
   # filter(Organisation_Code == "RH8")
  
   ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table
  
  data_rtt_monthly_num <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Missed appointments" & (FY %in% get_last_two_fy_labels_monthly())
           & Metric_Type == "Numerator") |>
   # filter(Data_Source == "Provider EROC") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") 
  
  data_rtt_monthly_denom <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Missed appointments" & (FY %in% get_last_two_fy_labels_monthly()) 
           & Metric_Type == "Denominator") |>
   # filter(Data_Source == "SUS OPA") |> # new filter added
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
    
    select(Reporting_Period,Month,Month_Yr,FY,data_tye, perf_perc)
  
  ##########################################
  
  df_pifu_utilisationa <- data_rtt_monthlyt
  
  # create table for limit line in chart
  pifu_limit <- df_pifu_utilisationa |>
    filter(Reporting_Period <= (get_fy_end_march_start() %m-% years(1))) |>
    select(-FY, - data_tye, -perf_perc) |>
    mutate(FY = "Limit (5%)",
           data_tye = "Limit",
           perf_perc = 0.05)
  
  #join the limit value in the main data frame table
  df_pifu_utilisation <- rbind(df_pifu_utilisationa,pifu_limit)
  
  df_pifu_utilisation <- df_pifu_utilisation |>
    mutate(
      date_timeseries = ifelse( FY == get_last_two_fy_labels_monthly()[2],Reporting_Period %m-% years(1), Reporting_Period ))
  
  
  df_pifu_utilisation$date_timeseries <- as.Date(df_pifu_utilisation$date_timeseries)
  
   return(df_pifu_utilisation)
  ###### create a total row for the data frame #########
}