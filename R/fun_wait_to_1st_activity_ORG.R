##############################################################
#### function to create data frames for each Organization ####
###  Wait to 1st Activity ######
##############################################################

#create_main_df 
fun_wait_to_1st_activity_ORG <- function(OrgCode) {
   ## create Target and Baseline table to use in RTT Performance Table below ##
     target_basline_lup <- data_RTT_datamart |>
     filter(Data_Source == "Targets and baselines" & Measure_Type == "Wait to first") |>
     select(Reporting_Period,Organisation_Code,Measure,Metric_Value)
   
   #get the basline and target values to use below
   baseline_value <- target_basline_lup |>
     filter(Organisation_Code == OrgCode & Measure == get_current_fy_baseline()) |>
     select(Metric_Value)
   baselinev <- as.numeric(baseline_value)
   
   target_value <- target_basline_lup |>
     filter(Organisation_Code == OrgCode & Measure == get_mar_target_label()) |>
     select(Metric_Value)
   targetv <- as.numeric(target_value)       
#############################################################################

   # take Denominator metric value     
   RTT_denom <- data_RTTt |>
     filter( Organisation_Code == OrgCode 
             & Measure == "Wait to first" 
             & Metric_Type == "Denominator" 
             & !is.na(Specialty_Modality)) |>
     group_by(Specialty_Modality) |>
     summarise(Total_Waits_first_activity = sum(Metric_Value,na.rm = TRUE)) 
   # pull(Total_WL)
   # take Numerator metric value
   RTT_numer <- data_RTTt |>
     filter( Organisation_Code == OrgCode
             & Measure == "Wait to first" 
             & Metric_Type == "Numerator"
             & !is.na(Specialty_Modality)) |>
     group_by(Specialty_Modality) |>
     summarise(wait_18weeks = sum(Metric_Value,na.rm = TRUE)) 
   #pull(RTT_18weeks)
   
   # combine above two data frames
   RTT_table <- left_join(RTT_numer,RTT_denom, by = "Specialty_Modality")
   #calculate RTT performance %
   RTT_tablet <- RTT_table |>
     mutate(wait_to_first_percentage = wait_18weeks/Total_Waits_first_activity) |>
     mutate(Baseline_value = baselinev,
            Target_value = targetv) |>
     mutate(Baseline = (wait_to_first_percentage - Baseline_value)*100) |>
     mutate(Target = (wait_to_first_percentage - Target_value)*100) |>
     mutate(wait_to_first_percentage = wait_to_first_percentage*100) |>
     arrange((Baseline)) |>
     select(-5,-6) |>
     rename("Specialty" = Specialty_Modality,
            "0-18 weeks" = wait_18weeks,
            "First Activity" = Total_Waits_first_activity)
   
   # for last row of Total Pathways, e.g. create data frame to bind with the RTT_table
   sum_wait_18weeks <- c(sum(RTT_table$wait_18weeks))
   sum_total_wait_to_lst <- c(sum(RTT_table$Total_Waits_first_activity))
   Specialty_tp <- c("Total pathways")
   RTT_table_total_wait_to_1st <- data.frame(Specialty_Modality=Specialty_tp,wait_18weeks=sum_wait_18weeks,Total_Waits_first_activity=sum_total_wait_to_lst)
   RTT_table_total_wait_to_1st <- RTT_table_total_wait_to_1st |>
     mutate(wait_to_first_percentage = wait_18weeks/Total_Waits_first_activity) |>
     mutate(Baseline_value = baselinev,
            Target_value = targetv) |>
     mutate(Baseline = (wait_to_first_percentage - Baseline_value)*100) |>
     mutate(Target = (wait_to_first_percentage - Target_value)*100) |>
     mutate(wait_to_first_percentage = wait_to_first_percentage*100) |>
     #  arrange((Baseline)) |>
     select(-5,-6) |>
     rename("Specialty" = Specialty_Modality,
            "0-18 weeks" = wait_18weeks,
            "First Activity" = Total_Waits_first_activity)
   
   #bind the total pathwys df to main df
   RTT_tablet <- rbind(RTT_tablet,RTT_table_total_wait_to_1st)
   
   ######## End of RTT Performance Table creation ###############################
   
  return(RTT_tablet)
}