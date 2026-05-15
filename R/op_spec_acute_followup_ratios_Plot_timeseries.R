####################################################################
#### function to create time series chart for RTT Performance ######
###################################################################

op_spec_acute_followup_ratios_Plot_timeseries <- function(op_combine_for_ratio) {
###### get max dates for foot note ####
    mon_rtt_date <- op_combine_for_ratio |>
    filter(data_tye == "RTT Monthly") 
    max_rtt_date_fn <- max(mon_rtt_date$Reporting_Period)
    max_rtt_date_fn <- format(max_rtt_date_fn, "%b-%y")
    
    min_y <- floor(min(op_combine_for_ratio$followup_ratios,na.rm = TRUE)*10)/10
    max_y <- ceiling(max(op_combine_for_ratio$followup_ratios,na.rm = TRUE)*10)/10
  
    
## plot the time series    
    op_combine_for_ratio |>
    select(date_timeseries, FY, followup_ratios) |>
    ggplot(aes(x = date_timeseries, y = followup_ratios, color = FY, linetype = FY)) +
    geom_line(size=1) +
     
      ## commented out after Jo's feedback as the graph look cluttered with labels.  
    #  geom_text(
    #    data = filter(op_combine_for_ratio, FY == "25/26 monthly"),
    #    aes(label = round(followup_ratios, 1)),
    #    vjust = -0.5,
    #    size = 3,
    #    show.legend = FALSE
    #  )+
    scale_x_date(date_labels = "%b",
                 date_breaks = "1 month") +
   # scale_linetype_manual(values = c("dashed", "solid", "solid","dotted")) +  # Specify dotted lines
   #scale_color_manual(values = c("#005EB8",  "#005EB8", "#AE2573","red")) + 
      
      fy_colour_scale_all() +
      fy_linetype_scale_all() +
  
    scale_y_continuous(
      breaks = seq(min_y,max_y, by = 0.1 ),
      labels = scales::comma) + 
    labs(x = NULL, y = "First to follow up ratio", title = NULL) +
    # theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme_bw() +
    labs(
      caption = paste0("Data source: SUS OPA specific acute activity to ",max_rtt_date_fn)
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
 
 #return (df_timeseries)
}
  
