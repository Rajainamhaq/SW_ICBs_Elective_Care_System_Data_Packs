/* Theatres data */  

SELECT  

Reporting_Period = MV.ReportingDate 

,Organisation_Code = P.Code 

,Data_Source = 'National Theatre Data Collection' 

,Measure = 'Capped theatre utilisation %' 

,Measure_Type = NULL 

,TFC_or_Diagmodality = 'All' 

,Metric_Type = 'Calculated %' 

,Metric_Value = MV.Value 

,Date_refreshed = CURRENT_TIMESTAMP 

FROM MeasureValue MV 

INNER JOIN Measure M ON M.ID = MV.MeasureID 

INNER JOIN Provider P ON P.ID = MV.ProviderID 

INNER JOIN ProviderType T ON T.ID = P.TypeID 

INNER JOIN MeasureDomainMapping MAP ON MAP.MeasureID = M.ID 

INNER JOIN DashboardCompartmentDomain DO ON DO.ID = MAP.DomainID 

INNER JOIN DashboardCompartment C ON C.ID = DO.CompartmentID 

INNER JOIN Dashboard D ON D.ID = C.DashboardID 

WHERE P.Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5','Y58') 

AND MV.ReportingDate >= '2024-08-26'  -- metric prior to 26-Aug-24 are calculated using an older methodology and may not be comparable 

AND M.Description = 'Capped Elective Theatre Utilisation % (monthly)' 

UNION ALL 

/* BADS day case and outpatient procedures */ 

SELECT  

Reporting_Period = MV.ReportingDate 

,Organisation_Code = P.Code 

,Data_Source = 'HES' 

,Measure = CASE  

WHEN M.Description = 'BADS All: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN 'DC and OP rates' 

ELSE 'DC and OP rates - specialty level' END 

,Measure_Type = NULL 

,TFC_or_Diagmodality = CASE  

WHEN M.Description = 'BADS All: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN 'All' 

WHEN M.Description = 'BADS Breast: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '103' 

WHEN M.Description = 'BADS Emergency surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN 'Emergency' 

WHEN M.Description = 'BADS Endocrine surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '113' 

WHEN M.Description = 'BADS ENT: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '120' 

WHEN M.Description = 'BADS General Surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '100' 

WHEN M.Description = 'BADS Gynaecology: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '502' 

WHEN M.Description = 'BADS Ophthalmology: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '130' 

WHEN M.Description = 'BADS Oral and Maxillofacial Surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '145' 

WHEN M.Description = 'BADS Orthopaedic: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '111' 

WHEN M.Description = 'BADS Paediatric: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '171' 

WHEN M.Description = 'BADS Spinal surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '115' 

WHEN M.Description = 'BADS Urology: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '101' 

WHEN M.Description = 'BADS Vascular: Day case and outpatient % of total procedures (inpatient, day case and outpatient)' THEN '107' 

ELSE 'Check' END 

,Metric_Type = 'Calculated %' 

,Metric_Value = MV.Value 

,Date_refreshed = CURRENT_TIMESTAMP 

FROM MeasureValue MV 

INNER JOIN Measure M ON M.ID = MV.MeasureID 

INNER JOIN Provider P ON P.ID = MV.ProviderID 

INNER JOIN ProviderType T ON T.ID = P.TypeID 

INNER JOIN MeasureDomainMapping MAP ON MAP.MeasureID = M.ID 

INNER JOIN DashboardCompartmentDomain DO ON DO.ID = MAP.DomainID 

INNER JOIN DashboardCompartment C ON C.ID = DO.COmpartmentID 

INNER JOIN Dashboard D ON D.ID = C.DashboardID 

WHERE D.Description IN ('Day Cases and outpatient procedures') 

AND C.Description = 'BADS Overview' 

AND M.Description IN  

('BADS All: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Breast: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Emergency surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Endocrine surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS ENT: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS General Surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Gynaecology: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Ophthalmology: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Oral and Maxillofacial Surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Orthopaedic: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Paediatric: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Spinal surgery: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Urology: Day case and outpatient % of total procedures (inpatient, day case and outpatient)', 

'BADS Vascular: Day case and outpatient % of total procedures (inpatient, day case and outpatient)') 

AND P.Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5','Y58') 

AND MV.ReportingDate >= '2024-04-01'   

UNION ALL 

/* EBI procedures */ 

SELECT  

Reporting_Period = MV.ReportingDate 

,Organisation_Code = P.Code 

,Data_Source = 'SUS OPA' 

,Measure = 'EBI Procedures' 

,Measure_Type = NULL 

,TFC_or_Diagmodality = M.Description 

,Metric_Type = 'Calculated %' 

,Metric_Value = MV.Value 

,Date_refreshed = CURRENT_TIMESTAMP 

FROM MeasureValue MV 

INNER JOIN Measure M ON M.ID = MV.MeasureID 

