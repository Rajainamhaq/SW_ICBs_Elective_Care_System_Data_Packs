
WITH cte_RTT AS (

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'RTT Performance'
,Measure_Type = Dimension_1
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW waiting list'
AND Data_Source = 'RTT monthly'
AND Dimension_2 = '0-18 weeks'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'RTT Performance'
,Measure_Type = Dimension_1
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW waiting list'
AND Data_Source = 'RTT monthly'


UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '52+ week %'
,Measure_Type = Dimension_1
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW waiting list'
AND Data_Source = 'RTT monthly'
AND Dimension_2 IN ('52-65 weeks','65-78 weeks','78-104 weeks','104+ weeks')


UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '52+ week %'
,Measure_Type = Dimension_1
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW waiting list'
AND Data_Source = 'RTT monthly'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Clock Starts'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Count'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW clock starts'
AND Data_Source = 'RTT monthly'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Clock Stops'
,Measure_Type = Dimension_1
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Count'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW clock stops'
AND Data_Source = 'RTT monthly'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'RTT waiting list'
,Measure_Type = Dimension_1
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Count'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.RTT_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW waiting list'
AND Data_Source = 'RTT monthly'

),

cte_Diagnostics AS (

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '6+ week %'
,Measure_Type = NULL
,TFC_or_Diagmodality = Diagnostic_Modality_ID
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Diagnostics_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW DM01 waiting list'
AND Data_Source = 'DM01'
AND Dimension_1 IN ('6-13 weeks', '13+ weeks')
AND Dimension_3 = 'Planning modality'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '6+ week %'
,Measure_Type = NULL
,TFC_or_Diagmodality = Diagnostic_Modality_ID
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Diagnostics_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW DM01 waiting list'
AND Data_Source = 'DM01'
AND Dimension_3 = 'Planning modality'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Diagnostic activity'
,Measure_Type = CASE 
	WHEN Dimension_1 = 'Planned_Tests_And_Procedures' THEN 'Planned'
	WHEN Dimension_1 = 'Unscheduled_Tests_And_Procedures' THEN 'Unscheduled'
	WHEN Dimension_1 = 'WL_Tests_And_Procedures_Excl_Planned' THEN 'Waiting list' 
	ELSE 'Check' END
,TFC_or_Diagmodality = Diagnostic_Modality_ID
,Metric_Type = 'Count'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Diagnostics_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'SW DM01 activity'
AND Dimension_3 = 'Planning modality'

),

cte_Cancer AS (

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure
,Measure_Type = NULL
,TFC_or_Diagmodality = Dimension_3
,Metric_Type = Dimension_1
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Cancer_misc_Test]
WHERE Organisation_Type = 'Provider'
AND Data_Source = 'Cancer Waiting Times'
AND Measure = 'SW CWT 28d FDS'
AND Dimension_1 = 'Numerator'


UNION ALL


SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure
,Measure_Type = NULL
,TFC_or_Diagmodality = Dimension_3
,Metric_Type = Dimension_1
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Cancer_misc_TEST]
WHERE Organisation_Type = 'Provider'
AND Data_Source = 'Cancer Waiting Times'
AND Measure = 'SW CWT 28d FDS'
AND Dimension_1 = 'Denominator'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'SW CWT 31d Combined by Tumour Site'
,Measure_Type = NULL
,TFC_or_Diagmodality = Dimension_3
,Metric_Type = Dimension_1
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Cancer_misc_TEST]
WHERE Organisation_Type = 'Provider'
AND Data_Source = 'Cancer Waiting Times'
AND Measure = 'SW CWT 31d Combined'
AND Dimension_1 = 'Numerator'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'SW CWT 31d Combined by Tumour Site'
,Measure_Type = NULL
,TFC_or_Diagmodality = Dimension_3
,Metric_Type = Dimension_1
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Cancer_misc_TEST]
WHERE Organisation_Type = 'Provider'
AND Data_Source = 'Cancer Waiting Times'
AND Measure = 'SW CWT 31d Combined'
AND Dimension_1 = 'Denominator'


UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'SW CWT 62d Combined by Tumour Site'
,Measure_Type = NULL
,TFC_or_Diagmodality = Dimension_3
,Metric_Type = Dimension_1
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Cancer_misc_TEST]
WHERE Organisation_Type = 'Provider'
AND Data_Source = 'Cancer Waiting Times'
AND Measure = 'SW CWT 62d Combined'
AND Dimension_1 = 'Numerator'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'SW CWT 62d Combined by Tumour Site'
,Measure_Type = NULL
,TFC_or_Diagmodality = Dimension_3
,Metric_Type = Dimension_1
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Cancer_misc_TEST]
WHERE Organisation_Type = 'Provider'
AND Data_Source = 'Cancer Waiting Times'
AND Measure = 'SW CWT 62d Combined'
AND Dimension_1 = 'Denominator'

),


cte_Outpatients AS (

/* DNA */
SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Missed appointments'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Total outpatient appointments'
AND Dimension_1 = 'DNA'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Missed appointments'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Total outpatient appointments'
AND Dimension_1 IN ('DNA','Attend')

UNION ALL

/* PIFU */
SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'PIFU utilisation'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Number of episodes moved or discharged to PIFU'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'PIFU utilisation'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Total outpatient appointments'
AND Dimension_1 = 'Attend'

UNION ALL

/* Spec Advice utilisation - all */
SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'System EROC'
,Measure = 'Spec Advice utilisation'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Processed requests for all types of specialist advice'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'SUS OPA for Spec Advice'
,Measure = 'Spec Advice utilisation'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Outpatient first attendances in specialist advice'

UNION ALL

/* Spec Advice utilisation - pre referral */
SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'System EROC'
,Measure = 'Spec Advice utilisation - pre referral'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Processed requests for pre referral specialist advice'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'SUS OPA for Spec Advice'
,Measure = 'Spec Advice utilisation - pre referral'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Outpatient first attendances in pre referral specialist advice'

UNION ALL

/* Spec Advice diversion - all */
SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'System EROC'
,Measure = 'Spec Advice diversion'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Diverted requests for all types of specialist advice'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'System EROC'
,Measure = 'Spec Advice diversion'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Total requests for all types of specialist advice'

UNION ALL

/* Spec Advice diversion - pre-referral */
SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'System EROC'
,Measure = 'Spec Advice diversion - pre referral'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Numerator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Diverted requests for pre referral specialist advice'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'System EROC'
,Measure = 'Spec Advice diversion - pre referral'
,Measure_Type = NULL
,TFC_or_Diagmodality = Treatment_Function_Code
,Metric_Type = 'Denominator'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Outpatient_misc]
WHERE Organisation_Type = 'Provider'
AND Measure = 'Total requests for pre referral specialist advice'


),

cte_JAR_raw AS (

SELECT * 
FROM SWPat.[TABLE.JAR_Activity_Data_P]
WHERE Provider_Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5')
AND Activity_Type IN ('JB: Day Case (Unaj.)','JA: Day Case (Adj.)','KB: Elec. Ord. (Unaj.)','KA: Elec. Ord. (Adj.)',
					  'GA: 1st OP (Adj. XDI)','GB: 1st OP (Unadj. XDI)','HA: FU OP (Adj. XDI)','HB: FU OP (Unadj. XDI)')
AND Date_uploaded = (SELECT MAX(Date_uploaded) FROM SWPat.[TABLE.JAR_Activity_Data_P])

UNION ALL

SELECT * 
FROM SWPat.[TABLE.JAR_Activity_Data_C]
WHERE Commissioner_Code IN ('11J','11M','11N','11X','15C','15N','92G')
AND Activity_Type IN ('JB: Day Case (Unaj.)','JA: Day Case (Adj.)','KB: Elec. Ord. (Unaj.)','KA: Elec. Ord. (Adj.)',
					  'GA: 1st OP (Adj. XDI)','GB: 1st OP (Unadj. XDI)','HA: FU OP (Adj. XDI)','HB: FU OP (Unadj. XDI)')
AND Date_uploaded = (SELECT MAX(Date_uploaded) FROM SWPat.[TABLE.JAR_Activity_Data_P])



),

cte_JAR_extracted AS (

SELECT 

Reporting_Period = '2024-04-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M04]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-05-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M05]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-06-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M06]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-07-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M07]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-08-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M08]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-09-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M09]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-10-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M10]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-11-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M11]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2024-12-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2024.M12]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-01-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M01]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-02-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M02]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-03-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M03]

FROM cte_JAR_raw

UNION ALL 

/*  25/26 data */


SELECT 

Reporting_Period = '2025-04-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M04]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-05-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M05]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-06-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M06]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-07-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M07]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-08-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M08]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-09-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M09]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-10-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M10]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-11-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M11]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2025-12-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2025.M12]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2026-01-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2026.M01]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2026-02-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2026.M02]

FROM cte_JAR_raw

UNION ALL

SELECT 

Reporting_Period = '2026-03-01'
,Provider_Code, Commissioner_Type, Activity_Type, Date_uploaded
,Metric_Value = [Y2026.M03]

FROM cte_JAR_raw

),

