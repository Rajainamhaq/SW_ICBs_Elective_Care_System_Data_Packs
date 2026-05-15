
WITH cte_WLMDS_RTT AS (

SELECT 

Reporting_Period = derWeekEnding
,Data_Source = 'WLMDS RTT'
,Organisation_Code = CASE 
	WHEN ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT IN ('P1B7M', 'M5E1S', 'A0C5S', 'L6O7H','NT202', 'NT206', 'NT211', 'NT215', 'NT233', 'NT238') THEN ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT
	WHEN Organisation_Identifier_Code_Of_Provider LIKE 'RBZ%' THEN 'RH8'
	WHEN Organisation_Identifier_Code_Of_Provider LIKE 'RA4%' THEN 'RH5'
	WHEN Organisation_Identifier_Code_Of_Provider LIKE 'R%' THEN LEFT(Organisation_Identifier_Code_Of_Provider,3) 
	WHEN ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER = 'NFH' THEN ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER
	WHEN LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) = 'AXG' THEN 'AXG'
	WHEN LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) = 'NR5' THEN 'NR5'
	WHEN LEN(ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT) > 3 THEN ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT
	ELSE Organisation_Identifier_Code_Of_Provider END

,Measure_Type = CASE WHEN Waiting_List_Type = 'IRTT' THEN 'Admitted' ELSE 'Non-admitted' END
,POD = CASE

	WHEN REFERRAL_TO_TREATMENT_PERIOD_START_DATE IS NULL THEN 'Invalid RTT Start Date'
	WHEN REFERRAL_TO_TREATMENT_PERIOD_START_DATE = '1900-01-01' THEN 'Invalid RTT Start Date'
	WHEN REFERRAL_TO_TREATMENT_PERIOD_START_DATE > derWeekEnding THEN 'Invalid RTT Start Date'
	WHEN (Waiting_List_Type = 'IRTT' AND INTENDED_MANAGEMENT_CODE IN ('2','4')) THEN 'Day Case'
	WHEN (Waiting_List_Type = 'IRTT' AND INTENDED_MANAGEMENT_CODE IN ('1','3','5')) THEN 'Ordinary'
	WHEN Waiting_List_Type = 'IRTT' THEN 'Other admitted'
	WHEN FIRST_ACTIVITY_DATE IS NULL THEN '1st OP'
	WHEN FIRST_ACTIVITY_DATE < REFERRAL_TO_TREATMENT_PERIOD_START_DATE THEN '1st OP'
	WHEN FIRST_ACTIVITY_DATE > derWeekEnding THEN '1st OP'
	ELSE 'FU OP' END

,TFC_or_Diagmodality = CASE 
	WHEN derWeekEnding < (SELECT MAX(derWeekEnding) FROM Reporting_MESH_WLMDS.Open_ASI_Combined) THEN 'All'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('320','330','120','301','300','100','430','502','400','150','130','160','410','340','101') THEN ACTIVITY_TREATMENT_FUNCTION_CODE
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('170','172','173') THEN '170'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('140','144','145') THEN '140'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('108','110','111','115') THEN '110'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('180','190','191','192','200','302','303','304','305','306','307','308','309','310','311','313','314','315','316','317','318','319',
'322','323','324','325','326','327','328','329','331','333','335','341','342','343','344','345','346','347','348','350','352','360','361','370','371','401','420','422','424',
    '431','450','451','460','461','501','503','504','505','834') THEN 'Other - Medical Services'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('656','700','710','711','712','713','715','720','721','722','723','724','725','726','727','730') THEN 'Other - Mental Health Services'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('560','650','651','652','653','654','655','657','658','659','660','661','662','663','670','673','675','677','800',
    '811','812','822','840','920') THEN 'Other - Other Services'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('142','171','211','212','213','214','215','216','217','218','219','220','221','222','223','230','240','241','242','250','251','252',
'253','254','255','256','257','258','259','260','261','262','263','264','270','280','290','291','321','421') THEN 'Other - Paediatric Services'
    WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('102','103','104','105','106','107','109','113','141','143','161','174') THEN 'Other - Surgical Services'
    ELSE 'Other' END
 
