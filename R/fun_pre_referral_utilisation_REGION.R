##############################################################
#### function to create data frames for each ICB ####
###  pre_referral_utilisation ######
##############################################################

#create_main_df 
fun_pre_referral_utilisation_REGION <- function() {
  
  Target_v <- 12.6
  
  # take Denominator metric value     
  RTT_denom <- data_RTT_datamarta |>
    filter(  Measure == "Spec Advice utilisation - pre referral" 
            & Metric_Type == "Denominator" ) |>
    #& !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality1) |>
    summarise(Total_WL = sum(Metric_Value,na.rm = TRUE)) 
  
  RTT_denom <- RTT_denom[!is.na(RTT_denom$Specialty_Modality1),]
  
  # pull(Total_WL)
  # take Numerator metric value
  RTT_numer <- data_RTT_datamarta |>
    filter( Measure == "Spec Advice utilisation - pre referral" 
            & Metric_Type == "Numerator") |>
    # & !is.na(Specialty_Modality1)) |>
    group_by(Specialty_Modality1) |>
    summarise(RTT_18weeks = sum(Metric_Value,na.rm = TRUE)) 
  
  RTT_numer <- RTT_numer[!is.na(RTT_numer$Specialty_Modality1),]
  
  # combine above two data frames
  RTT_table <- left_join(RTT_denom, RTT_numer, by = "Specialty_Modality1")
  RTT_table[is.na(RTT_table)] <- 0
  
  #calculate RTT performRTT_table <- left_join(RTT_denom, RTT_numer, by = "Specialty_Modality")ance %
  RTT_tablet <- RTT_table |>
    mutate(Utilisation = (RTT_18weeks/Total_WL)*100)  |>
    mutate(Target = Utilisation - Target_v) |>
    arrange(Target) |>
    rename("Specialty" = Specialty_Modality1,
           "Numerator" = RTT_18weeks,
           "Denominator" = Total_WL)
  
  # for last row of Total Pathways, e.g. create data frame to bind with the RTT_table
  sum_rtt18weeks <- c(sum(RTT_tablet$Numerator, na.rm = TRUE))
  sum_totalwl <- c(sum(RTT_tablet$Denominator, na.rm = TRUE))
  Specialty_tp <- c("Total pathways")
  RTT_table_total_pathways <- data.frame(Specialty=Specialty_tp,Denominator=sum_totalwl,Numerator=sum_rtt18weeks)
  RTT_table_total_pathways <- RTT_table_total_pathways |>
    mutate(Utilisation = (Numerator/Denominator)*100) |>
    mutate(Target = Utilisation - Target_v) 
  #  arrange((Baseline)) |>
  
  # df for top 10 specialties  
  RTT_tablet_top10 <- RTT_tablet |>
    slice_head(n=10)
  # df for all other specialties after taking off top 10 rows
  RTT_table_allother <- RTT_tablet[-(1:10),]
  
  Denominator <- c(sum(RTT_table_allother$Denominator, na.rm = TRUE))
  Numerator <- c(sum(RTT_table_allother$Numerator, na.rm = TRUE))
  Specialty <- c("All other specialties")
  
  RTT_table_allother_total <- data.frame(Specialty, Denominator, Numerator)
  
  # create other cols for all other total for specialties
  RTT_table_allother_total <- RTT_table_allother_total |>
    mutate(Utilisation = (Numerator/Denominator)*100) |>
    mutate(Target = Utilisation - Target_v)
  
  # bind all 3 df's for final data table required! 
  Spec_adv_utilisation <- rbind(RTT_tablet_top10, RTT_table_allother_total, RTT_table_total_pathways )
  Spec_adv_utilisation <- Spec_adv_utilisation |>
    select(1,3,2,4,5)
  
  
  ######## End of RTT Performance Table creation ###############################
  
  return(Spec_adv_utilisation )
}