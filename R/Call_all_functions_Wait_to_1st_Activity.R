################################################################
### Functions for Wait to First Activity ####
###############################################################


#data wrangling and setting up table
source(here("R","fun_wait_to_1st_activity_ORG.R"))
source(here("R","fun_wait_to_1st_activity_ICB.R"))
source(here("R","fun_wait_to_1st_activity_REGION.R"))
#formatting table
source(here("R","fun_fmt_Wait_to_1st_Activity.R"))
#data prep for timeseries chart
source(here("R","fun_Wait_to_1st_Activity_REGION_timeseries.R"))
source(here("R","fun_Wait_to_1st_Activity_ORG_timeseries.R"))
source(here("R","fun_Wait_to_1st_Activity_ICB_timeseries.R"))
#create notes for table
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_SW.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ORG.R")

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R")
source(here("R","fun_Wait_to_1st_activity_Plot_timeseries.R"))
source(here("R","fun_for_box_value_wait_to_first.R"))