##############################################################################
#### function to create time series chart for Wiat to first Performance ######
##############################################################################

fun_theatre_avgcases_Plot_timeseries <- function(df_for_thtr_avgcases_series) {

max_thtr_date <-  format(max(df_for_thtr_avgcases_series$Reporting_Period),"%b-%y")
  
#df_timeseries |>
y_min <- min(df_for_thtr_avgcases_series$Metric_Value, na.rm = TRUE)
y_max <- max(df_for_thtr_avgcases_series$Metric_Value, na.rm = TRUE)

labels <- unique(df_for_thtr_avgcases_series$FY)

#linetypes <- c("dashed","solid")
#names(linetypes) <- labels

#label_colour <- unique(df_for_thtr_avgcases_series$FY)
#colours <- c("#0041C2","#0041C2")
#names(colours) <- label_colour


linetypes <- rep(c("dashed", "solid"), length.out = length(labels))
names(linetypes) <- labels

colours <- rep("#0041C2", length(labels))
names(colours) <- labels

last_yr <- labels[1]
idx <- df_for_thtr_avgcases_series$FY == last_yr

df_for_thtr_avgcases_series$date_timeseries[idx] <- 
  df_for_thtr_avgcases_series$date_timeseries[idx] %m+% years(1)


df_for_thtr_avgcases_series |>
  select(date_timeseries, FY, Metric_Value) |>
  ggplot(aes(
    x = date_timeseries,
    y = Metric_Value,
    colour = FY,
    linetype = FY
  )) +
  geom_line(size = 1) +
  
  ## commented out as graph looked cluttered with lables in line chart
  #geom_text(
  #  aes(label = number(Metric_Value, accuracy = 0.1)),
  #  vjust = -0.5,
  #  show.legend = FALSE
  #) +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  
  scale_linetype_manual(values = linetypes) +
  scale_colour_manual(values = colours) +
  
  scale_y_continuous(
    labels = scales::number_format(accuracy = 0.1),
    limits = c(y_min - 0.05, y_max + 0.05),
    breaks = scales::pretty_breaks(n = 4)
  ) +
  labs(
    caption = paste0(
      "Data source: National Theatre Data Collection to ",
      max_thtr_date
    ),
    x = NULL,
    y = NULL
  ) +
  theme_bw() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    legend.key.width = unit(2, "cm"),
    plot.caption = element_text(
      hjust = 0,          
      size = 9,
      colour = "gray40"
    )
  )
######################################
 
 #return (df_timeseries)
}
  
  