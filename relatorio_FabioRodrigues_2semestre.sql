--2° SEMESTRE
WITH W_RELATORIO_FABIO AS (
SELECT
	 T1.BpCode AS 'Código PN'
	,T2.CARDFNAME AS 'Nome Fantasia'
	,T2.CITY AS 'CIDADE'
	,T2.State1 AS 'ESTADO'
	,T0.ItemCode
	,T0.ItemName
	,T0.ItemGroup
	,cast (T0.PlanQty as decimal) 'Qtd Planejada'
	
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

	,'Qtdade Cotacao' = CAST(ISNULL((SELECT SUM(T0x1.Quantity) FROM QUT1 T0x1 JOIN OQUT T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' AND T0x2.DocStatus = 'O' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)AS decimal)
    
FROM OAT1 T0 WITH (NOLOCK)
	INNER JOIN OOAT T1 WITH (NOLOCK) ON T0.AgrNo = T1.AbsID
	INNER JOIN OCRD T2 WITH (NOLOCK) ON T2.CARDCODE = T1.BpCode

WHERE t1.StartDate >= '2016-05-05'
AND t1.EndDate <= '2017-12-31'
AND T1.Cancelled = 'N'
AND T1.Status IN ('A','T')
AND T1.U_LGO_AContrato = 'Privado'
AND T1.U_LGO_CMKT = 'NÃO'
AND T2.QryGroup2 ='N'
AND T2.QryGroup5 ='Y'
AND T2.QryGroup14 ='N'
AND T0.ITEMCODE IN ('RE00008','RE00020','RE00233','RE00026','RE00032','RE00038','RE00044','RE00057','RE00061','RE00066','RE00076','RE00084','RE00093','RE00155','RE00229','RE00106')

),
W_EI AS(
SELECT 
		RF.[Código PN] 
       ,SUM(RF.[Qtdade Acomulada]) AS 'SEGMENTO ENSINO INFANTIL'
	   ,QTD_KIT = COUNT(RF.ITEMCODE)
	   ,SUM(RF.[Qtdade Cotacao]) AS 'COTACAO'
	FROM W_RELATORIO_FABIO RF WHERE RF.ITEMCODE IN ('RE00008','RE00020','RE00233')
	GROUP BY RF.[Código PN] 

),

W_EF1 AS (
SELECT 
		RF.[Código PN] 
       ,SUM(RF.[Qtdade Acomulada]) AS 'SEGMENTO ENSINO FUNDAMENTAL 1'
	   ,QTD_KIT = COUNT(RF.ITEMCODE)
	   ,SUM(RF.[Qtdade Cotacao]) AS 'COTACAO'
	FROM W_RELATORIO_FABIO RF WHERE RF.ITEMCODE IN ('RE00026','RE00032','RE00038','RE00044','RE00057')
	GROUP BY RF.[Código PN] 
),
W_EF2 AS (
SELECT 
		RF.[Código PN] 
       ,SUM(RF.[Qtdade Acomulada]) AS 'SEGMENTO ENSINO FUNDAMENTAL 2'
	   ,QTD_KIT = COUNT(RF.ITEMCODE)
	   ,SUM(RF.[Qtdade Cotacao]) AS 'COTACAO'
	FROM W_RELATORIO_FABIO RF WHERE RF.ITEMCODE IN ('RE00061','RE00066','RE00076','RE00084')
	GROUP BY RF.[Código PN] 
),
W_EMD AS (
SELECT 
		RF.[Código PN]  
       ,SUM(RF.[Qtdade Acomulada]) AS 'SEGMENTO ENSINO MEDIO'
	   ,QTD_KIT = COUNT(RF.ITEMCODE)
	   ,SUM(RF.[Qtdade Cotacao]) AS 'COTACAO'
	FROM W_RELATORIO_FABIO RF WHERE RF.ITEMCODE IN ('RE00093','RE00155','RE00229','RE00106')
	GROUP BY RF.[Código PN] 
)

SELECT DISTINCT
       RF.[Código PN] 
	  ,RF.[Nome Fantasia]
	  ,ISNULL(EI.[SEGMENTO ENSINO INFANTIL],0) AS 'SEGMENTO ENSINO INFANTIL'
	  ,ISNULL(EI.COTACAO,0) AS 'COTAÇÃO EI'
	  ,ISNULL(EF1.[SEGMENTO ENSINO FUNDAMENTAL 1],0) AS 'SEGMENTO ENSINO FUNDAMENTAL 1'
	  ,ISNULL(EF1.COTACAO,0) AS 'COTAÇÃO RF1'
	  ,ISNULL(EF2.[SEGMENTO ENSINO FUNDAMENTAL 2],0) AS 'SEGMENTO ENSINO FUNDAMENTAL 2'
	  ,ISNULL(EF2.COTACAO,0) AS 'COTAÇÃO EF2'
	  ,ISNULL(EMD.[SEGMENTO ENSINO MEDIO],0) AS 'SEGMENTO ENSINO MEDIO'
	  ,ISNULL(EMD.COTACAO,0) AS 'COTAÇÃO EM'
	  
	
FROM W_RELATORIO_FABIO RF 
	LEFT JOIN W_EI EI  ON RF.[Código PN]  = EI.[Código PN]
	LEFT JOIN W_EF1 EF1 ON RF.[Código PN]  = EF1.[Código PN]
	LEFT JOIN W_EF2 EF2 ON RF.[Código PN]  = EF2.[Código PN]
	LEFT JOIN W_EMD EMD ON RF.[Código PN]  = EMD.[Código PN]
ORDER BY RF.[Código PN] 

