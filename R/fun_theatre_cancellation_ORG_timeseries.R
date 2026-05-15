
#create_main_df 
fun_theatre_cancellation_ORG_timeseries <- function(org_code) {
 
  df_for_thtr_canc_series <- data_mhst |>
   # filter(Reporting_Period >= "2024-04-01") |>
   filter(Organisation_Code == org_code) |>
   # filter(Organisation_Code == "RH8") |>
    #filter(str_detect(TFC_or_Diagmodality, "booked cases cancelled")) |>
    select(Reporting_Period,TFC_or_Diagmodality, FY,Month,Metric_Value) |>
    mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |> 
    mutate(TFC_or_Diagmodality_new = case_when(
      TFC_or_Diagmodality == "% of booked cases cancelled 0-3 days before surgery (monthly)" ~ "cancelled 0-3 days",
      TFC_or_Diagmodality == "% of booked cases cancelled where the cancellation date is after the scheduled date of surgery (monthly)" ~ "cancelled after date",
      TFC_or_Diagmodality == "% of booked cases cancelled within qualifying sessions (monthly)" ~ "cancelled within session",
      TFC_or_Diagmodality == "% of booked cases cancelled 4 or more days before surgery (monthly)" ~ "cancelled 4+ days",
      TFC_or_Diagmodality == "% of booked cases cancelled without a cancellation date (monthly)" ~ "cancelled with no date",
      TRUE ~ "other"
    )) |>
   mutate(FY1 = paste(FY,TFC_or_Diagmodality_new,sep = " ")) |>
    mutate(date_timeseries = ifelse( FY == get_current_fy_digits(), Reporting_Period %m-% years(1), Reporting_Period )) |>
    mutate(date_timeseries = floor_date(as.Date(date_timeseries),"month")) |>
    mutate(Metric_Value = as.numeric(Metric_Value)) |>
    select(Reporting_Period,date_timeseries, FY1,Metric_Value) |>
    # new filter added as metric redcuced to only one metric for 24/25 and 25/26 which is 0-3 days cancelled 0-3 days.
    filter(str_detect(FY1,"0-3 days"))
      
   return(df_for_thtr_canc_series)
  ###### create a total row for the data frame #########
}