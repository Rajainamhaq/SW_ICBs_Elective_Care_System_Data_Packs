#####################################################################
#### function to create data frames for each Organization ###########
### remote and virtual consultation ######
####################################################################

#create_main_df 
fun_op_remote_virtual_REGION_timeseries <- function() {
 
  ###############################################################################
  ##### Prepare Data for line chart ############################################
  ##############################################################################
 ## filter data sets to to specific trust

  # create table for remote consultations
  data_sus_opa_remote <- data_SUS_OPAt |>
    filter(Der_Contact_Type == "F2F") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    mutate(FY = paste(FY,"remote")) |>
    mutate(data_type = "remote") |>
    select(Reporting_Period,Month,Month_Yr,FY,data_type, Metric_Value)
  
  # create table for virtual consultations.
  data_sus_opa_virtual <- data_SUS_OPAt |>
    filter(Der_Contact_Type == "NF2F") |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
    group_by(FY, Month,Month_Yr) |>
    summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
    mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
    mutate(FY = paste(FY,"virtual")) |>
    mutate(data_type = "virtual") |>
    select(Reporting_Period,Month,Month_Yr,FY,data_type, Metric_Value)
  

   ######################################################
  ### combine the data tables and plot time series #####
  ######################################################
  df_for_series <- rbind(data_sus_opa_remote, data_sus_opa_virtual) 
  
    ## create the new date series column name date_timeseries to sync 24/25 and 25/26 on same months. 
  df_for_series <- df_for_series |>
    # mutate(date_timeseries = ifelse(FY != "25/26 WLMDS",Reporting_Period,Reporting_Period %m-% years(1)))
    mutate(
      date_timeseries = case_when(
        Reporting_Period >= min(Reporting_Period) %m+% years(1) ~ Reporting_Period %m-% years(1),
        #FY == "25/26 remote" ~ Reporting_Period %m-% years(1),
        #FY == "25/26 virtual" ~ Reporting_Period %m-% years(1),
        .default = Reporting_Period
      )
    ) |>
    filter(Reporting_Period != max(Reporting_Period))
  
  df_for_series$date_timeseries <- as.Date(df_for_series$date_timeseries)
  
   return(df_for_series)
  ###### create a total row for the data frame #########
}