cte_JAR AS (

SELECT

Reporting_Period
,Organisation_Code = Provider_Code
,Data_Source = 'JAR'
,Measure = Activity_Type
,Measure_Type = NULL
,TFC_or_Diagmodality = NULL
,Metric_Type = 'Count'
,Metric_Value

,Date_uploaded

FROM cte_JAR_extracted

),

cte_Plans AS (

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'Plans'
,Measure = CASE 
/*  RTT */
	WHEN Measure = 'RTT waiting list' THEN '52+ week %'
	WHEN Measure = 'Number of 52+ week RTT waits' THEN '52+ week %'
/* Diagnostics */
	WHEN Measure = 'SW planning diagnostics activity' THEN 'Diagnostic activity'
/* Outpatients */	
	WHEN Measure = 'Number of episodes moved or discharged to patient initiated outpatient follow-up pathway as an outcome of their attendance' THEN 'PIFU utilisation'
	WHEN Measure = 'Total outpatient attendances (all TFC; consultant and non consultant led)' THEN 'PIFU utilisation'
	ELSE 'Check' END

,Measure_Type = NULL

,TFC_or_Diagmodality = CASE 

	WHEN Dimension_1 = 'Diagnostic Tests - Magnetic Resonance Imaging' THEN '1'
	WHEN Dimension_1 = 'Diagnostic Tests - Computed Tomography' THEN '2'
	WHEN Dimension_1 = 'Diagnostic Tests - Non-Obstetric Ultrasound' THEN '3'
	WHEN Dimension_1 = 'Diagnostic Tests - DEXA Scan' THEN '5'
	WHEN Dimension_1 = 'Diagnostics Tests - Audiology' THEN '6'
	WHEN Dimension_1 = 'Diagnostic Tests - Cardiology - Echocardiography' THEN '7'
	WHEN Dimension_1 = 'Diagnostic Tests - Colonoscopy' THEN '12'
	WHEN Dimension_1 = 'Diagnostic Tests - Flexi Sigmoidoscopy' THEN '13'
	WHEN Dimension_1 = 'Diagnostic Tests - Gastroscopy' THEN '15'
	ELSE NULL END

,Metric_Type = CASE
	WHEN Measure IN ('Number of 52+ week RTT waits',
					'Number of episodes moved or discharged to patient initiated outpatient follow-up pathway as an outcome of their attendance') THEN 'Numerator'
	WHEN Measure IN ('RTT waiting list','Total outpatient attendances (all TFC; consultant and non consultant led)') THEN 'Denominator'
	WHEN Measure IN ('SW planning diagnostics activity') THEN 'Count'
	ELSE 'Check' END

,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Planning_misc]

WHERE Organisation_Type = 'Provider'

AND Plan_Submission_Date = 'Jun-24'

AND Measure IN ('RTT waiting list',
				'Number of 52+ week RTT waits',
				'SW planning diagnostics activity',
				'Total outpatient attendances (all TFC; consultant and non consultant led)',
				'Number of episodes moved or discharged to patient initiated outpatient follow-up pathway as an outcome of their attendance')


UNION ALL


SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'Plans'
,Measure = CASE 
/*  RTT */
	WHEN Measure = 'Number of 0-18 week RTT waits' THEN 'RTT Performance'
	WHEN Measure = 'RTT waiting list' THEN 'RTT Performance'
	WHEN Measure = 'Number of 0-18 week RTT waits for first attendance' THEN 'Wait to first'
	WHEN Measure = 'RTT waiting list for first attendance' THEN 'Wait to first'
	WHEN Measure = 'Number of 52+ week RTT waits' THEN '52+ week %'
	WHEN Measure = 'New RTT pathways (clock starts)' THEN 'Clock Starts'
	WHEN Measure IN ('RTT completed non-admitted pathways','RTT completed admitted pathways') THEN 'Clock Stops'
