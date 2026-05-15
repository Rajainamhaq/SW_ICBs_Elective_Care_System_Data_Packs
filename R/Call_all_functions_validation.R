################################################################
### Functions for 12+ week validation ####
###############################################################


#data wrangling and setting up table
source(here("R","fun_12plus_week_validation_ORG.R"))
source(here("R","fun_12plus_week_validation_ICB.R"))
source(here("R","fun_12plus_week_validation_REGION.R"))
#formatting table
source(here("R","fun_fmt_12week_validation.R"))
#data prep for timeseries chart
source(here("R","fun_12week_validation_REGION_timeseries.R"))
source(here("R","fun_12week_validation_ICB_timeseries.R"))
source(here("R","fun_12week_validation_ORG_timeseries.R"))
#create notes for table
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_SW.R"))
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB.R"))
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ORG.R"))

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R"))
source(here("R","fun_12plus_week_validation_Plot_timeseries.R"))
