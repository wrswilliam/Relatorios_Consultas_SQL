--Select Dev.Nota Fiscal Sa�
SELECT T1.AgrNo,
	   T1.AgrLnNum,
	   T0.CardCode,
	   T0.CardName,
	   T5.TaxId0,
	   T5.CityS,
	   T5.State,
	   T0.DocEntry,
	   T0.DocDate,
	   T1.ItemCode,
	   T1.Dscription,
       CAST(T1.Quantity as decimal(8,2)) as  'Qtd.',
	   cast(T1.PRICE as decimal(8,2)) as 'Preço',
	   cast(T1.LINETOTAL as decimal(8,2)) as Total

 FROM ORIN T0
 INNER JOIN RIN1 T1 ON T1.DocEntry = T0.DOCENTRY
 INNER JOIN RIN12 T5 ON T5.DocEntry = T0.DocEntry
 WHERE T0.CANCELED = 'N'
 and T0.CARDCODE = 'C00300'

 GROUP BY T1.AgrNo,T1.AgrLnNum,T0.CardCode,T0.CardName,
	   T5.TaxId0,T5.CityS,T5.State,T0.DocEntry,T0.DocDate,
	   T1.ItemCode,T1.Dscription,T1.Price,T1.LineTotal,T1.Quantity

UNION ALL

--SELECT DEVOLUǃO AVULSA
SELECT T1.AgrNo,
	   T1.AgrLnNum,
	   T0.CardCode,
	   T0.CardName,
	   T5.TaxId0,
	   T5.CityS,
	   T5.State,
	   T0.DocEntry,
	   T0.DocDate,
	   T1.ItemCode,
	   T1.Dscription,
       cast(T1.Quantity as decimal(8,2)) as  'Qtd.',
	   cast(T1.PRICE as decimal(8,2)) as 'Preço',
	   cast(T1.LINETOTAL as decimal(8,2)) as Total

 FROM ORDN T0
 INNER JOIN RDN1 T1 ON T1.DocEntry = T0.DOCENTRY
 INNER JOIN RDN12 T5 ON T5.DocEntry = T0.DocEntry
 WHERE T0.CANCELED = 'N'
AND T0.CARDCODE = 'C00300'
 GROUP BY T1.AgrNo,T1.AgrLnNum,T0.CardCode,T0.CardName,
	   T5.TaxId0,T5.CityS,T5.State,T0.DocEntry,T0.DocDate,
	   T1.ItemCode,T1.Dscription,T1.Price,T1.LineTotal,T1.Quantity

ORDER BY T0.CardCode,T1.AgrNo,T1.ItemCode