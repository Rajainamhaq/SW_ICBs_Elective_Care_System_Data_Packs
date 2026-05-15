#####################################################################
#### function to create data frames for each Organization ###########
###  RTT % Performance slide 2######
####################################################################

#create_main_df 
fun_RTT_Perf_REGION <- function() {
 
  ####################################################
  ###### Create RTT Performance Table #####
  ###################################################
  
  Baselinev <- 0.61631
  Targetv <- 0.66777
  
  # take Denominator metric value     
  RTT_denom <- data_RTTt |>
    filter(  Measure == "RTT Performance" 
            & Metric_Type == "Denominator" 
            & !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality) |>
    summarise(Total_WL = sum(Metric_Value,na.rm = TRUE)) 
  # pull(Total_WL)
  # take Numerator metric value
  RTT_numer <- data_RTTt |>
    filter( Measure == "RTT Performance" 
            & Metric_Type == "Numerator"
            & !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality) |>
    summarise(RTT_18weeks = sum(Metric_Value,na.rm = TRUE)) 
  #pull(RTT_18weeks)
  
  # combine above two data frames
  RTT_table <- left_join(RTT_denom, RTT_numer, by = "Specialty_Modality")
  #calculate RTT performance %
  RTT_tablet <- RTT_table |>
    mutate(RTT_percentage = RTT_18weeks/Total_WL) |>
    mutate(Baseline_value = Baselinev,
           Target_value = Targetv) |>
    mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
    mutate(Target = (RTT_percentage - Target_value)*100) |>
    mutate(RTT_percentage = RTT_percentage*100) |>
    arrange((Baseline)) |>
    select(-5,-6) |>
    rename("Specialty" = Specialty_Modality,
           "0-18 weeks" = RTT_18weeks,
           "Total waiting list" = Total_WL)
  
  # for last row of Total Pathways, e.g. create data frame to bind with the RTT_table
  sum_rtt18weeks <- c(sum(RTT_table$RTT_18weeks, na.rm = TRUE))
  sum_totalwl <- c(sum(RTT_table$Total_WL, na.rm = TRUE))
  Specialty_tp <- c("Total pathways")
  RTT_table_total_pathways <- data.frame(Specialty_Modality=Specialty_tp,RTT_18weeks=sum_rtt18weeks,Total_WL=sum_totalwl)
  RTT_table_total_pathways <- RTT_table_total_pathways |>
    mutate(RTT_percentage = RTT_18weeks/Total_WL) |>
    mutate(Baseline_value = Baselinev,
           Target_value = Targetv) |>
    mutate(Baseline = (RTT_percentage - Baseline_value)*100) |>
    mutate(Target = (RTT_percentage - Target_value)*100) |>
    mutate(RTT_percentage = RTT_percentage*100) |>
    #  arrange((Baseline)) |>
    select(-5,-6) |>
    rename("Specialty" = Specialty_Modality,
           "0-18 weeks" = RTT_18weeks,
           "Total waiting list" = Total_WL)
           
  #bind the total pathwys df to main df
  RTT_tablet <- rbind(RTT_tablet,RTT_table_total_pathways)
  RTT_tablet <- RTT_tablet |>
    select(1,3,2,4,5,6)
  
  
  ######## End of RTT Performance Table creation ###############################
  
  return(RTT_tablet)
  ###### create a total row for the data frame #########
}