INNER JOIN Provider P ON P.ID = MV.ProviderID 

INNER JOIN ProviderType T ON T.ID = P.TypeID 

INNER JOIN MeasureDomainMapping MAP ON MAP.MeasureID = M.ID 

INNER JOIN DashboardCompartmentDomain DO ON DO.ID = MAP.DomainID 

INNER JOIN DashboardCompartment C ON C.ID = DO.COmpartmentID 

INNER JOIN Dashboard D ON D.ID = C.DashboardID 

WHERE M.InternalID IN ('EB0352','EB0243','EB0367','EB0373','EB0322','EB0413','EB0304','EB0237', 

'EB0340','EB0216','EB0355','EB0201','EB0207','EB0361','EB0334','EB0249', 

'EB0225','EB0331','EB0319','EB0364') 

AND P.Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 

AND MV.ReportingDate >= '2024-04-01'   

AND C.Description = 'EBI Procedures' 

UNION ALL 

/* EBI procedures */ 

SELECT  

Reporting_Period = MV.ReportingDate 

,Organisation_Code = P.Code 

,Data_Source = 'National Theatre Data Collection' 

,Measure = 'Case cancellation metrics' 

,Measure_Type = NULL 

,TFC_or_Diagmodality = M.Description 

,Metric_Type = 'Calculated %' 

,Metric_Value = MV.Value 

,Date_refreshed = CURRENT_TIMESTAMP 

FROM MeasureValue MV 

INNER JOIN Measure M ON M.ID = MV.MeasureID 

INNER JOIN Provider P ON P.ID = MV.ProviderID 

INNER JOIN ProviderType T ON T.ID = P.TypeID 

INNER JOIN MeasureDomainMapping MAP ON MAP.MeasureID = M.ID 

INNER JOIN DashboardCompartmentDomain DO ON DO.ID = MAP.DomainID 

INNER JOIN DashboardCompartment C ON C.ID = DO.CompartmentID 

INNER JOIN Dashboard D ON D.ID = C.DashboardID 

WHERE M.InternalID IN ('TP0182','TP0176','TP0183','TP0175','TP0170') 

AND P.Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 

AND MV.ReportingDate >= '2024-04-01'   

AND C.Description = 'Case Cancellations - Monthly' 

UNION ALL 

/* Average cases per 4 hour session*/ 

SELECT  

Reporting_Period = MV.ReportingDate 

,Organisation_Code = P.Code 

,Data_Source = 'National Theatre Data Collection' 

,Measure = CASE  

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session (monthly)' THEN 'Average cases' 

ELSE 'Average cases - specialty level' END 

,Measure_Type = NULL 

,TFC_or_Diagmodality = CASE  

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session (monthly)' THEN 'All' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Ear, Nose and Throat' THEN '120' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - General Surgery' THEN '100' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Gynaecology' THEN '502' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Ophthalmology' THEN '130' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Oral and Maxillofacial Surgery' THEN '145' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Trauma and Orthopaedics' THEN '110' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Urology' THEN '101' 

WHEN M.Description = 'Average number of cases per equivalent 4 hour valid elective session - Plastic Surgery' THEN '160' 

ELSE 'Check' END 

,Metric_Type = 'Calculated %' 

,Metric_Value = MV.Value 

,Date_refreshed = CURRENT_TIMESTAMP 

FROM MeasureValue MV 

INNER JOIN Measure M ON M.ID = MV.MeasureID 

INNER JOIN Provider P ON P.ID = MV.ProviderID 

INNER JOIN ProviderType T ON T.ID = P.TypeID 

INNER JOIN MeasureDomainMapping MAP ON MAP.MeasureID = M.ID 

INNER JOIN DashboardCompartmentDomain DO ON DO.ID = MAP.DomainID 

INNER JOIN DashboardCompartment C ON C.ID = DO.COmpartmentID 

INNER JOIN Dashboard D ON D.ID = C.DashboardID 

WHERE D.Description = 'Theatres' 

AND M.Description IN  

  ('Average number of cases per equivalent 4 hour valid elective session (monthly)', 

  'Average number of cases per equivalent 4 hour valid elective session - Trauma and Orthopaedics', 

  'Average number of cases per equivalent 4 hour valid elective session - Gynaecology', 

  'Average number of cases per equivalent 4 hour valid elective session - Oral and Maxillofacial Surgery', 

  'Average number of cases per equivalent 4 hour valid elective session - Ophthalmology', 

  'Average number of cases per equivalent 4 hour valid elective session - Plastic Surgery', 

  'Average number of cases per equivalent 4 hour valid elective session - General Surgery', 

  'Average number of cases per equivalent 4 hour valid elective session - Ear, Nose and Throat', 

  'Average number of cases per equivalent 4 hour valid elective session - Urology') 

AND P.Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 

AND MV.ReportingDate >= '2024-04-01'   

 