,Validation_flag = CASE 
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 < 12 THEN 'Out of scope'  --pathways waiting < 12 weeks are excluded
	WHEN Date_Last_Attended BETWEEN DATEADD(WEEK,-12,derWeekEnding) AND derWeekEnding THEN 'Out of scope'					--pathways with a recent activity (in last 12 weeks) are excluded
	WHEN DECISION_TO_ADMIT_DATE BETWEEN DATEADD(WEEK,-12,derWeekEnding) AND derWeekEnding THEN 'Out of scope'				--pathways with a recent activity (in last 12 weeks) are excluded
	WHEN TCI_Date BETWEEN derWeekEnding AND DATEADD(WEEK,4,derWeekEnding) THEN 'Out of scope'								--pathways with a future activity (in next 4 weeks) are excluded
	WHEN Outpatient_Future_Appointment_Date BETWEEN derWeekEnding AND DATEADD(WEEK,4,derWeekEnding) THEN 'Out of scope'		--pathways with a future activity (in next 4 weeks) are excluded
	WHEN Last_Pas_Validation_Date IS NULL THEN 'Not validated'																--No PAS validation date
	WHEN Last_Pas_Validation_Date = '1900-01-01' THEN 'PAS Validation DQ'													--Invalid PAS validation date
	WHEN Last_Pas_Validation_Date > derWeekEnding THEN 'PAS Validation DQ'													--Invalid PAS validation date
	WHEN DATEDIFF(DAY,Last_PAS_Validation_Date,[derWeekEnding]) / 7.00 < 12 THEN 'Validated'								--Validated within last 12 weeks
	WHEN DATEDIFF(DAY,Last_PAS_Validation_Date,[derWeekEnding]) / 7.00 >= 12 THEN 'Not validated'							--Not validated within last 12 weeks
	ELSE 'Unknown' END
 
,Weeks_waiting_band = CASE 
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 104 THEN '104+ weeks'
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 78 THEN '78-104 weeks'
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 65 THEN '65-78 weeks'
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 52 THEN '52-65 weeks'
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 40 THEN '40-52 weeks'
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 18 THEN '18-40 weeks'
	WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 >= 0 THEN '0-18 weeks'
	ELSE 'Unknown weeks' END

,App_before_deadline = CASE 
	WHEN (Outpatient_Future_Appointment_Date IS NULL OR Outpatient_Future_Appointment_Date <= derWeekEnding) AND (TCI_Date IS NULL OR TCI_Date <= derWeekEnding) THEN 'No date'
	WHEN Outpatient_Future_Appointment_Date BETWEEN derWeekEnding AND '2025-03-31' THEN 'Dated in Mar-25'
	WHEN TCI_Date BETWEEN derWeekEnding AND '2025-03-31' THEN 'Dated in Mar-25'
	WHEN Outpatient_Future_Appointment_Date BETWEEN derWeekEnding AND '2025-04-30' THEN 'Dated in Apr-25'
	WHEN TCI_Date BETWEEN derWeekEnding AND '2025-04-30' THEN 'Dated in Apr-25'
	WHEN Outpatient_Future_Appointment_Date BETWEEN derWeekEnding AND '2025-05-31' THEN 'Dated in May-25'
	WHEN TCI_Date BETWEEN derWeekEnding AND '2025-05-31' THEN 'Dated in May-25'
	WHEN Outpatient_Future_Appointment_Date BETWEEN derWeekEnding AND '2025-06-30' THEN 'Dated in Jun-25'
	WHEN TCI_Date BETWEEN derWeekEnding AND '2025-06-30' THEN 'Dated in Jun-25'
	ELSE 'Dated after Jun-25' END

,Weeks_12plus = CASE WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 12 THEN 1 ELSE 0 END
,Weeks_52plus = CASE WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 52 THEN 1 ELSE 0 END
,Weeks_65plus = CASE WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, derWeekEnding) AS DECIMAL)/7 > 65 THEN 1 ELSE 0 END
,Cohort_65 = CASE WHEN CAST(DATEDIFF(DAY, Referral_To_Treatment_Period_Start_Date, '2025-06-30') AS DECIMAL)/7 > 65 THEN 1 ELSE 0 END
,Metric_Value = 1

FROM Reporting_MESH_WLMDS.Open_ASI_Combined 

WHERE 