/* Diagnostics */
	WHEN Measure = 'SW planning diagnostics activity' THEN 'Diagnostic activity'
/* Cancer */
	WHEN Measure = 'SW planning 28d FDS' THEN 'SW CWT 28d FDS'
	WHEN Measure = 'SW planning 31d Combined' THEN 'SW CWT 31d Combined by Tumour Site'
	WHEN Measure = 'SW planning 62d Combined' THEN 'SW CWT 62d Combined by Tumour Site'
/* Outpatients */	
	WHEN Measure = 'Number of episodes moved or discharged to patient initiated outpatient follow-up pathway as an outcome of their attendance' THEN 'PIFU utilisation'
	WHEN Measure = 'Total outpatient attendances (all TFC; consultant and non consultant led)' THEN 'PIFU utilisation'
/* Specific acute activity */
	WHEN Measure = 'Elective day case spells' THEN 'JB: Day Case (Unaj.)'	
	WHEN Measure = 'Elective ordinary spells' THEN 'KB: Elec. Ord. (Unaj.)'
	WHEN Measure = 'Consultant-led first outpatient attendances (Spec acute)' THEN 'GB: 1st OP (Unadj. XDI)'
	WHEN Measure = 'Consultant-led follow-up outpatient attendances (Spec acute)' THEN 'HB: FU OP (Unadj. XDI)'
	ELSE 'Check' END

,Measure_Type = CASE
	WHEN Dimension_1 = 'RTT completed admitted pathways' THEN 'Admitted'
	WHEN Dimension_1 = 'RTT completed non-admitted pathways' THEN 'Non-admitted'
	ELSE NULL END

,TFC_or_Diagmodality = CASE 

	WHEN Dimension_1 = 'Diagnostic Tests - Magnetic Resonance Imaging' THEN '1'
	WHEN Dimension_1 = 'Diagnostic Tests - Computed Tomography' THEN '2'
	WHEN Dimension_1 = 'Diagnostic Tests - Non-Obstetric Ultrasound' THEN '3'
	WHEN Dimension_1 = 'Diagnostic Tests - DEXA Scan' THEN '5'
	WHEN Dimension_1 = 'Diagnostics Tests - Audiology' THEN '6'
	WHEN Dimension_1 = 'Diagnostic Tests - Cardiology - Echocardiography' THEN '7'
	WHEN Dimension_1 = 'Diagnostic Tests - Colonoscopy' THEN '12'
	WHEN Dimension_1 = 'Diagnostic Tests - Flexi Sigmoidoscopy' THEN '13'
	WHEN Dimension_1 = 'Diagnostic Tests - Gastroscopy' THEN '15'
	ELSE NULL END

,Metric_Type = CASE
	WHEN Measure IN ('Number of 0-18 week RTT waits','Number of 0-18 week RTT waits for first attendance','Number of 52+ week RTT waits',
					'Number of episodes moved or discharged to patient initiated outpatient follow-up pathway as an outcome of their attendance') THEN 'Numerator'
	WHEN Measure IN ('RTT waiting list','RTT waiting list for first attendance','Total outpatient attendances (all TFC; consultant and non consultant led)') THEN 'Denominator'
	WHEN Measure IN ('New RTT pathways (clock starts)', 'RTT completed non-admitted pathways', 'RTT completed admitted pathways',
					'SW planning diagnostics activity',
					'Elective day case spells','Elective ordinary spells',
					'Consultant-led first outpatient attendances (Spec acute)','Consultant-led follow-up outpatient attendances (Spec acute)') THEN 'Count'
	WHEN Measure IN ('SW planning 28d FDS', 'SW planning 31d Combined', 'SW planning 62d Combined') THEN Dimension_3
	
	ELSE 'Check' END

,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Planning_misc]

WHERE Organisation_Type = 'Provider'

AND Plan_Submission_Date = 'May-25'

AND Measure IN ('Consultant-led first outpatient attendances (Spec acute)',
				'Consultant-led follow-up outpatient attendances (Spec acute)',
				'Elective day case spells',
				'Elective ordinary spells',
				'New RTT pathways (clock starts)',
				'Number of 0-18 week RTT waits',
				'Number of 0-18 week RTT waits for first attendance',
				'Number of 52+ week RTT waits',
				'Number of episodes moved or discharged to patient initiated outpatient follow-up pathway as an outcome of their attendance',
				'RTT completed admitted pathways',
				'RTT completed non-admitted pathways',
				'RTT waiting list',
				'RTT waiting list for first attendance',
				'SW planning diagnostics activity',
				'Total outpatient attendances (all TFC; consultant and non consultant led)',
				'SW planning 28d FDS',
				'SW planning 31d Combined',
				'SW planning 62d Combined')

