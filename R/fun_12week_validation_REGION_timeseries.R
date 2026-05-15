#####################################################################
#### function to create data frames for each Organization ###########
###  12+ week validation ######
####################################################################

#create_main_df 
fun_12week_validation_REGION_timeseries <- function() {
  
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  
  #data_RTTt <- data_RTTt |>
  #  filter(ICB == icb_name)
  #filter(Organisation_Code == "RH8")
  
  
  ## 2nd table WLMDS, for 24/25, 25/26 with numerator and denominator  
  # create table for Numerator
  data_rtt_wlmds_num <- data_RTTt |>
    #filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "12+ week validation" & (FY %in% get_last_two_fy_labels_wlmds())
           & Metric_Type == "Numerator") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(wlmds_perf_num = sum(Metric_Value),.groups = "drop") |>
    mutate(Month_Yr =  ifelse(Month %in% c('Jan','Feb','Mar'),
                              paste0(Month,'-',str_sub(FY,4,5)),
                              paste0(Month,'-',str_sub(FY,1,2))))
  # create table for denominator
  data_rtt_wlmds_denom <- data_RTTt |>
    #filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "12+ week validation" & (FY %in% get_last_two_fy_labels_wlmds())
           & Metric_Type == "Denominator") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(wlmds_perf_denom = sum(Metric_Value),.groups = "drop") |>
    mutate(Month_Yr =  ifelse(Month %in% c('Jan','Feb','Mar'),
                              paste0(Month,'-',str_sub(FY,4,5)),
                              paste0(Month,'-',str_sub(FY,1,2))))
  
  #combine two tables into one to calculate perf_perc
  data_rtt_wlmdst <-data_rtt_wlmds_num |>
    left_join(data_rtt_wlmds_denom, by = "Month_Yr",suffix = c("_denom","_num")) |>
    mutate(perf_perc = wlmds_perf_num/wlmds_perf_denom) |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    select(9,2,3,1,8) |>
    mutate(data_tye = "WLMDS") |>
    rename(FY = FY_denom,
           Month = Month_denom) |>
    arrange(Reporting_Period) |>
    
    select(Reporting_Period,Month,Month_Yr,FY,data_tye, perf_perc)
  
  ######## End of WLMDS Performance Table creation ###############################
  
  rtt_targetv_val <- 0.9
 
   # 4th table
  ## create Performance target table     
  
  #prepare target value for 4th table    
  data_rtt_target1 <-  data_rtt_wlmdst |>
    select(1,2,3) |>
    mutate(FY = "Target (90%)",
           data_type = "Target",
           perf_perc = rtt_targetv_val)
  # select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) 
  # for sake of line graph back date the 25/26 target line to 24/25
  #      Reporting_Period = Reporting_Period %m-% years(1))
  data_rtt_target1$Reporting_Period <- as.Date(data_rtt_target1$Reporting_Period)
  
  
  
  ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  
  names(data_rtt_target1) <- names(data_rtt_wlmdst)
  df_for_series <- rbind(data_rtt_wlmdst,data_rtt_target1) 
  
  df_for_series <- df_for_series |>
    mutate(date_timeseries = ifelse(FY != get_last_two_fy_labels_wlmds()[2],Reporting_Period,Reporting_Period %m-% years(1))) 
    df_for_series$date_timeseries <- as.Date(df_for_series$date_timeseries) 
    df_for_series <- df_for_series |>
    filter(date_timeseries < get_fy_start())
  
  
  return(df_for_series)
  ###### create a total row for the data frame #########
}