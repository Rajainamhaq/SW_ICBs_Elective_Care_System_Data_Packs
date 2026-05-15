

fun_ebi_procedure_ORG <- function(org_code) {
  
  ## get the EBI Procedures Date
  date_ebi_ext <- data_mhst |>
    filter(Measure == "EBI Procedures")
  date_ebi <- max(date_ebi_ext$Reporting_Period,na.rm =TRUE)
  
  
  data_proc_tab <- data_mhst |>
   filter(Organisation_Code == org_code) |>
   #filter(Organisation_Code == "RVJ") |>
    filter(str_detect(Specialty_Modality,"12 month rolling activity")) |>
    filter(Reporting_Period == date_ebi) |>
    select(Specialty_Modality,Metric_Value) |>
    arrange(desc(Metric_Value)) |>
    rename(Procedure = Specialty_Modality,
           Organisational_value = Metric_Value) 
   data_proc_tab <- head(data_proc_tab,-2)
    
  ## get and join the National median for ebi procedures
   data_proc_tab <- left_join(data_proc_tab,ebi_national, by = c("Procedure"="ebi_Procedure"))
  
  return(data_proc_tab)
    
    
  
  
}