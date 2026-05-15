
#create_main_df 
fun_theatre_avgcases_ORG_timeseries <- function(org_code) {
 
  df_for_thtr_avgcases_series <- data_mhst |>
   # filter(Reporting_Period >= "2024-04-01") |>
   filter(Organisation_Code == org_code) |>
  #  filter(Organisation_Code == "RH8") |>
    filter(Measure == "Average cases") |>
    #filter(str_detect(TFC_or_Diagmodality, "booked cases cancelled")) |>
    select(Reporting_Period,TFC_or_Diagmodality, FY,Month,Metric_Value) |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |> 
   
    mutate(date_timeseries = ifelse( FY == get_current_fy_digits(), Reporting_Period %m-% years(1), Reporting_Period )) |>
    mutate(date_timeseries = floor_date(as.Date(date_timeseries),"month")) |>
    mutate(Metric_Value = as.numeric(Metric_Value)) |>
    select(Reporting_Period,date_timeseries, FY,Metric_Value) |>
    mutate(FY = paste0(FY," monthly")) 
      
   return(df_for_thtr_avgcases_series)
  ###### create a total row for the data frame #########
}