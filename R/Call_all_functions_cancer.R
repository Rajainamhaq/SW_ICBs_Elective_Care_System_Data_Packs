##########################################################################
### Functions for Cancer 28 days FDS, 31days Combined Std and 62 days Combined Standards ####
#########################################################################

#data wrangling and setting up table
source(here("R","fun_28days_faster_diag_std_ORG.R"))
source(here("R","fun_28days_faster_diag_std_ICB.R"))
source(here("R","fun_28days_faster_diag_std_REGION.R"))

source(here("R","fun_31days_combined_std_ORG.R"))
source(here("R","fun_31days_combined_std_ICB.R"))
source(here("R","fun_31days_combined_std_REGION.R"))


source(here("R","fun_62days_combined_std_ORG.R"))
source(here("R","fun_62days_combined_std_ICB.R"))
source(here("R","fun_62days_combined_std_REGION.R"))
#source("R/fun_wait_to_1st_activity_ICB.R")
#source("R/fun_wait_to_1st_activity_REGION.R")

#formatting table
source(here("R","fun_fmt_28days_fds.R"))
source(here("R","fun_fmt_31days_comb_std.R"))
source(here("R","fun_fmt_62days_comb_std.R"))

#data prep for timeseries chart
source(here("R","fun_28days_faster_diag_std_ORG_timeseries.R"))
source(here("R","fun_28days_faster_diag_std_ICB_timeseries.R"))
source(here("R","fun_28days_faster_diag_std_REGION_timeseries.R"))

source(here("R","fun_31days_combined_std_ORG_timeseries.R"))
source(here("R","fun_31days_combined_std_ICB_timeseries.R"))
source(here("R","fun_31days_combined_std_REGION_timeseries.R"))

source(here("R","fun_62days_combined_std_ORG_timeseries.R"))
source(here("R","fun_62days_combined_std_ICB_timeseries.R"))
source(here("R","fun_62days_combined_std_REGION_timeseries.R"))


#source("R/fun_Wait_to_1st_Activity_ICB_timeseries.R"))

#create notes for table
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_SW.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ORG.R")

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R")
source(here("R","fun_28days_faster_diag_std_Plot_timeseries.R"))
source(here("R","fun_31days_combined_Plot_timeseries.R"))
source(here("R","fun_62days_combined_Plot_timeseries.R"))
