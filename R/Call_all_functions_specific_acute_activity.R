################################################################
### Specific Acute In Patient Activity Functions ###############
###############################################################

# functions for Inpatient spec acute elec ordinary cases activity
source(here("R","ip_spec_acute_elec_ord_activity_ORG_timeseries.R"))
source(here("R","ip_spec_acute_elec_ord_activity_ICB_timeseries.R"))
source(here("R","ip_spec_acute_elec_ord_activity_REGION_timeseries.R"))
#Plot time series
source(here("R","ip_spec_acute_elec_ord_activity_Plot_timeseries.R"))

# functions for Inpatient spec acute day case activity
source(here("R","ip_spec_acute_day_case_activity_ORG_timeseries.R"))
source(here("R","ip_spec_acute_day_case_activity_ICB_timeseries.R"))
source(here("R","ip_spec_acute_day_case_activity_REGION_timeseries.R"))
#Plot time series
source(here("R","ip_spec_acute_day_case_activity_Plot_timeseries.R"))
source(here("R","ip_spec_acute_day_case_activity_Plot_timeseries_ICB.R"))

################################################################
### Specific Acute Out Patient Activity Functions ###############
###############################################################
## functions for 1st OP activity
source(here("R","op_spec_acute_1st_appt_ORG_timeseries.R"))
source(here("R","op_spec_acute_1st_appt_ICB_timeseries.R"))
source(here("R","op_spec_acute_1st_appt_REGION_timeseries.R"))
#Plot time series
source(here("R","op_spec_acute_1st_appt_Plot_timeseries.R"))
source(here("R","op_spec_acute_1st_appt_Plot_timeseries_REGION.R"))

## functions for follow up OP activity
source(here("R","op_spec_acute_follow_up_ORG_timeseries.R"))
source(here("R","op_spec_acute_follow_up_ICB_timeseries.R"))
source(here("R","op_spec_acute_follow_up_REGION_timeseries.R"))
#Plot time series
source(here("R","op_spec_acute_followup_Plot_timeseries.R"))
source(here("R","op_spec_acute_followup_Plot_timeseries_REGION.R"))

## functions for OP follow-up rations
source(here("R","op_spec_acute_1st_followup_ratios_ORG_timeseries.R"))
source(here("R","op_spec_acute_1st_followup_ratios_ICB_timeseries.R"))
source(here("R","op_spec_acute_1st_followup_ratios_REGION_timeseries.R"))
#Plot time series
source(here("R","op_spec_acute_followup_ratios_Plot_timeseries.R"))

################################################################
### Remote and virtual consultation Functions ###############
###############################################################
source(here("R","fun_op_remote_virtual_ORG_timeseries.R"))
source(here("R","fun_op_remote_virtual_ICB_timeseries.R"))
source(here("R","fun_op_remote_virtual_REGION_timeseries.R"))
#Plot time series
source(here("R","fun_op_remote_virtual_plot_timeseries.R"))

################################################################
### DC and OP Functions ###############
###############################################################
source(here("R","fun_dc_and_op_ORG_timeseries.R"))
#Plot time series
source(here("R","fun_dc_and_op_plot_timeseries.R"))
## funcs for DC and OP table
source(here("R","fun_dc_and_op_ORG_table.R"))
#format table
source(here("R","fun_fmt_ip_dc_and_op.R"))
## func for EBI procedure table
source(here("R","fun_ebi_procedure_ORG.R"))
#format table
source(here("R","fun_fmt_ebi_procedure.R"))

################################################################
### theater cancellation Functions ###############
###############################################################
# for time series
source(here("R","fun_theatre_cancellation_ORG_timeseries.R"))
# plot time series
source(here("R","fun_theatre_cancellation_Plot_timeseries.R"))

#for table
source(here("R","fun_theatre_cancellation_ORG_tab.R"))
#format table
source(here("R","fun_fmt_theatre_cancellation_tab.R"))

## theatre utilisation functions

# for time series
source(here("R","fun_theatre_utilisation_ORG_timeseries.R"))
# plot time series
source(here("R","fun_theatre_utilisation_Plot_timeseries.R"))

## theatre avg cases
# for time series
source(here("R","fun_theatre_avgcases_ORG_timeseries.R"))
# plot time series
source(here("R","fun_theatre_avgcases_Plot_timeseries.R"))