(derWeekEnding IN 
	('2024-04-28','2024-06-02','2024-06-30','2024-08-04','2024-09-01','2024-09-29',
	'2024-11-03','2024-12-01','2024-12-29','2025-02-02','2025-03-02','2025-03-30',
	'2025-05-04','2025-06-01','2025-06-29','2025-08-03','2025-08-31','2025-09-28',
	'2025-11-02','2025-11-30','2026-01-04','2026-02-01','2026-03-01','2026-03-29'
	,'2026-05-03', '2026-05-31','2026-06-28','2026-08-02','2026-08-30','2026-09-04',
	'2026-11-01','2026-11-29','2027-01-03','2027-01-31','2027-02-28','2027-03-28'
	)

OR derWeekEnding = (SELECT MAX(derWeekEnding) FROM Reporting_MESH_WLMDS.Open_ASI_Combined))

AND Waiting_List_Type IN ('ORTT','IRTT')

AND Der_Reporting_Region_Name = 'South West'

AND Der_Reporting_Org_Subtype = 'NHS_ACUTE'

AND Der_NONC_Code <> '4'

),

cte_WLMDS_pre_Starts AS (

SELECT 

Reporting_Period = DATEFROMPARTS(YEAR(REFERRAL_TO_TREATMENT_PERIOD_START_DATE),MONTH(REFERRAL_TO_TREATMENT_PERIOD_START_DATE),1)
,Organisation_Code = LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) 
,Source_of_referral = CASE WHEN LEN(Source_of_referral) = 1 THEN CONCAT (0,Source_of_referral) ELSE Source_of_referral END

,TFC_or_Diagmodality = CASE 
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('320','330','120','301','300','100','430','502','400','150','130','160','410','340','101') THEN ACTIVITY_TREATMENT_FUNCTION_CODE
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('170','172','173') THEN '170'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('140','144','145') THEN '140'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('108','110','111','115') THEN '110'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('180','190','191','192','200','302','303','304','305','306','307','308','309','310','311','313','314','315','316','317','318','319',
	'322','323','324','325','326','327','328','329','331','333','335','341','342','343','344','345','346','347','348','350','352','360','361','370','371','401','420','422','424',
	'431','450','451','460','461','501','503','504','505','834') THEN 'Other - Medical Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('656','700','710','711','712','713','715','720','721','722','723','724','725','726','727','730') THEN 'Other - Mental Health Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('560','650','651','652','653','654','655','657','658','659','660','661','662','663','670','673','675','677','800',
	'811','812','822','840','920') THEN 'Other - Other Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('142','171','211','212','213','214','215','216','217','218','219','220','221','222','223','230','240','241','242','250','251','252',
	'253','254','255','256','257','258','259','260','261','262','263','264','270','280','290','291','321','421') THEN 'Other - Paediatric Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('102','103','104','105','106','107','109','113','141','143','161','174') THEN 'Other - Surgical Services'
	ELSE 'Other' END
 
,Metric_Value = 1


FROM Reporting_MESH_WLMDS.ClockStarts 

WHERE LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) IN ('R0D','RA3','RA4','RA7','RA9','RBA','RBD','RBZ','RD1','RD3','RDZ','REF','RH5','RH8','RK9','RN3','RNZ','RTE','RVJ')
AND REFERRAL_TO_TREATMENT_PERIOD_START_DATE <= (SELECT TOP 1 derWeekEnding FROM Reporting_MESH_WLMDS.ClockStarts ORDER BY derWeekEnding DESC)
AND REFERRAL_TO_TREATMENT_PERIOD_START_DATE >= '2021-05-24'
AND Der_NONC_Code <> '4'

),

cte_Starts AS (

SELECT

Reporting_Period
,Organisation_Code
,Data_Source = 'WLMDS Starts'
,Measure = 'Clock Starts'
,Measure_Type = CASE 
	WHEN Main_Description IS NULL THEN 'Invalid code'
	ELSE Main_Description END 
,TFC_or_Diagmodality
,Metric_Type = 'Count'
,Metric_Value

FROM cte_WLMDS_pre_Starts a

LEFT JOIN UKHD_Data_Dictionary.Source_Of_Referral_For_Out_Patients_SCD b
ON a.Source_of_referral = b.Main_Code_Text
AND Is_Latest = 1


),

