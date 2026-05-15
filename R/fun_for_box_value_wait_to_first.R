#########################################################################
#### function to get RTT Performance % value from time series table######
########################################################################

fun_for_box_value_wait_to_first <- function(df_for_series) {
  
  #df_for_series <- fun_Wait_to_1st_Activity_ICB_timeseries()
  #df_for_series <- fun_Wait_to_1st_Activity_ORG_timeseries()
 
    box_wlmds_RTT <- df_for_series |>
      filter(data_tye == "WLMDS") 
    max_wlmds_rtt_date <- max(box_wlmds_RTT$Reporting_Period)
    max_wlmds_date_box <- as.character(format(max_wlmds_rtt_date,"%d-%b-%y"))
    box_wlmds_RTT <- box_wlmds_RTT |>
      filter(Reporting_Period == max_wlmds_rtt_date) 
    box_wlmds_RTT_perf = round(as.numeric(box_wlmds_RTT[1,6])*100,1)  
    
    ## get the target and baseline values for the box display
    rtt_target <- df_for_series |>
      filter(FY == get_current_fy_target())
    box_rtt_target = mean(round(as.numeric(rtt_target[1,6])*100,1))
    
    rtt_baseline <- df_for_series |>
      filter(FY == get_current_fy_baseline())
    box_rtt_baseline = mean(round(as.numeric(rtt_baseline[1,6])*100,1))
    
    ## get the target and baseline labels
    target_label <- substr(get_mar_target_label(),1,6)
    baseline_label <- substr(get_current_fy_baseline(),1,6)
      
    
   return(list( 
      box_wlmds_RTT_perf,
      max_wlmds_date_box,
      box_rtt_target,
      box_rtt_baseline,
      target_label,
      baseline_label
      )
      )
  
}