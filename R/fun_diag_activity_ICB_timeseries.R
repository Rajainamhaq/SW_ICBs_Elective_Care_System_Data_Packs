#####################################################################
#### function to create data frames for each Organization ###########
### Create Diagnosis Activity time series chart table ######
####################################################################

#create_main_df 
fun_diag_activity_ICB_timeseries <- function(icb_name) {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >= get_last_two_fy_start()) |>
   # filter(Organisation_Code == org_code)
    filter(ICB == icb_name)
  
   ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table
  
  data_rtt_monthly_num <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Diagnostic activity" & (FY %in% get_last_two_fy_labels_monthly())
           & Metric_Type == "Count") |>
    filter(Data_Source == "DM01") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") |>
    rename(diag_activity = rtt_perf_num) |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
  #  select(9,2,3,1,8) |>
    mutate(data_tye = "Diagnostic activity") |>
    
    select(Reporting_Period,Month,Month_Yr,FY,data_tye, diag_activity)
  
  ##########################################
  
  ## prepare 2nd table for diagnostic activity Plans
  data_rtt_monthly_plan <- data_RTT_datamarta |>
    filter(Reporting_Period >= (get_last_two_fy_start() %m+% years(1))) |>
    filter(Measure == "Diagnostic activity") |>
    filter(Data_Source == "Plans") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") |>
    rename(diag_activity = rtt_perf_num) |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    #  select(9,2,3,1,8) |>
    mutate(data_tye = "Diagnostic activity") |>
   
     select(Reporting_Period,Month,Month_Yr,FY,data_tye, diag_activity) |>
    
    # for sake of line graph back date the 25/26 target line to 24/25
    mutate(Reporting_Period = Reporting_Period %m-% years(1))
  data_rtt_monthly_plan$Reporting_Period <- as.Date( data_rtt_monthly_plan$Reporting_Period)
  
  ######## End of Plan Performance Table creation ###############################  
  
    ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  
  df_diag_activity <- rbind(data_rtt_monthly_num, data_rtt_monthly_plan) 
  
  df_diag_activity <- df_diag_activity |>
    mutate(
      date_timeseries = case_when(
       # FY == "25/26 WLMDS" ~ Reporting_Period %m-% years(1),
        FY == get_last_two_fy_labels_monthly()[2] ~ Reporting_Period %m-% years(1),
        .default = Reporting_Period
      )
    )
  
    return(df_diag_activity)
 }