AND Dimension_3 <> 'Percentage'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'Plans'
,Measure = CASE 
/*  RTT */
	WHEN Measure = 'RTT waiting list' THEN '52+ week %'
/* Specific acute activity */
	WHEN Measure = 'Elective day case spells' THEN 'JA: Day Case (Adj.)'	
	WHEN Measure = 'Elective ordinary spells' THEN 'KA: Elec. Ord. (Adj.)'
	WHEN Measure = 'Consultant-led first outpatient attendances (Spec acute)' THEN 'GA: 1st OP (Adj. XDI)'
	WHEN Measure = 'Consultant-led follow-up outpatient attendances (Spec acute)' THEN 'HA: FU OP (Adj. XDI)'
	ELSE 'Check' END

,Measure_Type = NULL 
,TFC_or_Diagmodality = NULL 
,Metric_Type = CASE
	WHEN Measure = 'RTT waiting list' THEN 'Denominator'
	WHEN Measure IN ('Elective day case spells','Elective ordinary spells',
					  'Consultant-led first outpatient attendances (Spec acute)','Consultant-led follow-up outpatient attendances (Spec acute)') THEN 'Count'
	ELSE 'Check' END

,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Planning_misc]

WHERE Organisation_Type = 'Provider'

AND Plan_Submission_Date = 'May-25'

AND Measure IN ('Consultant-led first outpatient attendances (Spec acute)',
				'Consultant-led follow-up outpatient attendances (Spec acute)',
				'Elective day case spells',
				'Elective ordinary spells',
				'RTT waiting list')


UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source = 'Plans'
,Measure = 'RTT waiting list' 
,Measure_Type = NULL 
,TFC_or_Diagmodality = NULL 
,Metric_Type = 'Count'
,Metric_Value

,Date_uploaded

FROM SWPat.[TABLE.Planning_misc]

WHERE Organisation_Type = 'Provider'

AND Plan_Submission_Date = 'May-25'

AND Measure = 'RTT waiting list'

),

cte_misc_tables AS (

SELECT * FROM cte_RTT

UNION ALL

SELECT * FROM cte_Diagnostics

UNION ALL

SELECT * FROM cte_Cancer

UNION ALL

SELECT * FROM cte_Outpatients

UNION ALL

SELECT * FROM cte_JAR

UNION ALL

SELECT * FROM cte_Plans

),

cte_max_dates AS (

SELECT Measure, Reporting_Period = MAX(Reporting_Period)

FROM cte_misc_tables

WHERE Data_Source <> 'Plans'

GROUP BY Measure

)

SELECT 

a.Reporting_Period
,Organisation_Code
,Data_Source
,a.Measure
,Measure_Type
,TFC_or_Diagmodality = CASE 
	WHEN a.Measure IN ('RTT waiting list','Clock starts','Clock Stops') THEN TFC_or_Diagmodality
	WHEN a.Measure = 'Diagnostic activity' AND a.Data_Source = 'Plans' THEN TFC_or_Diagmodality
	WHEN b.Reporting_Period IS NULL THEN NULL 
	ELSE TFC_or_Diagmodality END
,Metric_Type
,Metric_Value = SUM(Metric_Value)

,Date_uploaded

FROM cte_misc_tables a

LEFT JOIN cte_max_dates b

ON a.Measure = b.Measure
AND a.Reporting_Period = b.Reporting_Period

WHERE a.Reporting_Period >= '2023-04-01'

AND Organisation_Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5')

GROUP BY 

a.Reporting_Period
,Organisation_Code
,Data_Source
,a.Measure
,Measure_Type
,CASE 
	WHEN a.Measure IN ('RTT waiting list','Clock starts','Clock Stops') THEN TFC_or_Diagmodality
	WHEN a.Measure = 'Diagnostic activity' AND a.Data_Source = 'Plans' THEN TFC_or_Diagmodality
	WHEN b.Reporting_Period IS NULL THEN NULL 
	ELSE TFC_or_Diagmodality END
,Metric_Type
,Date_uploaded