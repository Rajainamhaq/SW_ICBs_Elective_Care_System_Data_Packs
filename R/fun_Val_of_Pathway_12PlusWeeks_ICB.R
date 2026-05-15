##############################################################
#### function to create data frames for each ICB ####
###  Validation of pathways currently waiting 12+ weeks ######
##############################################################


#create_main_df 
fun_Val_of_Pathway_12PlusWeeks_ICB <- function(icb_name) {
  df_filtered <- wlmds_pathways |>
    filter(ICB == icb_name)
  #filter(Organisation_Code == "RVJ")
  
  ############# create main data frame cols ##################
  ## 6th col, all the specialties sum
  Total_12_plus_wks_not_Val_all <-df_filtered |>
    filter(Validation_flag == 'Not validated') |>
    summarise(Not_Validated = sum(Weeks_12plus,na.rm = TRUE))
  ## 6th col of table
  Total_12_plus_wks_not_Val <- df_filtered |>
    filter(Validation_flag == 'Not validated') |>
    group_by(Specialty) |>
    summarise(Not_Validated = sum(Weeks_12plus,na.rm = TRUE),
              .groups = "drop") |>
    mutate(Not_Validated = if_else(is.na(Not_Validated), 0, Not_Validated)) |>
    arrange(desc(Not_Validated)) |>
    slice_head(n=10)
  
  Total_12_plus_wks_all <- df_filtered |>
    # filter(Organisation_Code == 'R0D') |>
    ## 2nd col total sum  
    summarise(Total12Pluswks = sum(Weeks_12plus))
  ## 2nd col of table
  Total_12_plus_wks <- df_filtered |>
    summarise(Total12Pluswks = sum(Weeks_12plus),
              .by = Specialty) 
  Total_12_plus_wks_not_Val <- left_join(Total_12_plus_wks_not_Val,Total_12_plus_wks,by="Specialty")
  ## 3rd col, all the specialties sum
  Total_12_plus_wks_oos_all <- df_filtered |>
    filter(Validation_flag == 'Out of scope') |>
    summarise(out_of_scope_all = sum(Weeks_12plus))
  ## 3rd col of table
  Total_12_plus_wks_oos <- df_filtered |>
    filter(Validation_flag == 'Out of scope') |>
    summarise(out_of_scope = sum(Weeks_12plus),
              .by = Specialty) 
  Total_12_plus_wks_not_Val <- left_join(Total_12_plus_wks_not_Val,Total_12_plus_wks_oos,by="Specialty")
  
  ## 4th col, all the specialties sum
  Total_12_plus_wks_pasVal_all <- df_filtered |>
    filter(Validation_flag == 'PAS Validation DQ') |>
    summarise(PAS_Val_DQ = sum(Weeks_12plus))
  
  ## 4th col of table
  Total_12_plus_wks_pasVal <- df_filtered |>
    filter(Validation_flag == 'PAS Validation DQ') |>
    summarise(PAS_Val_DQ = sum(Weeks_12plus),
              .by = Specialty) 
  Total_12_plus_wks_not_Val <- left_join(Total_12_plus_wks_not_Val,Total_12_plus_wks_pasVal,by="Specialty")
  
  ## 5th col, all the specialties sum
  Total_12_plus_wks_Val_all <- df_filtered |>
    filter(Validation_flag == 'Validated') |>
    summarise(Validated = sum(Weeks_12plus))
  
  ## 5th col of table
  Total_12_plus_wks_Val <- df_filtered |>
    filter(Validation_flag == 'Validated') |>
    summarise(Validated = sum(Weeks_12plus),
              .by = Specialty) 
  Total_12_plus_wks_not_Val <- left_join(Total_12_plus_wks_not_Val,Total_12_plus_wks_Val,by="Specialty") |>
    ## re-arrange columns to match table
    select(1,3,4:6,2)
  
  ## data frame for all the specialties sum for calculated cols
  sum_totals_all <- c(Total_12_plus_wks_all, Total_12_plus_wks_oos_all, Total_12_plus_wks_pasVal_all, Total_12_plus_wks_Val_all, Total_12_plus_wks_not_Val_all)
  sum_totals_all <- as.data.frame(sum_totals_all)
  
  ## data frame for sum of top 10 specialties for calculated cols
  sum_totals_top10 <- Total_12_plus_wks_not_Val |>
    summarise(
      Total12Pluswks_total = sum(Total12Pluswks),
      out_of_scope_total = sum(out_of_scope),
      PAS_Val_DQ_total = sum(PAS_Val_DQ),
      Validated_total = sum(Validated),
      Not_Validated_total = sum(Not_Validated),
    )
  ## now can calculate the all other specialties row in the table
  all_other_specialties <- sum_totals_all - sum_totals_top10
  
  all_other_specialties <- all_other_specialties |>
    mutate(all_other_specialties = "ALL OTHER SPECIALTIES ") |>
    #mutate(Perc_total = NA) |>
    select(6,1:5) |>
    rename(Specialty = all_other_specialties,
           Total12Pluswks = Total12Pluswks,
           out_of_scope = out_of_scope_all,
    )
  ## add/bind  all other specialties totals to the top 10 specialties data frame
  Total_12_plus_wks_not_Val <- rbind(Total_12_plus_wks_not_Val,all_other_specialties)
  
  
  
  ### calculate the grand total of each col
  sum_grand_total <- Total_12_plus_wks_not_Val |>
    summarise(
      Total12Pluswks = sum(Total12Pluswks),
      out_of_scope = sum(out_of_scope),
      PAS_Val_DQ = sum(PAS_Val_DQ),
      Validated = sum(Validated),
      Not_Validated = sum(Not_Validated)
    )
  sum_grand_total <- sum_grand_total |>
    mutate(Specialty = "TOTAL Pathways") |>
    select(6,1:5)
  
  ## now add/bind the grand total row to the main data frame
  Total_12_plus_wks_not_Val <- rbind(Total_12_plus_wks_not_Val,sum_grand_total)
  
  ## calculate the Percentage not validated (Col 7) before adding all cols for final row.
  Total_12_plus_wks_main_df <- Total_12_plus_wks_not_Val |>
    mutate(Percent_not_val = round((Not_Validated/(Not_Validated + Validated))*100,1),
           Percent_Val = round((Validated/(Validated + Not_Validated))*100,1))
  
  
  Total_12_plus_wks_main_df
  ## rename cols to match the required table
  Total_12_plus_wks_main_df <- Total_12_plus_wks_main_df |>
    rename("Top 10 Specialties" = Specialty,
           "Total 12+ weeks" = Total12Pluswks,
           "Out of scope" = out_of_scope,
           "PAS Validation DQ" = PAS_Val_DQ,
           "Not Validated" = Not_Validated,
           #  "% Not Validated" = Percent_not_val,
           #  "% Validated" = Percent_Val
    )
  return(Total_12_plus_wks_main_df)
}