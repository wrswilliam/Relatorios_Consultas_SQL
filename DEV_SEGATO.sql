
WITH W_DEV AS(
SELECT DISTINCT 
	   T0.ItemCode AS 'CODIGO ITEM',
	   T0.ItemName AS 'DESCRI플O ITEM',
	   T1.OnHand AS 'EM ESTOQUE',
	   T1.IsCommited AS 'CONFIRMADO',
	   T1.OnOrder AS 'EM PEDIDO',
	   ((T1.OnHand+T1.OnOrder)- T1.IsCommited) AS 'DISPONIVEL',
	   SUM(T2.Quantity) AS 'QUANTIDADE DEVOLU플O'
	   --t2.docdate
	
FROM OITM T0
INNER JOIN OITW T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN RIN1 T2 ON T0.ItemCode = T2.ItemCode
INNER JOIN ORIN T3 ON T2.DocEntry = T3.DocEntry
WHERE T1.WhsCode = 01 
and t3.TaxDate >='01-11-2014'
AND T3.CANCELED = 'N'
AND T3.DocDate >=[%0]
AND T3.DocDate >=[%1]

GROUP BY T0.ItemCode,T0.ItemName,T1.OnHand,T1.IsCommited,T1.OnOrder--t2.docdate

),

W_DEVA AS (

SELECT DISTINCT 
	   T0.ItemCode AS 'CODIGO ITEM',
	   T0.ItemName AS 'DESCRI플O ITEM',
	   T1.OnHand AS 'EM ESTOQUE',
	   T1.IsCommited AS 'CONFIRMADO',
	   T1.OnOrder AS 'EM PEDIDO',
	   ((T1.OnHand+T1.OnOrder)- T1.IsCommited) AS 'DISPONIVEL',
	   SUM(T2.Quantity) AS 'QUANTIDADE DEVOLU플O'
	  
	
FROM OITM T0
INNER JOIN OITW T1 ON T0.ItemCode = T1.ItemCode
INNER JOIN RDN1 T2 ON T0.ItemCode = T2.ItemCode
INNER JOIN ORDN T3 ON T2.DocEntry = T3.DocEntry
WHERE T1.WhsCode = 01 
and t3.TaxDate >='01-11-2014'
AND T3.CANCELED = 'N'
AND T3.DocDate >=[%0]
AND T3.DocDate >=[%1]

GROUP BY T0.ItemCode,T0.ItemName,T1.OnHand,T1.IsCommited,T1.OnOrder--t2.docdate


)

SELECT 
	    ISNULL(T0.[CODIGO ITEM],T1.[CODIGO ITEM]) AS 'CODIGO ITEM'
	   ,ISNULL(T0.[DESCRI플O ITEM],T1.[DESCRI플O ITEM])  AS 'DESCRI플O ITEM'
	   ,CAST(ISNULL(T0.[EM ESTOQUE],T1.[EM ESTOQUE])AS decimal) AS 'EM ESTOQUE'
	   ,CAST(ISNULL(T0.CONFIRMADO,T1.CONFIRMADO) AS decimal) AS 'EM ESTOQUE'
	   ,CAST(ISNULL(T0.[EM PEDIDO],T1.[EM PEDIDO]) AS decimal) AS 'EM PEDIDO'
	   ,CAST(ISNULL(T0.DISPONIVEL,T1.DISPONIVEL) AS DECIMAL)AS 'DISPONIVEL'
	   ,CAST((T0.[QUANTIDADE DEVOLU플O]+T1.[QUANTIDADE DEVOLU플O])AS decimal) AS 'QUANTIDADE DEVOLU플O'
	    
FROM W_DEV T0
INNER JOIN W_DEVA T1 ON T1.[CODIGO ITEM] = T0.[CODIGO ITEM]


/* apenas testes*/