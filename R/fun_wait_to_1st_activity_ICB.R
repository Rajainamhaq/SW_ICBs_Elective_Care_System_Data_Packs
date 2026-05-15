##############################################################
#### function to create data frames for each Organization ####
###  Wait to 1st Activity ######
##############################################################

#create_main_df 
fun_wait_to_1st_activity_ICB <- function(icb_name) {
  ## create Target and Baseline table to use in RTT Performance Table below ##
  target_basline_lup <- data_RTT_datamart |>
    filter(Data_Source == "Targets and baselines" & Measure_Type == "Wait to first") |>
    select(Reporting_Period,Organisation_Code,Measure,Metric_Value,ICB)
  
  #get the basline and target values to use below
  baseline_value <- target_basline_lup |>
    filter(ICB == icb_name & Measure == "Nov-25 baseline") |>
    select(Metric_Value)
  baselinev <- mean(baseline_value$Metric_Value)
  
  target_value <- target_basline_lup |>
    filter(ICB == icb_name & Measure == "Mar-27 target") |>
    select(Metric_Value)
  targetv <- mean(target_value$Metric_Value)
  #############################################################################
  
  
  ####################################################
  ###### Create wait to first activity Table #####
  ###################################################
  
  # take Denominator metric value     
  RTT_denom <- data_RTTt |>
    filter( ICB == icb_name
            & Measure == "Wait to first" 
            & Metric_Type == "Denominator" 
            & !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality) |>
    summarise(Total_WL = sum(Metric_Value,na.rm = TRUE)) 
  # pull(Total_WL)
  # take Numerator metric value
  RTT_numer <- data_RTTt |>
    filter(ICB == icb_name 
           & Measure == "Wait to first" 
           & Metric_Type == "Numerator"
           & !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality) |>
    summarise(RTT_18weeks = sum(Metric_Value,na.rm = TRUE)) 
  #pull(RTT_18weeks)
  
  # combine above two data frames
  RTT_table <- left_join(RTT_numer,RTT_denom, by = "Specialty_Modality")
  #calculate RTT performance %
  RTT_tablet <- RTT_table |>
    mutate(wait_to_first_percentage = RTT_18weeks/Total_WL) |>
    mutate(Baseline_value = baselinev,
           Target_value = targetv) |>
    mutate(Baseline = (wait_to_first_percentage - Baseline_value)*100) |>
    mutate(Target = (wait_to_first_percentage - Target_value)*100) |>
    mutate(wait_to_first_percentage = wait_to_first_percentage*100) |>
    arrange((Baseline)) |>
    select(-5,-6) |>
    rename("Specialty" = Specialty_Modality,
           "0-18 weeks" = RTT_18weeks,
           "First Activity" = Total_WL)
  
  # for last row of Total Pathways, e.g. create data frame to bind with the RTT_table
  sum_rtt18weeks <- c(sum(RTT_table$RTT_18weeks))
  sum_totalwl <- c(sum(RTT_table$Total_WL))
  Specialty_tp <- c("Total pathways")
  RTT_table_total_pathways <- data.frame(Specialty_Modality=Specialty_tp,RTT_18weeks=sum_rtt18weeks,Total_WL=sum_totalwl)
  RTT_table_total_pathways <- RTT_table_total_pathways |>
    mutate(wait_to_first_percentage = RTT_18weeks/Total_WL) |>
    mutate(Baseline_value = baselinev,
           Target_value = targetv) |>
    mutate(Baseline = (wait_to_first_percentage - Baseline_value)*100) |>
    mutate(Target = (wait_to_first_percentage - Target_value)*100) |>
    mutate(wait_to_first_percentage = wait_to_first_percentage*100) |>
    #  arrange((Baseline)) |>
    select(-5,-6) |>
    rename("Specialty" = Specialty_Modality,
           "0-18 weeks" = RTT_18weeks,
           "First Activity" = Total_WL)
  
  #bind the total pathwys df to main df
  RTT_tablet <- rbind(RTT_tablet,RTT_table_total_pathways)
  
  ######## End of RTT Performance Table creation ###############################
   
  return(RTT_tablet)
}