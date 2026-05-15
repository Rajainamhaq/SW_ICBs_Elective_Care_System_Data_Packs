
fun_rtt_waiting_list_waterfall_ORG <- function(OrgCode) {
  
  prev_mth_date <- max_date_RTT_Monthly %m-% months(1)
  latest_mth_chr <- as.character(format(max_date_RTT_Monthly,"%b-%y"))
  prev_mth_date_chr <- as.character(format(prev_mth_date,"%b-%y"))
  
  
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Organisation_Code == OrgCode)
    #filter(Organisation_Code == "RH8")
  
  #################################################
  ## create variable values for waterfall chart ###
  #################################################
  
    ## latest month total waiting list value for graph
  RTT_list_latest_mth_wf <- data_RTT_datamarta |>
    filter( Measure == "RTT waiting list" 
            & Data_Source == "RTT monthly",
            Reporting_Period == max_date_RTT_Monthly) 
  latest_waiting_list <- sum(RTT_list_latest_mth_wf$Metric_Value)
  
  ## one months back, total waiting list value for graph
  RTT_list_latest_pre_mth_wf <- data_RTT_datamarta |>
    filter( Measure == "RTT waiting list" 
            & Data_Source == "RTT monthly",
            Reporting_Period ==prev_mth_date) 
  waiting_list_prv_mth <- sum(RTT_list_latest_pre_mth_wf $Metric_Value)
  
  ## clock starts latest month
  clk_starts_wf <- data_RTT_datamarta |>
    filter( Measure == "Clock Starts" 
            & Data_Source == "RTT monthly",
            Reporting_Period == max_date_RTT_Monthly) 
  clk_starts_latest_mth <- sum(clk_starts_wf$Metric_Value)
  
  ## clock stops latest month
  clk_stops_wf <- data_RTT_datamarta |>
    filter( Measure == "Clock Stops" 
            & Data_Source == "RTT monthly",
            Reporting_Period == max_date_RTT_Monthly) 
  clk_stops_latest_mth <- sum(clk_stops_wf$Metric_Value)

  ## difference in clock stops and clock starts
  clk_diff <- clk_starts_latest_mth - clk_stops_latest_mth
  
  ####### End of waterfall values creation ########################  
  

data_wf <- data.frame(
  #Category = c(prev_mth_date_chr, "Total Sales (June)", "Total Expenses (June)", "June Net Profit"),
  Category = c(prev_mth_date_chr, "Clock starts","Clock stops", latest_mth_chr),
  wl_size = c( waiting_list_prv_mth , clk_starts_latest_mth, -clk_stops_latest_mth, latest_waiting_list)  # NA for final total; it will be calculated
)

# ==== Prepare Waterfall Data ====

# this is for difference in lates month and prevous month value
  diff_value <- latest_waiting_list - waiting_list_prv_mth
  diff_value_perc <- ((latest_waiting_list - waiting_list_prv_mth)/waiting_list_prv_mth)
# to create the label like +12,000 or -7,777
  diff_label <- paste0(
    ifelse(diff_value >= 0, "+", ""),
    scales::comma(diff_value),
    " (",
    ifelse(diff_value_perc >= 0, "+", ""),
    scales::percent(diff_value_perc, accuracy = 0.01),
    ")"
  )
  
  
data_wf1 <- data_wf |>
  mutate(
    end = cumsum(replace_na(wl_size, 0)),
    start = lag(end, default = 0),
    Type = case_when(
      is.na(wl_size) ~ "Waiting List",
      wl_size >= 0 ~ "Clock starts",
      TRUE ~ "Clock stops"
    )
  )

# Make sure final total equals cumulative result
data_wf1$end[nrow(data_wf1)] <- data_wf1$wl_size[nrow(data_wf1)]
data_wf1$start[nrow(data_wf1)] <- 0

## reorder bars using factor
data_wf1$Category <- factor( data_wf1$Category,
  levels = c(prev_mth_date_chr,"Clock starts","Clock stops",latest_mth_chr)
)


footnote_text <- md(
  paste0(
    "Data source: RTT monthly published statistics from ",
    prev_mth_date_chr,
    " to ", latest_mth_chr,
    "\nDifference between clock starts and clock stops is ",
    #"**", comma(clk_diff), "**"
    comma(clk_diff)
  )
)



# ==== Plot Waterfall ====

data_wf1[1,5] <- "Waiting List"
data_wf1[4,5] <- "Waiting List"

# add custom fill column to overridde 1st and 4th bar colour
data_wf1$fill_color <- ifelse(
  data_wf1$Type == "Waiting List",  # first and fourth rows
  "#005EB8",                      # color for these bars
  ifelse(data_wf1$Type == "Clock starts", "#AE2573", "#009639")
)


ggplot(data_wf1) +
  geom_rect(aes(
    xmin = as.numeric(factor(Category)) - 0.4,
    xmax = as.numeric(factor(Category)) + 0.4,
    ymin = pmin(start, end),
    ymax = pmax(start, end),
    fill = Type
  )) +
  geom_text(aes(
    x = Category,
    y = ifelse(wl_size < 0, start, end),
    label = ifelse(is.na(wl_size), comma(end), comma(wl_size))
  ),
  vjust = -0.7, size = 4)  +
  
  ## Difference label on top of latest month bar
  geom_text(
    data = data_wf1[nrow(data_wf1), ],
    aes(
      x = Category,
      y = end,
      label = paste0("\n", diff_label, "")
    ),
    vjust = -0.8,
    size = 4,
    fontface = "bold"
  ) +
  
  
  scale_fill_manual(values = c("Clock starts" = "#AE2573", "Clock stops" = "#4CAF50","Waiting List"="#005EB8")) +
  
  scale_y_continuous(
    limits = c(0,max(data_wf1$end, na.rm = TRUE)*1.1),
   # labels = scales::comma
   labels = label_number()
  ) +
  
  labs(
    title = "Change in the waiting list",
    x = NULL,
    y = NULL,
    caption = footnote_text
  ) +
  theme_bw() +
  theme(legend.position = "bottom",
        legend.title = element_blank(),      # Optional: remove legend title
        axis.text.x = element_text(angle = 45, hjust = 1),  # Optional: rotate x labels
        #   axis.text.y = element_text(fontface = "bold"),
        panel.grid.major.x = element_blank(),  # Remove major Y grid lines
        panel.grid.minor.x =  element_blank(),  # Remove minor Y grid lines
        plot.caption = element_text(size = 9,colour = "grey30", hjust = 0))
}