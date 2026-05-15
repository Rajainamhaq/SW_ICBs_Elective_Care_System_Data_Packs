##############################################################
#### function to create data frames for each Organization ####
##############################################################

#create_main_df 
fun_6plus_week_perc_REGION <- function() {
   
   Targetv <- 0.05
   
   data_RTTa <- data_RTT ##|>
     ##filter(ICB == icb_name)
   
       # take Denominator metric value     
   RTT_denom <- data_RTTa |>
     filter(  Measure == "6+ week %" 
             & Metric_Type ==  "Numerator"
             & !is.na(Specialty_Modality)) |>
     group_by(Specialty_Modality) |>
     summarise(six_plus_weeks = sum(Metric_Value,na.rm = TRUE)) 
    #pull(Total_WL)
   # take Numerator metric value
   RTT_numer <- data_RTTa |>
     filter(  Measure == "6+ week %"  
             & Metric_Type == "Denominator"
             & !is.na(Specialty_Modality)) |>
     group_by(Specialty_Modality) |>
     summarise(Total_WL = sum(Metric_Value,na.rm = TRUE)) 
   #pull(RTT_18weeks)
   
   # combine above two data frames
   RTT_table <- left_join(RTT_denom,RTT_numer, by = "Specialty_Modality")
   #calculate RTT performance %
   RTT_tablet <- RTT_table |>
     mutate(DM01_perc = six_plus_weeks/Total_WL) |>
     mutate(Target_value = Targetv) |>
     #  mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
     mutate(Target = (DM01_perc - Target_value)*100) |>
     mutate(DM01_perc = DM01_perc*100) |>
     arrange(desc(Target)) |>
     select(-Target_value) 
   
 ## workout for totals row
   sum_sixplus_weeks <- c(sum(RTT_tablet$six_plus_weeks, na.rm = TRUE))
   sum_totalwl <- c(sum(RTT_tablet$Total_WL,  na.rm = TRUE))
   Specialty_tp <- c("Total tests")
   
   RTT_table_total_pathways <- data.frame(Specialty_Modality=Specialty_tp,six_plus_weeks=sum_sixplus_weeks,Total_WL=sum_totalwl)
   
   RTT_table_total_pathways <- RTT_table_total_pathways |>
     mutate(DM01_perc = six_plus_weeks/Total_WL) |>
     mutate(Target_value = Targetv) |>
     #  mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
     mutate(Target = (DM01_perc - Target_value)*100) |>
     mutate(DM01_perc = DM01_perc*100) |>
     arrange(desc(Target)) |>
     select(-Target_value) 
   
  ## combine the totals with the original data frame and rename columns
   RTT_tablet <- rbind(RTT_tablet,RTT_table_total_pathways)
   RTT_tablet <- RTT_tablet |>
     rename(Numerator = six_plus_weeks,
            Denominator = Total_WL,
            'DM01 %' = DM01_perc,
            Modality = Specialty_Modality)
     
   
   ######## End of RTT Performance Table creation ###############################
   
  return(RTT_tablet)
}