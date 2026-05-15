#####################################################################
#### function to create data frames for each Organization ###########
###  RTT Wait to first Activity ######
####################################################################

#create_main_df 
fun_Wait_to_1st_Activity_ORG_timeseries <- function(org_code) {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >= get_last_two_fy_start()) |>
    filter(Organisation_Code == org_code)
  #filter(Organisation_Code == "RH8")
  
  data_RTTt <- data_RTTt |>
    filter(Organisation_Code == org_code)
  #filter(Organisation_Code == "RH8")
 
   
  ## 2nd table WLMDS, for 24/25, 25/26 with numerator and denominator  
  # create table for Numerator
  data_rtt_wlmds_num <- data_RTTt |>
    #filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Wait to first" & (FY %in% get_last_two_fy_labels_wlmds())
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
    filter(Measure == "Wait to first" & (FY %in% get_last_two_fy_labels_wlmds())
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
  
  ## prepare 3rd table for rtt performance Plans
  data_rtt_perf_plan <- data_RTT_datamarta |>
   #  filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "Wait to first") |>
    filter(Data_Source == "Plans") |>
   # select(10,2,17,1,16,7,8) |>
    select(10,2,18,1,17,7,8) |>
    # select(17,1,16,7,8) |>
    pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
    
    group_by(`Org Short Name`, Organisation_Code, FY,Reporting_Period,Month) |>
    summarise(Denom_sum = sum(Denominator),
              Nume_sum = sum(Numerator),.groups = "drop") |>
    # arrange(Reporting_Period) |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    mutate(perf_perc = Nume_sum/Denom_sum) |>
    mutate(data_type = "Plan") |>
    
    select(Reporting_Period, Month, Month_Yr,FY, data_type, perf_perc) |>
    filter(Reporting_Period >= get_fy_start()) |>
    # for sake of line graph back date the 25/26 target line to 24/25
    mutate(Reporting_Period = Reporting_Period %m-% years(1))
   # data_rtt_perf_plan$Reporting_Period <- as.Date(data_rtt_perf_plan$Reporting_Period)
  
  ######## End of Plan Performance Table creation ###############################  
  
  ## get the Target  and Baseline Values for the table below and will get used in box display
  
  rtt_target <- data_RTT_datamarta |>
    filter(Data_Source == "Targets and baselines" & Measure == get_mar_target_label()
           & Measure_Type == "Wait to first") |>
 #   filter(Organisation_Code ==org_code) |>
    select(Metric_Value)
    rtt_targetv <- mean(as.numeric(rtt_target))
    
    rtt_baseline <- data_RTT_datamarta |>
      filter(Data_Source == "Targets and baselines" & Measure == get_current_fy_baseline()
             & Measure_Type == "Wait to first") |>
     #   filter(Organisation_Code ==org_code) |>
      select(Metric_Value)
    rtt_baselinev <- mean(as.numeric(rtt_baseline))

    
    # 4th table
    ## create Performance target table     
  
    #prepare target value for 4th table    
  data_rtt_target1 <- data_rtt_perf_plan |>
    select(1,2,3) |>
    mutate(FY = get_mar_target_label(),
           data_type = "RTT_target",
           perf_perc = rtt_targetv)
  # select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) 
  # for sake of line graph back date the 25/26 target line to 24/25
  #      Reporting_Period = Reporting_Period %m-% years(1))
  data_rtt_target1$Reporting_Period <- as.Date(data_rtt_target1$Reporting_Period)
  
  #prepare baseline value for 4th table    
  data_rtt_baseline1 <- data_rtt_perf_plan |>
    select(1,2,3) |>
    mutate(FY = get_current_fy_baseline(),
           data_type = "RTT_baseline",
           perf_perc = rtt_baselinev)
  # select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) 
  # for sake of line graph back date the 25/26 target line to 24/25
  #      Reporting_Period = Reporting_Period %m-% years(1))
  data_rtt_baseline1$Reporting_Period <- as.Date(data_rtt_baseline1$Reporting_Period)
  
  #combine target1 and baseline1
  data_rtt_target <- rbind(data_rtt_target1,data_rtt_baseline1)
  
  #substr(data_rtt_target$Month_Yr,5,6) <- 
  
  
  ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  
  names(data_rtt_target) <- names(data_rtt_wlmdst)
  names(data_rtt_perf_plan) <- names(data_rtt_wlmdst)  
  df_for_series <- rbind(data_rtt_wlmdst,data_rtt_perf_plan,data_rtt_target) 
  
  df_for_series <- df_for_series |>
    mutate(date_timeseries = ifelse(FY != get_last_two_fy_labels_wlmds()[2],Reporting_Period,Reporting_Period %m-% years(1)))
  df_for_series$date_timeseries <- as.Date(df_for_series$date_timeseries)
  
   return(df_for_series)
  ###### create a total row for the data frame #########
}