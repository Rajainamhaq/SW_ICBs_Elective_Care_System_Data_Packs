################################################################
### Functions for Diagnostics ####
###############################################################


#data wrangling and setting up table for 6plus week %
source(here("R","fun_6plus_week_perc_ORG.R"))
source(here("R","fun_6plus_week_perc_ICB.R"))
source(here("R","fun_6plus_week_perc_REGION.R"))
#formatting table
source(here("R","fun_fmt_6plus_week_perc.R"))

# table setup for diagnostic activity functions
source(here("R","fun_diag_activity_ORG.R"))
source(here("R","fun_diag_activity_ICB.R"))
source(here("R","fun_diag_activity_REGION.R"))
#formatting table
source(here("R","fun_fmt_diag_activity.R"))



#data prep for time series chart 6 plus week %
source(here("R","fun_6plus_week_perc_ORG_timeseries.R"))
source(here("R","fun_6plus_week_perc_ICB_timeseries.R"))
source(here("R","fun_6plus_week_perc_REGION_timeseries.R"))

#data prep for time series chart for Diagnostic activity
source(here("R","fun_diag_activity_ORG_timeseries.R"))
source(here("R","fun_diag_activity_ICB_timeseries.R"))
source(here("R","fun_diag_activity_REGION_timeseries.R"))

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R")
source(here("R","fun_6plus_week_perc_Plot_timeseries.R"))
source(here("R","fun_diag_activity_Plot_timeseries.R"))
#source("R/fun_for_box_value.R")


