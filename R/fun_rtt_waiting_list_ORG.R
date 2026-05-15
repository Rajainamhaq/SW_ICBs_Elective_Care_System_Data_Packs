##############################################################
#### function to create data frames for each Organization ####
### RTT Waiting List table  ######
##############################################################

fun_rtt_waiting_list_ORG <- function(OrgCode) {

  prev_yr_mth_date <- (max_date_RTT_Monthly %m-% years(1))
  latest_mth_chr <- as.character(format(max_date_RTT_Monthly,"%b-%y"))
  latest_mth_prev_yr_chr <- as.character(format((max_date_RTT_Monthly %m-% years(1)),"%b-%y"))
  
  # get two year back date for clock starts/stop
  prev_2yr_mth_date <- max_date_RTT_Monthly %m-% years(2)
  
  data_RTT_datamarta <- data_RTT_datamarta |>
    filter(Organisation_Code == OrgCode)
  
  #######################################################  
#### Total waiting list growth table 1 ################
#######################################################
  
# take latest month metric value     
RTT_list_latest_mth <- data_RTT_datamarta |>
  filter( Measure == "RTT waiting list" 
          & Data_Source == "RTT monthly",
          Reporting_Period == max_date_RTT_Monthly) |>
  #& !is.na(Specialty_Modality)) |>
  group_by(Specialty_Modality1) |>
  summarise(June25_rtt = sum(Metric_Value,na.rm = TRUE)) 

# take same month (latest) but last year month metric value     
RTT_list_prev_yr_mth <- data_RTT_datamarta |>
  filter( Measure == "RTT waiting list" 
          & Data_Source == "RTT monthly",
          Reporting_Period ==  prev_yr_mth_date) |>
  #& !is.na(Specialty_Modality)) |>
  group_by(Specialty_Modality1) |>
  summarise(June24_rtt = sum(Metric_Value,na.rm = TRUE)) 


# combine above two data frames
RTT_tablet <- RTT_list_prev_yr_mth |>
    left_join(RTT_list_latest_mth, by = "Specialty_Modality1") |>
   # RTT_table[is.na(RTT_table)] <- 0 |>
    #calculate Growth %
    mutate(Growth_rtt = (June25_rtt-June24_rtt)/June24_rtt*100) |>
    rename(Specialty = Specialty_Modality1) |>
    arrange(desc(Growth_rtt))
# get the top 10 specialties by growth and gorup the rest of them to show as aggregate
RTT_tablet_top10 <- RTT_tablet |>
  slice_head(n=10)
# df for all other specialties after taking off top 10 rows
RTT_table_allother <- RTT_tablet[-(1:10),]
June24_rtt <- sum(RTT_table_allother$June24_rtt, na.rm = TRUE)
June25_rtt <- sum(RTT_table_allother$June25_rtt, na.rm = TRUE)
#Growth_rtt <- (June25_rtt-June24_rtt)/June24_rtt*100
Specialty <- "All other specialties"
RTT_table_allother_total <- data.frame(Specialty, June24_rtt,June25_rtt)
RTT_table_allother_total <- RTT_table_allother_total |>
  mutate(Growth_rtt = (June25_rtt-June24_rtt)/June24_rtt*100)

## get the total of all specialties
June24_rtt <- sum(RTT_tablet$June24_rtt, na.rm = TRUE)
June25_rtt <- sum(RTT_tablet$June25_rtt, na.rm = TRUE)
#Growth_rtt <- (June25_rtt-June24_rtt)/June24_rtt*100
Specialty <- "All specialties"
RTT_tablet_total <- data.frame(Specialty, June24_rtt,June25_rtt)
RTT_tablet_total <- RTT_tablet_total |>
  mutate(Growth_rtt = (June25_rtt-June24_rtt)/June24_rtt*100)

## bind all 3 data frames e.g. top 10, all others and totals

RTT_tablet_df <- bind_rows(RTT_tablet_top10,RTT_table_allother_total,RTT_tablet_total)

  
### End of Total waiting list growth table creation #######################################  
  
  #######################################################  
  #### Clock starts (12month) with growth table 2 #######
  #######################################################

  # take latest month metric value     
 clk_starts_latest_mth <- data_RTT_datamarta |>
    filter( Measure == "Clock Starts" 
            & Data_Source == "RTT monthly",
            (Reporting_Period <= max_date_RTT_Monthly & Reporting_Period > prev_yr_mth_date)) |>
    #& !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality1) |>
    summarise(June25_starts = sum(Metric_Value,na.rm = TRUE)) 
  
  # take same month (latest) but last year month metric value     
  clk_starts_prev_yr_mth <- data_RTT_datamarta |>
    filter( Measure == "Clock Starts" 
            & Data_Source == "RTT monthly",
            (Reporting_Period <= prev_yr_mth_date & Reporting_Period >  prev_2yr_mth_date))  |>
    #& !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality1) |>
    summarise(June24_starts = sum(Metric_Value,na.rm = TRUE)) 
  
  
  # combine above two data frames
  clk_starts_tablet <- clk_starts_prev_yr_mth |>
    left_join(clk_starts_latest_mth, by = "Specialty_Modality1") |>
    # RTT_table[is.na(RTT_table)] <- 0 |>
    #calculate Growth %
    mutate(Growth_starts = (June25_starts-June24_starts)/June24_starts*100) |>
    rename(Specialty = Specialty_Modality1)
  
   ## pick the top 10 specialties grwoth wise from waiting list table to match in clock starts and stops..
   lookup_spec <- c(RTT_tablet_top10$Specialty)
   
   clk_starts_tablet_10 <- clk_starts_tablet |>
     filter(Specialty %in% lookup_spec)
   
   clk_starts_tablet_all_other <- clk_starts_tablet |>
     filter(!(Specialty %in% lookup_spec))
   # aggregate the columns for all other specialties
   June24_starts <- sum(clk_starts_tablet_all_other$June24_starts, na.rm = TRUE)
   June25_starts <- sum(clk_starts_tablet_all_other$June25_starts, na.rm = TRUE)
   #Growth_rtt <- (June25_rtt-June24_rtt)/June24_rtt*100
   Specialty <- "All other specialties"
   clk_starts_tablet_all_other <- data.frame(Specialty, June24_starts,June25_starts)
   clk_starts_tablet_all_other <- clk_starts_tablet_all_other |>
     mutate(Growth_starts = (June25_starts-June24_starts)/June24_starts*100)
   
   ## now create data frame for overall totals for starts
   June24_starts <- sum(clk_starts_tablet$June24_starts, na.rm = TRUE)
   June25_starts <- sum(clk_starts_tablet$June25_starts, na.rm = TRUE)
   #Growth_rtt <- (June25_rtt-June24_rtt)/June24_rtt*100
   Specialty <- "All specialties"
   clk_starts_tablet_totals <- data.frame(Specialty, June24_starts,June25_starts)
   clk_starts_tablet_totals <- clk_starts_tablet_totals |>
     mutate(Growth_starts = (June25_starts-June24_starts)/June24_starts*100)
  
   ## bind the top 10, all others and totals for clock starts
   clk_starts_df <- bind_rows(clk_starts_tablet_10,clk_starts_tablet_all_other,clk_starts_tablet_totals)
  
  ### End of Clock starts with growth table creation #######################################  
  
  
  #######################################################  
  #### Clock stops (12month) with growth table 3 #######
  #######################################################
  
  # take latest month metric value     
  clk_stops_latest_mth <- data_RTT_datamarta |>
    filter(Measure == "Clock Stops" 
            & Data_Source == "RTT monthly",
            (Reporting_Period <= max_date_RTT_Monthly & Reporting_Period > prev_yr_mth_date)) |>
    #& !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality1) |>
    summarise(June25_stops = sum(Metric_Value,na.rm = TRUE)) 
  
  # take same month (latest) but last year month metric value     
  clk_stops_prev_yr_mth <- data_RTT_datamarta |>
    filter( Measure == "Clock Stops" 
            & Data_Source == "RTT monthly",
            (Reporting_Period <= prev_yr_mth_date & Reporting_Period >  prev_2yr_mth_date))  |>
    #& !is.na(Specialty_Modality)) |>
    group_by(Specialty_Modality1) |>
    summarise(June24_stops = sum(Metric_Value,na.rm = TRUE)) 
  
  
  # combine above two data frames
  clk_stops_tablet <- clk_stops_prev_yr_mth |>
    left_join(clk_stops_latest_mth, by = "Specialty_Modality1") |>
    # RTT_table[is.na(RTT_table)] <- 0 |>
    #calculate Growth %
    mutate(Growth_stops = (June25_stops-June24_stops)/June24_stops*100) |>
    rename(Specialty = Specialty_Modality1)

  ## take the top 10 specialties of waiting list data frame
  clk_stops_tablet_10 <- clk_stops_tablet |>
    filter(Specialty %in% lookup_spec)
  
  clk_stops_tablet_all_other <- clk_stops_tablet |>
    filter(!(Specialty %in% lookup_spec))
  # aggregate the columns for all other specialties
  June24_stops <- sum(clk_stops_tablet_all_other$June24_stops, na.rm = TRUE)
  June25_stops <- sum(clk_stops_tablet_all_other$June25_stops, na.rm = TRUE)
  #Growth_rtt <- (June25_rtt-June24_rtt)/June24_rtt*100
  Specialty <- "All other specialties"
  clk_stops_tablet_all_other <- data.frame(Specialty, June24_stops,June25_stops)
  clk_stops_tablet_all_other <- clk_stops_tablet_all_other |>
    mutate(Growth_stops = (June25_stops-June24_stops)/June24_stops*100)
  
  ## now create data frame for overall totals for stops
  June24_stops <- sum(clk_stops_tablet$June24_stops, na.rm = TRUE)
  June25_stops <- sum(clk_stops_tablet$June25_stops, na.rm = TRUE)
 Specialty <- "All specialties"
  clk_stops_tablet_totals <- data.frame(Specialty, June24_stops,June25_stops)
  clk_stops_tablet_totals <- clk_stops_tablet_totals |>
    mutate(Growth_stops = (June25_stops-June24_stops)/June24_stops*100)  
##  
  ## bind the top 10, all others and totals for clock stops
  clk_stops_df <- bind_rows(clk_stops_tablet_10,clk_stops_tablet_all_other,clk_stops_tablet_totals)
  
  ### End of Clock starts with growth table creation #######################################    
  
  #####################################
  ## combine above 3 tables ##########
  ####################################
  
  wl_and_clocks <- RTT_tablet_df |>
    left_join(clk_starts_df, by="Specialty") |>
    left_join(clk_stops_df, by="Specialty")

######## End of RTT Performance Table creation ###############################

return(wl_and_clocks)

}