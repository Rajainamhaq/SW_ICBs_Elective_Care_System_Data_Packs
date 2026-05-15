#####################################################################
#### function to create data frames for each Organization ###########
### remote and virtual consultation ######
####################################################################

#create_main_df 
fun_dc_and_op_ORG_timeseries <- function(org_code) {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
 ## filter data sets to to specific trust
  data_mhst <- data_mhst |>
    filter(Reporting_Period >= get_last_two_fy_start()) |>
   filter(Organisation_Code == org_code)
    #filter(Organisation_Code == "RH8")
  
  targetv <- 0.85
  # create table for remote consultations
  data_dc_and_op <- data_mhst |>
    filter(Measure == "DC and OP rates" &
             Metric_Type == "Calculated %") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    mutate(Metric_Value = as.numeric(Metric_Value)) |>
    summarise(Metric_Value = 0.01*sum(Metric_Value),.groups = "drop") |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    mutate(FY = paste(FY,"monthly")) |>
    mutate(data_type = "monthly") |>
    select(Reporting_Period,Month,Month_Yr,FY,data_type, Metric_Value)
  
  
    ## create the new date series column name date_timeseries to sync 24/25 and 25/26 on same months. 
  df_for_series <- data_dc_and_op |>
    # mutate(date_timeseries = ifelse(FY != "25/26 WLMDS",Reporting_Period,Reporting_Period %m-% years(1)))
    mutate(
      date_timeseries = case_when(
        Reporting_Period >= min(Reporting_Period) %m+% years(1) ~ Reporting_Period %m-% years(1),
        #FY == "25/26 remote" ~ Reporting_Period %m-% years(1),
        #FY == "25/26 virtual" ~ Reporting_Period %m-% years(1),
        .default = Reporting_Period
      )
    ) 
  df_for_series$date_timeseries <- as.Date(df_for_series$date_timeseries)
  
  target_df <- df_for_series |>
    mutate(Metric_Value = targetv) |>
    mutate(data_type = "Target") |>
    mutate(FY = "Target 85%") |>
    select(Reporting_Period, Month,Month_Yr,FY,data_type,Metric_Value,date_timeseries)
  
  df_for_series <- rbind(df_for_series,target_df)
  
   return(df_for_series)
  ###### create a total row for the data frame #########
}