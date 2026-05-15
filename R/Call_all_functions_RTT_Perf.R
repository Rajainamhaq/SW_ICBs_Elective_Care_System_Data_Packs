################################################################
### Functions for RTT % Performance Slide 2 ####
###############################################################


#data wrangling and setting up table
source(here("R","fun_RTT_Perf_ORG.R"))
source(here("R","fun_RTT_Perf_ICB.R"))
source(here("R","fun_RTT_Perf_REGION.R"))
#formatting table
source(here("R","fun_fmt_RTT_Perf.R"))
#data prep for timeseries chart
source(here("R","fun_RTT_Perf_REGION_timeseries.R"))
source(here("R","fun_RTT_Perf_ORG_timeseries.R"))
source(here("R","fun_RTT_Perf_ICB_timeseries.R"))
#create notes for table
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_SW.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ORG.R")

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R")
source(here("R","fun_RTT_Perf_Plot_timeseries.R"))
source(here("R","fun_for_box_value.R"))


