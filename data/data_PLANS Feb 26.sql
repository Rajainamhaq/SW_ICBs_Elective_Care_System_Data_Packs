SELECT  

  

Reporting_Period = CAST(DimDateStart AS DATE) 

,DataType = 'Actuals' 

,Organisation_Code = OrgCode 

,MeasureID 

,MeasureFamily 

,MeasureSubject 

,ActivityCategory 

,MeasureName 

,MeasureType 

,MetricType 

,Metric_Value = Value 

  

FROM UDALLakeMart_PATPlanningReporting.actual_data_2526 

  

WHERE MeasureSubject IN ('Elective RTT','Cancer','Diagnostic Tests','Elective','Outpatient') 

  

AND OrgCode IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 

  

AND DimDateStart >= '2024-04-01' 

  

UNION ALL 

  

SELECT  

  

Reporting_Period = CAST(DimDateStart AS DATE) 

,DataType = 'Plans' 

,Organisation_Code = OrgCode 

,MeasureID 

,MeasureFamily 

,MeasureSubject 

,ActivityCategory 

,MeasureName 

,MeasureType 

,MetricType 

,Metric_Value = Value 

  

FROM UDALLakeMart_PATPlanningReporting.plan_data_2526 

  

WHERE MeasureSubject IN ('Elective RTT','Cancer','Diagnostic Tests','Elective','Outpatient') 

  

AND OrgCode IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 

  

AND DimDateStart >= '2025-04-01' 