SELECT
	 T0.AgrNo
	,T1.BpCode AS 'Código PN'
	,T1.BpName AS 'Nome do PN'
	,T2.CARDFNAME AS 'Nome Fantasia'
	,T2.LicTradNum AS 'CNPJ'
	,T2.CITY AS 'CIDADE'
	,T2.State1 AS 'ESTADO'
	,'Responsavel Ped' = (T3.firstName +' '+T3.lastName)
	,'Responsavel Rel' = (T4.firstName +' '+T4.lastName) 
	,'Respomsavel Com' = (T5.firstName +' '+T5.lastName) 
	,T1.U_LGO_AContrato
	,T1.U_LGO_CMKT
	,T2.U_LGO_Parc_Imple as'Parceria/Implementação'
	,T2.QryGroup1 AS 'CONTRATO'
	,T2.QryGroup2 AS 'PILOTO'
	,T2.QryGroup3 AS 'FRANQUEADO'
	,T2.QryGroup4 AS 'MANTENEDOR'
	,T2.QryGroup5 AS 'PRIVADO'
	,T2.QryGroup6 AS 'PUBLICO'
	,T2.QryGroup7 AS 'REVENDEDOR'
	,T2.QryGroup8 AS 'FILANTROPICO'
	,T2.QryGroup13 AS 'EX PILOTO'
	,T2.QryGroup14 AS 'SERVIÇO'
	,T2.QryGroup63 AS 'EX-CLIENTE'
	,T2.QryGroup64 AS 'PROPRIO'
	,CASE 
			WHEN T1.Status = 'A' THEN 'AUTORIZADO'
			WHEN T1.Status = 'F' THEN 'CANCELADO'
			WHEN T1.Status = 'D' THEN 'ESBOÇO'
			WHEN T1.Status = 'T' THEN 'ENCERADO'
	 END AS 'STATUS CONTRATO'
	,T1.Cancelled AS 'CONTRATO CANCELADO' 
	,T1.[StartDate] 
	,T1.[EndDate]
	,T1.[TermDate]
	,T1.[Type]
	,T1.[Owner]
	,T0.AgrLineNum
	,T0.ItemCode
	,T0.ItemName
	,T0.ItemGroup
	,T0.PlanQty


	,'Qtdade Acomulada' = CAST( ISNULL((SELECT SUM(T0x1.Quantity) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolução de Nota de Saída
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolução de Entrega
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RDN1 T0x1 JOIN ORDN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum AND T0x2.SEQCODE <>'1'),0) AS DECIMAL)
	,'Qtdade Pedente' = CAST(CASE WHEN (T0.PlanQty - (ISNULL((SELECT SUM(T0x1.Quantity) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolução de Nota de Saída
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)) -
							--Devolução de Entrega
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RDN1 T0x1 JOIN ORDN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum AND T0x2.SEQCODE <>'1'),0)) < 0 THEN 0
							ELSE (T0.PlanQty - (ISNULL((SELECT SUM(T0x1.Quantity) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolução de Nota de Saída
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)) -
							--Devolução de Nota de Entrega
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RDN1 T0x1 JOIN ORDN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum AND T0x2.SEQCODE <>'1'),0)) end AS DECIMAL)
 	,'Valor Nota de Saída' = CAST(ISNULL((SELECT SUM(T0x1.LineTotal) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) -
							--Devolução Nota de Saída
							ISNULL((SELECT SUM(T0x1.LineTotal) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)-
							--Devolução de Entrega
							ISNULL((SELECT SUM(T0x1.LineTotal) FROM RDN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)AS DECIMAL(10,2))
             ,T0.PlanAmtLC as 'Valor(MC)'

	,'Qtdade Pedido' = CAST(ISNULL((SELECT SUM(T0x1.Quantity) FROM RDR1 T0x1 JOIN ORDR T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)AS decimal)
	,T0.InvntryUom
	,T0.UomCode
	,T0.NumPerMsr

FROM OAT1 T0
	INNER JOIN OOAT T1 ON T0.AgrNo = T1.AbsID
	INNER JOIN OCRD T2 ON T2.CARDCODE = T1.BpCode
	LEFT JOIN OHEM T3 ON T3.empID = T2.U_LGO_CodRespPed
	LEFT JOIN OHEM T4 ON T4.empID = T2.U_LGO_CodRespRel
	LEFT JOIN OHEM T5 ON T5.empID = T2.U_LGO_CodRespCom

WHERE t1.StartDate >= [%0]
AND t1.EndDate <= [%1]
AND T1.Cancelled = 'N'
AND T1.Status IN ('A','T')
AND T1.U_LGO_AContrato = 'Privado'
AND T1.U_LGO_CMKT = 'NÃO'
AND T2.QryGroup2 ='N'
AND T2.QryGroup5 ='Y'
AND T2.QryGroup14 ='N'
AND T0.ITEMCODE IN ('RE00001','RE00013','RE00025','RE00032','RE00043','RE00060','RE00065','RE00083','RE00070','RE00087','RE00103','RE00153','RE00227')
ORDER BY T0.AgrNo
	,T0.AgrLineNum