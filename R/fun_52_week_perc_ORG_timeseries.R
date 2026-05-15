#####################################################################
#### function to create data frames for each Organization ###########
###  RTT % Performance slide 2######
####################################################################

#create_main_df 
fun_52_week_perc_ORG_timeseries <- function(org_code) {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >= get_last_two_fy_start()) |>
    filter(Organisation_Code == org_code)
    #filter(Organisation_Code == "RH8")
  
  data_RTTt <- data_RTTt |>
    filter(Organisation_Code == org_code)
   # filter(Organisation_Code == "RH8")
  
  ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from data mart table
  
  data_rtt_monthly_num <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "52+ week %" & ( FY %in% get_last_two_fy_labels_monthly())
           & Metric_Type == "Numerator") |>
    filter(Data_Source == "RTT monthly") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(rtt_perf_num = sum(Metric_Value),.groups = "drop") 
  
  data_rtt_monthly_denom <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(Measure == "52+ week %" & ( FY %in% get_last_two_fy_labels_monthly()) 
           & Metric_Type == "Denominator") |>
    filter(Data_Source == "RTT monthly") |> # new filter added
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
  
  ## 2nd table WLMDS, for 24/25, 25/26 with numerator and denominator  
  # create table for Numerator
  data_rtt_wlmds_num <- data_RTTt |>
    #filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "52+ week %"  & (FY %in% get_last_two_fy_labels_wlmds())
           & Metric_Type == "Numerator") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(wlmds_perf_num = sum(Metric_Value),.groups = "drop") |>
    mutate(Month_Yr =  ifelse(Month %in% c('Jan','Feb','Mar'),
                              paste0(Month,'-',str_sub(FY,4,5)),
                              paste0(Month,'-',str_sub(FY,1,2))))
  
   # create table for denominator
  data_rtt_wlmds_denom <- data_RTTt |>
    # filter(ICB == "Devon") |>
    filter(Measure == "52+ week %" & (FY %in% get_last_two_fy_labels_wlmds())
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
    
    select(Reporting_Period,Month,Month_Yr,FY,,data_tye, perf_perc)
  
  ######## End of WLMDS Performance Table creation ###############################
  
  ## prepare 3rd table for rtt performance Plans
  data_rtt_perf_plan <- data_RTT_datamarta |>
    # filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "52+ week %") |>
    filter(Data_Source == "Plans") |>
    #select(10,2,17,1,16,7,8) |>
    select(10,2,18,1,17,7,8) |>
    # select(17,1,16,7,8) |>
    pivot_wider(names_from = Metric_Type, values_from = Metric_Value) |>
    
    group_by(`Org Short Name`, Organisation_Code, FY,Reporting_Period,Month) |>
    summarise(Denom_sum = sum(Denominator),
              Nume_sum = sum(Numerator),
              .groups = "drop") |>
    # arrange(Reporting_Period) |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    mutate(perf_perc = Nume_sum/Denom_sum) |>
    mutate(data_type = "Plan") |>
    
    select(Reporting_Period, Month, Month_Yr,FY, data_type, perf_perc) |>
    # for sake of line graph back date the 25/26 target line to 24/25
    mutate(Reporting_Period = Reporting_Period %m-% years(1))
    data_rtt_perf_plan$Reporting_Period <- as.Date(data_rtt_perf_plan$Reporting_Period)
  
  ######## End of Plan Performance Table creation ###############################  
  
  ## get the Target  and Baseline Values for the table below and will get used in box display
  
    # 4th table
    ## create Performance target table     
    
    rtt_targetv <- 0.01
    #prepare target value for 4th table    
    data_rtt_target <- data_rtt_perf_plan |>
      select(1,2,3) |>
      mutate(FY = get_mar_target_label(),
             data_type = "RTT_target",
             perf_perc = rtt_targetv)
    # select(Org_name,Organisation_Code,FY,Month,Month_Yr,data_type,perf_perc) 
    # for sake of line graph back date the 25/26 target line to 24/25
    #      Reporting_Period = Reporting_Period %m-% years(1))
    data_rtt_target$Reporting_Period <- as.Date(data_rtt_target$Reporting_Period)
  
  
  ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  
  names(data_rtt_target) <- names(data_rtt_monthlyt)
  names(data_rtt_perf_plan) <- names(data_rtt_monthlyt)  
  df_for_series <- rbind(data_rtt_monthlyt,data_rtt_wlmdst,data_rtt_perf_plan,data_rtt_target) 
  
  ### get the 2nd lable in vector to use in below mutate to get it automated
  second_label_wlmds <- get_last_two_fy_labels_wlmds()[2]
  second_label_monthly <- get_last_two_fy_labels_monthly()[2]
  
  df_for_series_52_plus <- df_for_series |>
    # mutate(date_timeseries = ifelse(FY != "25/26 WLMDS",Reporting_Period,Reporting_Period %m-% years(1)))
    mutate(
      date_timeseries = case_when(
        FY == second_label_wlmds ~ Reporting_Period %m-% years(1),
        FY == second_label_monthly ~ Reporting_Period %m-% years(1),
        .default = Reporting_Period
      )
    )
  
  df_for_series_52_plus$date_timeseries <- as.Date(df_for_series_52_plus$date_timeseries)
  
   return(df_for_series_52_plus)
  ###### create a total row for the data frame #########
}