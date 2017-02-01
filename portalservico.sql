SELECT T0.ACTION AS TIPO
      ,T1.NAME AS DEPARTAMENTO
	  ,T2.Name AS ATIVIDADE
	  ,T0.Recontact AS INICIO
	  ,T0.endDate as time
	  ,T0.BeginTime
	  ,T0.ENDTime
	  ,(T4.firstNAME + T4.lastNAME) AS 'Consultor'
FROM OCLG T0
INNER JOIN OCLT T1 ON T0.CntctType = T1.CODE
INNER JOIN OCLS T2 ON T0.CntctSbjct = T2.CODE
INNER JOIN OCRD T3 ON T0.CardCode = T3.CARDCODE
LEFT JOIN OHEM  T4 ON T3.U_LGO_CodRespPed = T4.empID 





select * from oclg