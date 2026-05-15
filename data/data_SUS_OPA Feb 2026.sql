/* Extracts the monthly SUS OPA information from SUS since Mar-24 */ 
SELECT  
Reporting_Period 
,Organisation_Code 
,Der_Contact_Type = Dimension_5 
,Metric_Value = COUNT(*) 

FROM [SWPat].[TABLE.Outpatient_misc] 

WHERE Reporting_Period >= '2024-04-01' 
AND Organisation_Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 
AND Dimension_1 = 'Attend' -- attended appointment 

GROUP BY  
Reporting_Period 
,Organisation_Code 
,Dimension_5 

 