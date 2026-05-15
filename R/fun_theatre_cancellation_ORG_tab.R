
#create_main_df 
fun_theatre_cancellation_ORG_tab <- function(org_code) {
  
  # get max date
  thtr_canc_max_date_ext <- data_mhst |>
    # filter(Reporting_Period >= "2024-04-01") |>
     filter(Organisation_Code == org_code) |>
    #filter(Organisation_Code == "RH8") |>
    filter(str_detect(TFC_or_Diagmodality, "booked cases cancelled"))
  date_max_thtr_canc <- max(thtr_canc_max_date_ext$Reporting_Period)
  
  
 
  df_for_thtr_canc_table <- data_mhst |>
   # filter(Reporting_Period >= "2024-04-01") |>
   filter(Organisation_Code == org_code) |>
  #  filter(Organisation_Code == "RH8") |>
    filter(str_detect(TFC_or_Diagmodality, "booked cases cancelled")) |>
    filter(Reporting_Period == date_max_thtr_canc) |>
    select(Reporting_Period, TFC_or_Diagmodality,Metric_Value) |>
    mutate(Metric_Value = as.numeric(Metric_Value)/100) |>
    rename(Metrics = TFC_or_Diagmodality,
           'cases %' = Metric_Value)
    
    
 return(df_for_thtr_canc_table)
  ###### create a total row for the data frame #########
}