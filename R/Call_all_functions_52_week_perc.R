################################################################
### Functions for RTT % Performance Slide 2 ####
###############################################################


#data wrangling and setting up table
source(here("R","fun_52_week_perc_ORG.R"))
source(here("R","fun_52_week_perc_ICB.R"))
source(here("R","fun_52_week_perc_REGION.R"))
#formatting table
source(here("R","fun_fmt_52_week_perc.R"))
#data prep for time series chart percentages
source(here("R","fun_52_week_perc_REGION_timeseries.R"))
source(here("R","fun_52_week_perc_ORG_timeseries.R"))
source(here("R","fun_52_week_perc_ICB_timeseries.R"))
#data prep for time series chart volumes
source(here("R","fun_52_week_volume_ORG_timeseries.R"))
source(here("R","fun_52_week_volume_ICB_timeseries.R"))
source(here("R","fun_52_week_volume_REGION_timeseries.R"))
#create notes for table
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_SW.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ORG.R")

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R")
source(here("R","fun_52_week_perc_Plot_timeseries.R"))
source(here("R","fun_52_week_volume_Plot_timeseries.R"))
#source("R/fun_for_box_value.R")

# call func for 52 plus week %
source(here("R","fun_for_box_value_52_plus_week.R"))
# call func for 52 plus week volumens
source(here("R","fun_for_box_value_52_plus_week_volumes.R"))