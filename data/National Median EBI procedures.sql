SELECT  DISTINCT

MV.ReportingDate AS Reporting_Period, 
--P.Code AS Organisation_Code, 
M.Description AS ebi_Procedure, 
--MV.Value AS Metric_Value, 
PERCENTILE_CONT(0.5)  
WITHIN GROUP (ORDER BY MV.Value)  OVER (PARTITION BY M.Description, MV.ReportingDate)  AS 'National median' 

FROM MeasureValue MV  
 
INNER JOIN Measure M ON M.ID = MV.MeasureID  
INNER JOIN Provider P ON P.ID = MV.ProviderID  
INNER JOIN ProviderType T ON T.ID = P.TypeID  
INNER JOIN MeasureDomainMapping MAP ON MAP.MeasureID = M.ID  
INNER JOIN DashboardCompartmentDomain DO ON DO.ID = MAP.DomainID  
INNER JOIN DashboardCompartment C ON C.ID = DO.COmpartmentID  
INNER JOIN Dashboard D ON D.ID = C.DashboardID  

WHERE M.InternalID IN ( 
 'EB0352','EB0243','EB0367','EB0373','EB0322','EB0413','EB0304','EB0237', 
 'EB0340','EB0216','EB0355','EB0201','EB0207','EB0361','EB0334','EB0249', 
 'EB0225','EB0331','EB0319','EB0364' ) 
--AND P.Code IN ('RN3','RD1','RNZ','RVJ','RA7','REF','RH8','RA9','RK9','RBD','R0D','RTE','RH5') 

AND T.Description LIKE '%Acute%'

AND ReportingDate >= '2024-04-01'
AND C.Description = 'EBI Procedures' 