cte_Stops AS (

SELECT

Reporting_Period = DATEFROMPARTS(YEAR(REFERRAL_TO_TREATMENT_PERIOD_END_DATE),MONTH(REFERRAL_TO_TREATMENT_PERIOD_END_DATE),1)
,Organisation_Code = LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) 
,Data_Source = 'WLMDS Stops'
,Measure = 'Clock Stops'
,Measure_Type = Waiting_List_Type
,TFC_or_Diagmodality = CASE 
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('320','330','120','301','300','100','430','502','400','150','130','160','410','340','101') THEN ACTIVITY_TREATMENT_FUNCTION_CODE
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('170','172','173') THEN '170'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('140','144','145') THEN '140'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('108','110','111','115') THEN '110'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('180','190','191','192','200','302','303','304','305','306','307','308','309','310','311','313','314','315','316','317','318','319',
	'322','323','324','325','326','327','328','329','331','333','335','341','342','343','344','345','346','347','348','350','352','360','361','370','371','401','420','422','424',
	'431','450','451','460','461','501','503','504','505','834') THEN 'Other - Medical Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('656','700','710','711','712','713','715','720','721','722','723','724','725','726','727','730') THEN 'Other - Mental Health Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('560','650','651','652','653','654','655','657','658','659','660','661','662','663','670','673','675','677','800',
	'811','812','822','840','920') THEN 'Other - Other Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('142','171','211','212','213','214','215','216','217','218','219','220','221','222','223','230','240','241','242','250','251','252',
	'253','254','255','256','257','258','259','260','261','262','263','264','270','280','290','291','321','421') THEN 'Other - Paediatric Services'
	WHEN ACTIVITY_TREATMENT_FUNCTION_CODE IN ('102','103','104','105','106','107','109','113','141','143','161','174') THEN 'Other - Surgical Services'
	ELSE 'Other' END
,Metric_Type = 'Count'
,Metric_Value = 1

FROM Reporting_MESH_WLMDS.ClockStops a

WHERE Waiting_List_Type in ('IRTT', 'ORTT')
AND (REFERRAL_TO_TREATMENT_PERIOD_END_DATE >= '2021-05-24' OR REFERRAL_TO_TREATMENT_PERIOD_END_DATE IS NULL)
AND LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) IN ('R0D','RA3','RA4','RA7','RA9','RBA','RBD','RBZ','RD1','RD3','RDZ','REF','RH5','RH8','RK9','RN3','RNZ','RTE','RVJ')
AND Der_NONC_Code <> '4'


),

cte_WLMDS_Diagnostics AS (

SELECT 

Reporting_Period = derWeekEnding
,Data_Source = 'WLMDS Diagnostics'
,Organisation_Code = CASE 
	WHEN ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT IN ('P1B7M', 'M5E1S', 'A0C5S', 'L6O7H','NT202', 'NT206', 'NT211', 'NT215', 'NT233', 'NT238') THEN ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT
	WHEN Organisation_Identifier_Code_Of_Provider LIKE 'RBZ%' THEN 'RH8'
	WHEN Organisation_Identifier_Code_Of_Provider LIKE 'RA4%' THEN 'RH5'
	WHEN Organisation_Identifier_Code_Of_Provider LIKE 'R%' THEN LEFT(Organisation_Identifier_Code_Of_Provider,3) 
	WHEN ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER = 'NFH' THEN ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER
	WHEN LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) = 'AXG' THEN 'AXG'
	WHEN LEFT(ORGANISATION_IDENTIFIER_CODE_OF_PROVIDER,3) = 'NR5' THEN 'NR5'
	WHEN LEN(ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT) > 3 THEN ORGANISATION_SITE_IDENTIFIER_OF_TREATMENT
	ELSE Organisation_Identifier_Code_Of_Provider END

,TFC_or_Diagmodality = Diagnostic_Modality
 
,Weeks_waiting_band = CASE 

	WHEN Diagnostic_Clock_Start_Date IS NULL THEN 'Unknown clock start'
	WHEN Diagnostic_Clock_Start_Date = '1900-01-01' THEN 'Start date for review'
	WHEN Diagnostic_Clock_Start_Date > derWeekEnding then 'Start date for review'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 104 THEN '104+ weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 78 THEN '78-104 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 52 THEN '52-78 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 40 THEN '40-52 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 26 THEN '26-40 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 18 THEN '18-26 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 13 THEN '13-18 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 6 THEN '6-13 weeks'
	WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 >= 0 THEN '0-6 weeks'
	ELSE 'Unknown weeks' END

,Weeks_6plus = CASE WHEN FLOOR(CAST(DATEDIFF(DAY, Diagnostic_Clock_Start_Date, derWeekEnding) AS DECIMAL)/7) + 1 > 6 THEN 1 ELSE 0 END

,Metric_Value = 1

FROM Reporting_MESH_WLMDS.Diagnostics 

