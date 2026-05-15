##############################################################
#### function to create data frames for each Organization ####
### Inpatients: specific acute day case activity ######
##############################################################

op_spec_acute_1st_followup_ratios_ORG_timeseries <- function(org_code) {

  ## to calculate ration need to data froms so can divide the values, one from 1st op activity and 
  ## 2nd one follow-up activity
  
    ###############################################################################
    ##### create data frame for 1st OP activity  ##################################
    ##############################################################################
    data_RTT_datamarta <- data_RTT_datamarta |>
      filter(Reporting_Period >= get_last_two_fy_start()) |>
     filter(Organisation_Code == org_code)
    
    ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table
    op_1st_activtiy <- data_RTT_datamarta |>
      # filter(ICB == "Devon") |>
      filter(Measure == "GB: 1st OP (Unadj. XDI)" & (FY %in% get_last_two_fy_labels_monthly())
             & Metric_Type == "Count") |>
      filter(Data_Source == "JAR") |> # new filter added
      mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
      group_by(FY, Month,Month_Yr) |>
      summarise(op_acute_1st_activity = sum(Metric_Value),.groups = "drop") |>
      mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
      select(5,2,3,1,4) |>
      mutate(data_tye = "RTT Monthly") |>
      
      select(Reporting_Period,Month,Month_Yr,FY,data_tye,op_acute_1st_activity)
    
    ##########################################
    ## prepare 2nd table Plan
    op_1st_activtiy_plan <- data_RTT_datamarta |>
      filter(Measure == "GB: 1st OP (Unadj. XDI)") |>
      filter(Data_Source == "Plans") |>
      select(10,2,18,1,17,7,8) |>
      group_by(FY,Reporting_Period,Month) |>
      mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
      mutate(data_tye = "Plan") |>
      select(Reporting_Period, Month, Month_Yr,FY, data_tye, Metric_Value) |>
      rename(op_acute_1st_activity = Metric_Value) |>
      # for sake of line graph back date the 25/26 target line to 24/25
      mutate(Reporting_Period = Reporting_Period %m-% years(1))
    
    op_1st_activtiy_plan$Reporting_Period <- as.Date(op_1st_activtiy_plan$Reporting_Period)
    op_1st_activtiy_plan <- op_1st_activtiy_plan |>
      filter(Reporting_Period >= get_last_two_fy_start())
    
    ######## End of Plan Performance Table creation ###############################  

    ######################################################
    ### combine the data tables and plot time series #####
    ######################################################
    
   df_op_acute_1st_activity <- rbind(op_1st_activtiy, op_1st_activtiy_plan) 
    
    df_op_acute_1st_activity <- df_op_acute_1st_activity |>
      mutate(
        date_timeseries = ifelse( FY == get_last_two_fy_labels_monthly()[2],Reporting_Period %m-% years(1), Reporting_Period )) |>
      filter(!is.na(op_acute_1st_activity))
    df_op_acute_1st_activity$date_timeseries <- as.Date(df_op_acute_1st_activity$date_timeseries)
    
 ############# End of creating 1st OP activtiy data frame #################################   
    
    
    ###############################################################################
    ##### create data frame for follow-up OP activity  ############################
    ##############################################################################
    
    op_follow_up_activity <- data_RTT_datamarta |>
      # filter(ICB == "Devon") |>
      filter(Measure == "HB: FU OP (Unadj. XDI)" & (FY %in% get_last_two_fy_labels_monthly())
             & Metric_Type == "Count") |>
      filter(Data_Source == "JAR") |> # new filter added
      mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
      group_by(FY, Month,Month_Yr) |>
      summarise(op_acute_followup_activity = sum(Metric_Value),.groups = "drop") |>
      mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
      select(5,2,3,1,4) |>
      mutate(data_tye = "RTT Monthly") |>
      
      select(Reporting_Period,Month,Month_Yr,FY,data_tye,op_acute_followup_activity)
    
    ##########################################
    
    ## prepare 2nd table Plan
    op_follow_up_activity_plan <- data_RTT_datamarta |>
      filter(Measure == "HB: FU OP (Unadj. XDI)") |>
      filter(Data_Source == "Plans") |>
      select(10,2,18,1,17,7,8) |>
      group_by(FY,Reporting_Period,Month) |>
      mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
      mutate(data_tye = "Plan") |>
      select(Reporting_Period, Month, Month_Yr,FY, data_tye, Metric_Value) |>
      rename(op_acute_followup_activity = Metric_Value) |>
      # for sake of line graph back date the 25/26 target line to 24/25
      mutate(Reporting_Period = Reporting_Period %m-% years(1))
    
    op_follow_up_activity_plan$Reporting_Period <- as.Date( op_follow_up_activity_plan$Reporting_Period)
    op_follow_up_activity_plan <-  op_follow_up_activity_plan |>
      filter(Reporting_Period >= get_last_two_fy_start())
    
    ######## End of Plan Performance Table creation ###############################  
    
    ######################################################
    ### combine the data tables and plot time series #####
    ######################################################
    df_op_followup_activity <- rbind(op_follow_up_activity, op_follow_up_activity_plan) 
    
    df_op_followup_activity <- df_op_followup_activity |>
      mutate(
        date_timeseries = ifelse( FY == get_last_two_fy_labels_monthly()[2],Reporting_Period %m-% years(1), Reporting_Period )) |>
      filter(!is.na(op_acute_followup_activity))
    df_op_followup_activity$date_timeseries <- as.Date(df_op_followup_activity$date_timeseries)  
    
    ############# End of creating follow up OP activity data frame #################################   
    
    
    ############################################################################
    ######### combine two df for 1s OP and followup activity to get ratios #####
    ###########################################################################
    
    
    op_combine_for_ratio <- df_op_acute_1st_activity |>
      left_join(df_op_followup_activity |> select(Month_Yr,FY,op_acute_followup_activity), 
                by = c("Month_Yr","FY")) |>
      mutate(followup_ratios =  op_acute_followup_activity/op_acute_1st_activity)
    
   
 return(op_combine_for_ratio)
    
  }