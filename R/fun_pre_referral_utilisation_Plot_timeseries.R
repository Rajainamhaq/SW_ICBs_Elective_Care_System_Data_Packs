####################################################################
#### function to create time series chart for Spec Advice utilization - pre referral ######
###################################################################

fun_pre_referral_utilisation_Plot_timeseries <- function(df_for_series) {
### get max dates for foot note ####
  Targetv_spec_adv <- 12.6
    max_date <- df_for_series |>
      filter(FY == get_last_two_fy_labels_monthly()[2] & data_tye == "RTT Monthly")
    week_ending_fn <- format(max(max_date$Reporting_Period),"%b-%y")   
    
    min_y <- min((df_for_series$perf_perc ),Targetv_spec_adv)-2
    max_y <- max((df_for_series$perf_perc ),Targetv_spec_adv)+2
    
    
## plot the time series    
 #df_timeseries |>
   df_for_series |>
    #select(Report, FY, perf_perc) |>
     select(date_timeseires, FY, perf_perc) |>
    ggplot(aes(x = date_timeseires, y = perf_perc, color = FY, linetype = FY)) +
    geom_line(size=1) +
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
   # scale_linetype_manual(values = c("dashed", "solid", "dotted")) +  # Specify dotted lines
  #  scale_color_manual(values = c("#005EB8",  "#005EB8", "red")) + 
     
     fy_colour_scale_mthly_spec_adv() +
     fy_linetype_scale_mthly_spec_adv()+
  
    scale_y_continuous(limits = c(min_y, max_y),labels = label_number(accuracy = 1)) + 
    labs(x = NULL, y = NULL, title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data sources: System EROC and SUS OPA to ", week_ending_fn)
    )+
    theme(
      legend.position = "bottom",          # Move legend to bottom
      legend.title = element_blank(),      # Optional: remove legend title
      axis.text.x = element_text(angle = 45, hjust = 1),  # Optional: rotate x labels
      #   axis.text.y = element_text(fontface = "bold"),
      panel.grid.major.x = element_blank(),  # Remove major Y grid lines
      panel.grid.minor.x =  element_blank(),  # Remove minor Y grid lines
      plot.caption = element_text(size = 9, hjust = 0, color = "gray30")
      
    )

}
  
  