##############################################################
#### function to create data frames for each Organization ####
##############################################################

#create_main_df 
fun_diag_activity_REGION <- function() {
   
    
  
    data_diag_activity <-data_RTT_datamarta 
     #filter(ICB == icb_name)
   
  DM01_get_date <- data_diag_activity |>
    filter(  Measure == "Diagnostic activity" 
             & Metric_Type ==  "Count"
             & Data_Source == "DM01") 
  
  DM01_max_date <-  max(DM01_get_date$Reporting_Period)
  date_obj <- as.POSIXct(DM01_max_date, format = "%Y-%m-%d %Z", tz = "UTC")   
  month_mmm <- format(date_obj,"%b")
  month_mmm <- as.character(month_mmm)
  
    
       # take Denominator metric value     
   RTT_DM01 <- data_diag_activity |>
     filter(  Measure == "Diagnostic activity" 
             & Metric_Type ==  "Count"
             & Data_Source == "DM01"
             & !is.na(Specialty_Modality)) |>
     group_by(Specialty_Modality) |>
     summarise(DM01 = sum(Metric_Value,na.rm = TRUE)) 
  
   
  ######### emailed Jo to clarify the logic of Plan column ###############
   
   RTT_plan <- data_diag_activity |>
     filter(Reporting_Period >= get_fy_start()) |>
     filter(Measure == "Diagnostic activity") |>
     filter(Data_Source == "Plans") |>
     filter(FY == get_current_fy_plans_label()) |>
     filter(Metric_Type ==  "Count") |>
     filter(Month == month_mmm) |>
     filter(!is.na(Specialty_Modality1)) |>
     group_by(Specialty_Modality1) |>
     summarise(Plans = sum(Metric_Value,na.rm = TRUE)) |>
     rename(Specialty_Modality=Specialty_Modality1)

   
   # combine above two data frames
   RTT_table <- left_join(RTT_DM01, RTT_plan, by = "Specialty_Modality")
   
   #calculate RTT performance %
   RTT_tablet <- RTT_table |>
     arrange(desc(DM01)) |>
     mutate(Comparison = DM01 - Plans) |>
     rename(Modality = Specialty_Modality )
   
 ## workout for totals row
   sum_DM01 <- c(sum(RTT_tablet$DM01, na.rm = TRUE))
   sum_Plans <- c(sum(RTT_tablet$Plans,  na.rm = TRUE))
   Specialty_tp <- c("Total tests")
   
   RTT_table_total_pathways <- data.frame(Modality=Specialty_tp,DM01=sum_DM01,
                                          Plans=sum_Plans)
   
   RTT_table_total_pathways <- RTT_table_total_pathways |>
     mutate(Comparison = DM01 - Plans) 
   
  ## combine the totals with the original data frame and rename columns
   RTT_tablet <- rbind(RTT_tablet,RTT_table_total_pathways)
 
   ######## End of RTT Performance Table creation ###############################
   
  return(RTT_tablet)
}