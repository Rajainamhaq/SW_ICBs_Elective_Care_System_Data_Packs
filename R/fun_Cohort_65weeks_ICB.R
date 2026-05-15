#####################################################################
#### function to create data frames for each Organization ###########
###   65 weeks cohort pathways waiting for treatment by June 25######
####################################################################

#create_main_df 
fun_Cohort_65weeks_ICB <- function(icb_name) {
  df_filtered_65ww <- wlmds_pathways |>
    filter(ICB == icb_name)
  # filter(Organisation_Code == "RA9")
  ############# create main data frame cols ##################
  ## 2nd col of table
  Total_65plus_cohort <- df_filtered_65ww |>
    group_by(Specialty) |>
    summarise(total_65_cohort = sum(Cohort_65,na.rm = TRUE),
              .groups = "drop") |>
    mutate(total_65_cohort = if_else(is.na(total_65_cohort), 0, total_65_cohort)) |>
    arrange(desc(total_65_cohort)) 
  ## 3rd col of table
  Total_65plus_nonadmitted <- df_filtered_65ww |>
    filter(Waiting_List_Type == "Non-admitted") |>
    summarise(non_admitted = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(non_admitted = if_else(is.na(non_admitted),0,non_admitted)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_65plus_nonadmitted,by="Specialty")
  ## 4th col of table 
  Total_65plus_1stOP <- df_filtered_65ww |>
    filter(Waiting_List_Type == "Non-admitted" & POD == "1st OP") |>
    summarise(First_OP = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(First_OP = if_else(is.na(First_OP),0,First_OP)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_65plus_1stOP,by="Specialty") 
  ## 5th col of table
  Total_dateinApr25 <- df_filtered_65ww |>
    filter(POD == "1st OP" & App_before_deadline == "Dated in Apr-25") |>
    summarise(Date_in_Apr25 = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(Date_in_Apr25 = if_else(is.na(Date_in_Apr25),0,Date_in_Apr25)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_dateinApr25,by="Specialty") 
  ## 6th col of table
  Total_dateinMay25 <- df_filtered_65ww |>
    filter(POD == "1st OP" & App_before_deadline == "Dated in May-25") |>
    summarise(Date_in_May25 = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(Date_in_May25 = if_else(is.na(Date_in_May25),0,Date_in_May25)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_dateinMay25,by="Specialty")
  ## 7th col of table
  Total_dateinJun25 <- df_filtered_65ww |>
    filter(POD == "1st OP" & App_before_deadline == "Dated in Jun-25") |>
    summarise(Date_in_Jun25 = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(Date_in_Jun25 = if_else(is.na(Date_in_Jun25),0,Date_in_Jun25)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_dateinJun25,by="Specialty")
  ## 8th col of table
  Total_dateafterJun25 <- df_filtered_65ww |>
    filter(POD == "1st OP" & App_before_deadline == "Dated after Jun-25") |>
    summarise(Date_after_Jun25 = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(Date_after_Jun25 = if_else(is.na(Date_after_Jun25),0,Date_after_Jun25)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_dateafterJun25,by="Specialty")
  ## 9th col of table
  Total_No_date <- df_filtered_65ww |>
    filter(POD == "1st OP" & App_before_deadline == "No date") |>
    summarise(No_Date = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(No_Date = if_else(is.na(No_Date),0,No_Date)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_No_date,by="Specialty")
  ## 9th col of table
  Total_65ww_FUOP <- df_filtered_65ww |>
    filter(POD == "FU OP") |>
    summarise(FU_OP = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(FU_OP = if_else(is.na(FU_OP),0,FU_OP)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_65ww_FUOP,by="Specialty")
  
  Total_65plus_cohort <- Total_65plus_cohort |>
    mutate(Other_OP = non_admitted - First_OP - FU_OP) 
  
  ## 14th col of table  
  Total_65ww_admitted <- df_filtered_65ww |>
    filter(Waiting_List_Type == "Admitted") |>
    summarise(Admitted = sum(Cohort_65,na.rm = TRUE),
              .by = Specialty) |>
    mutate(Admitted = if_else(is.na(Admitted),0,Admitted)) 
  Total_65plus_cohort <- left_join(Total_65plus_cohort,Total_65ww_admitted,by="Specialty")
  
  Total_65plus_cohort[is.na(Total_65plus_cohort)] <- 0
  
  
  ## create last row with 'Total pathways' in the data frame by having sum of all cols apart from % ##cols.
  sum_cols_all <- Total_65plus_cohort |>
    summarise(
      total_65_cohort = sum(total_65_cohort),
      non_admitted = sum(non_admitted),
      First_OP = sum(First_OP),
      Date_in_Apr25 = sum(Date_in_Apr25),
      Date_in_May25 = sum(Date_in_May25),
      Date_in_Jun25 = sum(Date_in_Jun25),
      Date_after_Jun25 = sum(Date_after_Jun25),
      No_Date = sum(No_Date),
      FU_OP = sum(FU_OP),
      Other_OP = sum(Other_OP),
      Admitted = sum(Admitted),
    ) |>
    mutate(Specialty = "Total pathways") |>
    select(12,1:11)
  
  Total_65plus_cohort <- rbind(Total_65plus_cohort,sum_cols_all)
  
  ## create %age cols for table
  Total_65plus_cohort <- Total_65plus_cohort |>
    mutate(
      First_OP_EoMar_Perc = if_else(First_OP != 0, 
                                    round((Date_in_Apr25+Date_in_May25+Date_in_Jun25)/First_OP*100,2), NA)) |>
    mutate(       
      cohort_sched_Perc = if_else(non_admitted != 0,
                                  round((Date_in_Apr25+Date_in_May25+Date_in_Jun25+FU_OP+Admitted)            
                                        /non_admitted*100,2),NA)) |>
    select(1:11,13,14,12)
  
  # rename cols names as per slide
  Total_65plus_cohort <- Total_65plus_cohort |>
    rename('Total 65+ cohort' = total_65_cohort,
           'Non- admitted' = non_admitted,
           '1st OP' = First_OP,
           'Dated in Apr-25' = Date_in_Apr25,
           'Dated in May-25' = Date_in_May25,
           'Dated in June-25' = Date_in_Jun25,
           'Dated after Jun-25' = Date_after_Jun25,
           'No Date' = No_Date,
           'FU OP' = FU_OP,
           'Other OP' = Other_OP
    )
  
  
  return(Total_65plus_cohort)
  ###### create a total row for the data frame #########
}