##############################################################
#### function to create data frames for each Organization ####
### 12+ week validation ######
##############################################################

#create_main_df 
fun_12plus_week_validation_ORG <- function(OrgCode) {
  
  Target_v <- 90
  
    # take Denominator metric value     
   RTT_denom <- data_RTTt |>
     filter( Organisation_Code == OrgCode
             & Measure == "12+ week validation" 
             & Metric_Type == "Denominator" ) |>
             #& !is.na(Specialty_Modality)) |>
     group_by(Specialty_Modality) |>
     summarise(In_scope = sum(Metric_Value,na.rm = TRUE)) 
   
   RTT_denom <- RTT_denom[!is.na(RTT_denom$Specialty_Modality),]
      
   # pull(Total_WL)
   # take Numerator metric value
   RTT_numer <- data_RTTt |>
     filter( Organisation_Code == OrgCode
             & Measure == "12+ week validation" 
             & Metric_Type == "Numerator") |>
            # & !is.na(Specialty_Modality1)) |>
     group_by(Specialty_Modality) |>
     summarise(Validated = sum(Metric_Value,na.rm = TRUE)) 
   
   RTT_numer <- RTT_numer[!is.na(RTT_numer$Specialty_Modality),]
   
   # combine above two data frames
   RTT_table <- left_join(RTT_denom, RTT_numer, by = "Specialty_Modality")
   RTT_table[is.na(RTT_table)] <- 0
   
   #calculate Validation % <- left_join(RTT_denom, RTT_numer, by = "Specialty_Modality")ance %
   RTT_tablet <- RTT_table |>
     mutate(Validation_perc = (Validated/In_scope)*100)  |>
     mutate(Target =  Validation_perc - Target_v) |>
     arrange(Validation_perc) |>
     rename("Specialty" = Specialty_Modality)
   
   # for last row of Total Pathways, e.g. create data frame to bind with the RTT_table
   sum_validated <- c(sum(RTT_tablet$Validated, na.rm = TRUE))
   sum_in_scope <- c(sum(RTT_tablet$In_scope, na.rm = TRUE))
   Specialty_tp <- c("Total pathways")
   RTT_table_total_pathways <- data.frame(Specialty=Specialty_tp,
                                          In_scope=sum_in_scope,
                                          Validated=sum_validated)
   RTT_table_total_pathways <- RTT_table_total_pathways |>
     mutate(Validation_perc = (Validated/In_scope)*100) |>
     mutate(Target =  Validation_perc - Target_v) 
     #  arrange((Baseline)) |>
   
   # df for top 10 specialties  
   RTT_tablet_top10 <- RTT_tablet |>
     slice_head(n=10)
   # df for all other specialties after taking off top 10 rows
   RTT_table_allother <- RTT_tablet[-(1:10),]
   
   sum_validated_all_other <- c(sum(RTT_table_allother$Validated, na.rm = TRUE))
   sum_in_scope_all_other <- c(sum(RTT_table_allother$In_scope, na.rm = TRUE))
   Specialty_all_other <- c("All other specialties")
   RTT_table_allother <- data.frame(Specialty=Specialty_all_other,
                                          In_scope=sum_in_scope_all_other,
                                          Validated=sum_validated_all_other)
   RTT_table_allother <- RTT_table_allother |>
     mutate(Validation_perc = (sum_validated_all_other/sum_in_scope_all_other*100)) |>
     mutate(Target =  Validation_perc - Target_v) 
   
  # bind all 3 df's for final data table required! 
   df_12plus_week_val <- rbind(RTT_tablet_top10, RTT_table_allother, RTT_table_total_pathways )
   df_12plus_week_val  <- df_12plus_week_val  |>
     select(1,3,2,4,5)
   
   
   ######## End of RTT Performance Table creation ###############################
   
  return(df_12plus_week_val)
}