#####################################################################
#### function to create data frames for each Organization ###########
###  Spec Advice utilization - pre referral line chart ######
####################################################################

#create_main_df 
fun_pre_referral_utilisation_ICB_timeseries <- function(icb_name) {
  
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >= get_last_two_fy_start()) |>
    filter(ICB == icb_name)
  # filter(Organisation_Code == "RH8")
  
  data_RTTt <- data_RTTt |>
    filter(ICB == icb_name)
  #filter(Organisation_Code == "RH8")
  
  ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table
  
  data_rtt_monthly_num <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Spec Advice utilisation - pre referral" & (FY %in% get_last_two_fy_labels_monthly())
           & Metric_Type == "Numerator") |>
    # filter(Data_Source == "System EROC") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") 
  
  data_rtt_monthly_denom <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Spec Advice utilisation - pre referral" & (FY %in% get_last_two_fy_labels_monthly()) 
           & Metric_Type == "Denominator") |>
    # filter(Data_Source == "System EROC") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_denom = sum(Metric_Value),.groups = "drop") 
  
  #combine two tables into one to calculate perf_perc
  data_rtt_monthlyt <- data_rtt_monthly_num |>
    left_join(data_rtt_monthly_denom, by = "Month_Yr",suffix = c("_denom","_num")) |>
    mutate(perf_perc = 100*(rtt_perf_num/rtt_perf_denom)) |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    select(9,2,3,1,8) |>
    mutate(data_tye = "RTT Monthly") |>
    rename(FY = FY_denom,
           Month = Month_denom) |>
    
    select(Reporting_Period,Month,Month_Yr,FY,data_tye, perf_perc)
  ##########################################
  
  ## get the Target  and Baseline Values for the table below and will get used in box display
  Targetv_spec_adv <- 12.6
  
  #Reporting_Period <- seq(as.Date("2025-04-01"), as.Date("2026-03-01"), by = "month")
  Reporting_Period <- seq(get_fy_start(), get_fy_end_march_start(), by = "month")
  
  data_target <- data.frame(
    Reporting_Period,
    Month = format(Reporting_Period, "%b"),
    Month_Yr = format(Reporting_Period, "%b-%y"),
    FY = "Target (12.6%)",
    data_tye = "Target",
    perf_perc = Targetv_spec_adv
  )
  
  ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  
  df_for_series <- rbind(data_rtt_monthlyt,data_target)
  
  ## align the dates to Apr to Mar for the line chart
  df_for_series <- df_for_series |>
    mutate(date_timeseires = case_when(
      FY == get_last_two_fy_labels_monthly()[1] ~ Reporting_Period %m+% years(1),
      .default = Reporting_Period
    ))
  
  
  return(df_for_series)
  ###### create a total row for the data frame #########
}