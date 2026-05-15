#####################################################################
#### function to create data frames for each Organization ###########
###  Clock Starts ######
####################################################################

#create_main_df 
fun_rtt_waiting_list_ORG_timeseries <- function(org_code) {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
 ## filter data sets to to specific trust
     data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Reporting_Period >=  get_last_two_fy_start()) |>
    filter(Organisation_Code == org_code)
    #filter(Organisation_Code == "RH8")

     data_RTTt <- data_RTTt |>
    filter(Organisation_Code == org_code)
    #filter(Organisation_Code == "RH8")
  
  ## 1st monthly RTT, for 24/25, 25/26 Monthly Clock Starts from data mart table
  data_rtt_monthly <- data_RTT_datamarta |>
    # filter(ICB == "Devon") |>
    filter(
      Measure == "RTT waiting list",
      FY %in% get_last_two_fy_labels_monthly()
    ) |>
    filter(Data_Source == "RTT monthly") |> # new filter added
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
  
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    mutate(data_type = "RTT Monthly") |>

    select(Reporting_Period,Month,Month_Yr,FY,data_type, Metric_Value)
  
  ###############################################################################
  
  ## 2nd table WLMDS, for 24/25, 25/26 with numerator and denominator  
  # create table for Numerator
  data_rtt_wlmds <- data_RTTt |>
    #filter(`Org Short Name` == "R Devon Uni") |>
    # filter(ICB == "Devon") |>
    filter(Measure == "RTT Waiting List"  & (FY %in% get_last_two_fy_labels_wlmds())
           & Data_Source == "WLMDS RTT") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month, Month_Yr) |>
    summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
    mutate(Month_Yr =  ifelse(Month %in% c('Jan','Feb','Mar'),
                              paste0(Month,'-',str_sub(FY,4,5)),
                              paste0(Month,'-',str_sub(FY,1,2)))) |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    mutate(data_type = "WLMDS") |>
    select(Reporting_Period,Month,Month_Yr,FY,data_type, Metric_Value)
  
  #######################################
  
  ## prepare 3rd table for rtt performance Plans
  data_rtt_perf_plan <- data_RTT_datamarta |>
    #filter(`Org Short Name` == "R Devon Uni") |>
    #  filter(ICB == "Devon") |>
    filter(Measure == "RTT waiting list") |>
    filter(Data_Source == "Plans") |>
    filter(Reporting_Period >= get_fy_start()) |>  ### get the current financial year start date.
    group_by(FY,Reporting_Period,Month) |>
    summarise(Metric_Value = sum(Metric_Value)) |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    mutate(data_type = "Plan") |>
    select(Reporting_Period, Month, Month_Yr,FY, data_type, Metric_Value) |>
    # for sake of line graph back date the 25/26 target line to 24/25
    mutate(Reporting_Period = Reporting_Period %m-% years(1))
     data_rtt_perf_plan$Reporting_Period <- as.Date(data_rtt_perf_plan$Reporting_Period)
  
  data_rtt_perf_plan <- data_rtt_perf_plan |>
    select(Reporting_Period,Month,Month_Yr,FY,data_type, Metric_Value)
  
  ######## End of Plan Performance Table creation ###############################  
  
   ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  df_for_series <- rbind(data_rtt_monthly,data_rtt_wlmds,data_rtt_perf_plan) 
 
  ### get the 2nd lable in vector to use in below mutate to get it automated
  second_label_wlmds <- get_last_two_fy_labels_wlmds()[2]
  second_label_monthly <- get_last_two_fy_labels_monthly()[2]
  
  ## create the new date series column to sync 24/25 and 25/26 on same months. 
  df_for_series <- df_for_series |>
    # mutate(date_timeseries = ifelse(FY != "25/26 WLMDS",Reporting_Period,Reporting_Period %m-% years(1)))
    mutate(
      date_timeseries = case_when(
        FY == second_label_wlmds ~ Reporting_Period %m-% years(1),
        FY == second_label_monthly ~ Reporting_Period %m-% years(1),
        .default = Reporting_Period
      )
    )
  
  
  df_for_series$date_timeseries <- as.Date(df_for_series$date_timeseries)
  
   return(df_for_series)
  ###### create a total row for the data frame #########
}