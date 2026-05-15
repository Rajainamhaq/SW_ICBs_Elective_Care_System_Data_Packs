#########################################################################
#### function to get 52 week plus % value from time series table######
########################################################################

fun_for_box_value_52_plus_week_volumes <- function(df_for_series_52_week_volumes) {
  
  #df_timeseries <- fun_RTT_Perf_REGION_timeseries()
  
    box_monthly_RTT <- df_for_series_52_week_volumes |>
      filter(data_type == "RTT Monthly") 
    max_monthly_rtt_date <- max(box_monthly_RTT$Reporting_Period)
    max_rtt_date_box <- as.character(format(max_monthly_rtt_date,"%b-%y"))
    box_monthly_RTT <- box_monthly_RTT |>
      filter(Reporting_Period == max_monthly_rtt_date) 
    box_monthly_RTT_perf = as.numeric(box_monthly_RTT[1,6])
    
    box_wlmds_RTT <- df_for_series_52_week_volumes |>
      filter(data_type == "WLMDS") 
    max_wlmds_rtt_date <- max(box_wlmds_RTT$Reporting_Period)
    max_wlmds_date_box <- as.character(format(max_wlmds_rtt_date,"%d-%b-%y"))
    box_wlmds_RTT <- box_wlmds_RTT |>
      filter(Reporting_Period == max_wlmds_rtt_date) 
    box_wlmds_RTT_perf = as.numeric(box_wlmds_RTT[1,6]) 
    
   
    ## get the target and baseline values for the box display
   # rtt_target <- df_for_series_52_week_volumes |>
  #    filter(FY == "Mar-26 target")
  #  box_rtt_target = mean(round(as.numeric(rtt_target[1,6])*100,1))
    
#    rtt_baseline <- df_for_series_52_plus |>
 #     filter(FY == "Nov-24 baseline")
#    box_rtt_baseline = mean(round(as.numeric(rtt_baseline[1,6])*100,1))
      
    
   return(list( 
      box_monthly_RTT_perf,
      box_wlmds_RTT_perf,
      max_rtt_date_box,
      max_wlmds_date_box
    #  box_rtt_target
   #   box_rtt_baseline
      )
      )
  
}