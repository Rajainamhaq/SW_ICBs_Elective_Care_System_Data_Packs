#####################################################################
#### function to create data frames for each Organization ###########
### remote and virtual consultation ######
####################################################################

#create_main_df 
fun_dc_and_op_ORG_table <- function(org_code) {
 
  ###############################################################################
  ##### Prepare Data for table ############################################
  ##############################################################################
 ## filter data sets to to specific trust
  targetv <- 85
  
  data_mhst_tab <- data_mhst |>
   # filter(Reporting_Period == max(Reporting_Period)) |>
    filter(Organisation_Code == org_code) |>
   # filter(Organisation_Code == "RH8") |>
    filter(Measure == "DC and OP rates - specialty level" &
             Metric_Type == "Calculated %") |>
    filter(latest_period == 1) |>
    mutate(Metric_Value = as.numeric(Metric_Value)) |>
    group_by(Specialty_Modality, Metric_Value) |>
    summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
    mutate(ppt_from_target = Metric_Value - targetv) |>
    arrange(ppt_from_target) 
    
  data_mhst_overall <- data_mhst |>
    #filter(Organisation_Code == "RH8") |>
    filter(Organisation_Code == org_code) |>
    filter(Measure == "DC and OP rates" &
             Metric_Type == "Calculated %") |>
    filter(latest_period == 1) |>
     mutate(Metric_Value = as.numeric(Metric_Value)) |>
    #group_by( Metric_Value) |>
    summarise(Metric_Value = sum(Metric_Value),.groups = "drop") |>
    mutate(ppt_from_target = Metric_Value - targetv) |>
    mutate(Specialty_Modality="Overall rate") |>
    select(Specialty_Modality, Metric_Value, ppt_from_target)
  
  ## bind the two tables above
  data_mhst_tab_dc_op <- bind_rows(data_mhst_tab, data_mhst_overall)
  data_mhst_tab_dc_op <- data_mhst_tab_dc_op |>
    rename(Specialty = Specialty_Modality,
           Rate = Metric_Value)
  
   return(data_mhst_tab_dc_op)
  ###### create a total row for the data frame #########
}