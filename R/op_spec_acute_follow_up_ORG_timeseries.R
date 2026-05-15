##############################################################
#### function to create data frames for each Organization ####
### Inpatients: specific acute day case activity ######
##############################################################

op_spec_acute_follow_up_ORG_timeseries <- function(org_code) {

    ###############################################################################
    ##### Prepare Data for line chart ############################################
    ##############################################################################
    data_RTT_datamarta <- data_RTT_datamarta |>
      filter(Reporting_Period >= get_last_two_fy_start()) |>
     filter(Organisation_Code == org_code)
    
    ## 1st monthly RTT, for 24/25, 25/26 Monthly numerator and denominator from datamart table
    
    data_ip_acute_daycase <- data_RTT_datamarta |>
      # filter(ICB == "Devon") |>
      filter(Measure == "HB: FU OP (Unadj. XDI)" & (FY %in% get_last_two_fy_labels_monthly())
             & Metric_Type == "Count") |>
      filter(Data_Source == "JAR") |> # new filter added
      mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
      group_by(FY, Month,Month_Yr) |>
      summarise(ip_acute_daycase_activty = sum(Metric_Value),.groups = "drop") |>
    
      mutate(Reporting_Period = as.Date(paste0("01-",Month_Yr),format = "%d-%b-%y")) |>
      select(5,2,3,1,4) |>
      mutate(data_tye = "RTT Monthly") |>
      
      select(Reporting_Period,Month,Month_Yr,FY,data_tye,ip_acute_daycase_activty)
    
    ##########################################
    
    ## prepare 2nd table Plan
    data_ip_activtiy_plan <- data_RTT_datamarta |>
      filter(Measure == "HB: FU OP (Unadj. XDI)") |>
      filter(Data_Source == "Plans") |>
      select(10,2,18,1,17,7,8) |>
      group_by(FY,Reporting_Period,Month) |>
      mutate(Month_Yr = format(Reporting_Period,"%b-%y")) |>
      mutate(data_tye = "Plan") |>
    
      select(Reporting_Period, Month, Month_Yr,FY, data_tye, Metric_Value) |>
      rename(ip_acute_daycase_activty = Metric_Value) |>
      # for sake of line graph back date the 25/26 target line to 24/25
      mutate(Reporting_Period = Reporting_Period %m-% years(1))
    data_ip_activtiy_plan$Reporting_Period <- as.Date(data_ip_activtiy_plan$Reporting_Period)
    data_ip_activtiy_plan <- data_ip_activtiy_plan |>
      filter(Reporting_Period >= get_last_two_fy_start())
    
    ######## End of Plan Performance Table creation ###############################  

    ######################################################
    ### combine the data tables and plot time series #####
    ######################################################
    
    #  names(data_rtt_target) <- names(data_rtt_monthlyt)
    #  names(data_rtt_perf_plan) <- names(data_rtt_monthlyt)  
    ip_spec_acute_final <- rbind(data_ip_acute_daycase, data_ip_activtiy_plan) 
    
    ip_spec_acute_final <- ip_spec_acute_final |>
      mutate(
        date_timeseries = ifelse( FY == get_last_two_fy_labels_monthly()[2],Reporting_Period %m-% years(1), Reporting_Period )) |>
      filter(!is.na(ip_acute_daycase_activty))
    ip_spec_acute_final$date_timeseries <- as.Date(ip_spec_acute_final$date_timeseries)
    
    return(ip_spec_acute_final)
    ###### create a total row for the data frame #########
  }