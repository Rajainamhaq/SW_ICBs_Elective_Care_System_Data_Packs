################################################################
### Functions for WL and Clocks  ####
###############################################################


#data wrangling and setting up table
#source("R/fun_52_week_perc_ORG.R")
#source("R/fun_52_week_perc_ICB.R")
#source("R/fun_52_week_perc_REGION.R")
#formatting table
#source("R/fun_fmt_52_week_perc.R")

#functions for clock starts time series
source(here("R","fun_clock_starts_ORG_timeseries.R"))
source(here("R","fun_clock_starts_ICB_timeseries.R"))
source(here("R","fun_clock_starts_REGION_timeseries.R"))
#functions for clock stops time series
source(here("R","fun_clock_stops_ORG_timeseries.R"))
source(here("R","fun_clock_stops_ICB_timeseries.R"))
source(here("R","fun_clock_stops_REGION_timeseries.R"))
#functions for clock stops time series
source(here("R","fun_rtt_waiting_list_ORG_timeseries.R"))
source(here("R","fun_rtt_waiting_list_ICB_timeseries.R"))
source(here("R","fun_rtt_waiting_list_REGION_timeseries.R"))

# for plotting timeseries for all above functions
source(here("R","fun_clocks_plot_timeseries.R"))

# Waiting list and clock starts/stops table functions
source(here("R","fun_rtt_waiting_list_ORG.R"))
source(here("R","fun_rtt_waiting_list_ICB.R"))
source(here("R","fun_rtt_waiting_list_REGION.R"))
# table formatting functions
source(here("R","fun_fmt_rtt_waiting_list.R"))


## functions for waterfall chart for waiting list activity
source(here("R","fun_rtt_waiting_list_waterfall_ORG.R"))
source(here("R","fun_rtt_waiting_list_waterfall_ICB.R"))
source(here("R","fun_rtt_waiting_list_waterfall_REGION.R"))