WHERE (derWeekEnding IN 
	('2024-04-28','2024-06-02','2024-06-30','2024-08-04','2024-09-01','2024-09-29',
	'2024-11-03','2024-12-01','2024-12-29','2025-02-02','2025-03-02','2025-03-30',
	'2025-05-04','2025-06-01','2025-06-29','2025-08-03','2025-08-31','2025-09-28',
	'2025-11-02','2025-11-30','2026-01-04','2026-02-01','2026-03-01','2026-03-29'
	,'2026-05-03', '2026-05-31','2026-06-28','2026-08-02','2026-08-30','2026-09-04',
	'2026-11-01','2026-11-29','2027-01-03','2027-01-31','2027-02-28','2027-03-28')

OR derWeekEnding = (SELECT MAX(derWeekEnding) FROM Reporting_MESH_WLMDS.Diagnostics))

AND Der_Reporting_Region_Name = 'South West'

AND Der_Reporting_Org_Subtype = 'NHS_ACUTE'

AND Waiting_List_Type <> 'PLN'

AND Der_NONC_Code <> '4'

AND Diagnostic_Modality IN ('1','2','3','5','6','7','12','13','14','15','01','02','03','05','06','07')

),

cte_RTT AS (

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'RTT Waiting List'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Count'
,Metric_Value

FROM cte_WLMDS_RTT

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'RTT Performance'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Numerator'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE Weeks_waiting_band = '0-18 weeks'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'RTT Performance'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Denominator'
,Metric_Value

FROM cte_WLMDS_RTT

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Wait to first'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Numerator'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE Weeks_waiting_band = '0-18 weeks'
AND POD = '1st OP'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = 'Wait to first'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Denominator'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE POD = '1st OP'

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '52+ week %'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Numerator'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE Weeks_52plus = 1


UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '52+ week %'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Denominator'
,Metric_Value

FROM cte_WLMDS_RTT

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '12+ week validation'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Numerator'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE Weeks_12plus = 1
AND Validation_flag = 'Validated'


UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '12+ week validation'
,Measure_Type
,TFC_or_Diagmodality
,Metric_Type = 'Denominator'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE Weeks_12plus = 1
AND Validation_flag IN ('Validated','Not validated')

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = Validation_flag
,Measure_Type = NULL
,TFC_or_Diagmodality
,Metric_Type = 'Count'
,Metric_Value

FROM cte_WLMDS_RTT
WHERE Weeks_12plus = 1


),

cte_Diagnostics AS (

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '6+ week %'
,Measure_Type = NULL
,TFC_or_Diagmodality
,Metric_Type = 'Numerator'
,Metric_Value

FROM cte_WLMDS_Diagnostics
WHERE Weeks_6plus = 1

UNION ALL

SELECT 

Reporting_Period
,Organisation_Code
,Data_Source
,Measure = '6+ week %'
,Measure_Type = NULL
,TFC_or_Diagmodality
,Metric_Type = 'Denominator'
,Metric_Value

FROM cte_WLMDS_Diagnostics


),


cte_warehouse_tables AS (

SELECT * FROM cte_RTT

UNION ALL

SELECT * FROM cte_Diagnostics

UNION ALL 

SELECT * FROM cte_Starts

UNION ALL 

SELECT * FROM cte_Stops

),

cte_max_dates AS (

SELECT Measure, Reporting_Period = MAX(Reporting_Period)

FROM cte_warehouse_tables

GROUP BY Measure

)

SELECT 

a.Reporting_Period
,Organisation_Code
,Data_Source
,a.Measure
,Measure_Type
,TFC_or_Diagmodality = CASE 
	WHEN a.Measure IN ('Clock Starts','Clock Stops') THEN TFC_or_Diagmodality
	WHEN b.Reporting_Period IS NULL THEN NULL 
	ELSE TFC_or_Diagmodality END
,Metric_Type
,Metric_Value = SUM(Metric_Value)

FROM cte_warehouse_tables a

LEFT JOIN cte_max_dates b

ON a.Measure = b.Measure
AND a.Reporting_Period = b.Reporting_Period

WHERE a.Reporting_Period >= '2024-04-01'

AND Organisation_Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5')

GROUP BY 

a.Reporting_Period
,Organisation_Code
,Data_Source
,a.Measure
,Measure_Type
,CASE 
	WHEN a.Measure IN ('Clock Starts','Clock Stops') THEN TFC_or_Diagmodality
	WHEN b.Reporting_Period IS NULL THEN NULL 
	ELSE TFC_or_Diagmodality END
,Metric_Type
