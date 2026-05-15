##########################################################################
### Functions for PIFU Utilisatin and Missed appointments ####
#########################################################################

#data wrangling and setting up table
source(here("R","fun_pifu_utilisation_ORG.R"))
source(here("R","fun_pifu_utilisation_ICB.R"))
source(here("R","fun_pifu_utilisation_REGION.R"))

source(here("R","fun_missed_appointments_ORG.R"))
source(here("R","fun_missed_appointments_ICB.R"))
source(here("R","fun_missed_appointments_REGION.R"))

#source("R/fun_wait_to_1st_activity_ICB.R")
#source("R/fun_wait_to_1st_activity_REGION.R")

#formatting table
source(here("R","fun_fmt_pifu_utilisation.R"))
source(here("R","fun_fmt_missed_appointments.R"))

#data prep for timeseries chart
source(here("R","fun_pifu_utilisation_ORG_timeseries.R"))
source(here("R","fun_pifu_utilisation_ICB_timeseries.R"))
source(here("R","fun_pifu_utilisation_REGION_timeseries.R"))

source(here("R","fun_missed_appointments_ORG_timeseries.R"))
source(here("R","fun_missed_appointments_ICB_timeseries.R"))
source(here("R","fun_missed_appointments_REGION_timeseries.R"))


#source("R/fun_Wait_to_1st_Activity_ICB_timeseries.R")

#create notes for table
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_SW.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ICB.R")
#source("fun_Val_of_Pathway_12PlusWeeks_create_notes_ORG.R")

# plot timeseries function
#source("fun_plot_timeseries_RTT_perf.R")
source(here("R","fun_pifu_utilisation_Plot_timeseries.R"))
source(here("R","fun_missed_appointments_Plot_timeseries.R"))
