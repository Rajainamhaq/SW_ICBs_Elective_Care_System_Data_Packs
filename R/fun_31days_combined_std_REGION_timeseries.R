#####################################################################
#### function to create data frames for each Organization ###########
###  Create PIFU Utilisaton time series chart table ######
####################################################################

#create_main_df 
fun_31days_combined_std_REGION_timeseries <- function() {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >= get_last_two_fy_start()) #|>
   # filter(ICB == icb_name)
   # filter(Organisation_Code == org_code)
   # filter(Organisation_Code == "RH8")
  
   ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table
  
  data_rtt_monthly_num <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "SW CWT 31d Combined by Tumour Site" & (FY %in% get_last_two_fy_labels_monthly())
           & Metric_Type == "Numerator") |>
    filter(Data_Source == "Cancer Waiting Times") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") 
  
  data_rtt_monthly_denom <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "SW CWT 31d Combined by Tumour Site" & (FY %in% get_last_two_fy_labels_monthly()) 
           & Metric_Type == "Denominator") |>
    filter(Data_Source == "Cancer Waiting Times") |> # new filter added
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
  
  ## prepare 2nd table for pifu utilisation Plans
  data_rtt_perf_plan <- data_RTT_datamarta |>
     #filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "SW CWT 31d Combined by Tumour Site") |>
    filter(Data_Source == "Plans") |>
    select(11,10,2,18,1,17,7,8) |>
    # select(17,1,16,7,8) |>
    pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
    
    group_by(FY,Reporting_Period,Month) |>
    summarise(Denom_sum = sum(Denominator),
              Nume_sum = sum(Numerator),.groups = "drop") |>
    # arrange(Reporting_Period) |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    mutate(perf_perc = Nume_sum/Denom_sum) |>
    mutate(data_tye = "Plan") |>
    
    select(Reporting_Period, Month, Month_Yr,FY, data_tye, perf_perc) |>
    # for sake of line graph back date the 25/26 target line to 24/25
    mutate(Reporting_Period = Reporting_Period %m-% years(1))
    data_rtt_perf_plan$Reporting_Period <- as.Date(data_rtt_perf_plan$Reporting_Period)
    data_rtt_perf_plan <- data_rtt_perf_plan |>
      filter(Reporting_Period >= get_last_two_fy_start())
  
  ######## End of Plan Performance Table creation ###############################  
  
  ## get the Target  and Baseline Values for the table below and will get used in box display
  
  data_rtt_target <- data_rtt_perf_plan |>
      select(-FY, -data_tye,-perf_perc) |>
      mutate(FY = "Target (96%)",
             data_tye = "target",
             perf_perc = 0.96)
  
    
  ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  
#  names(data_rtt_target) <- names(data_rtt_monthlyt)
#  names(data_rtt_perf_plan) <- names(data_rtt_monthlyt)  
  df_cwt_31days_comb <- rbind(data_rtt_monthlyt,data_rtt_perf_plan,data_rtt_target) 
  
    df_cwt_31days_comb <- df_cwt_31days_comb |>
    mutate(
      date_timeseries = ifelse( FY == get_last_two_fy_labels_monthly()[2],Reporting_Period %m-% years(1), Reporting_Period ))
       
    df_cwt_31days_comb$date_timeseries <- as.Date(df_cwt_31days_comb$date_timeseries)
  
   return(df_cwt_31days_comb)
  ###### create a total row for the data frame #########
}