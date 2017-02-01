em exel, relação de cliente: cod, nome, end, estado

SELECT DISTINCT

isnull(T1.[BpCode],T0.[CardCode]) as 'Código do Cliente',
isnull(T1.BpName,T0.CardName) as 'Nome do Cliente',
T0. CardFName AS 'Nome Fantasia',
T0.State1  AS 'UF',
T0.City AS 'Cidade',
T2.Street AS 'RUA/CAIXA POSTAL',
T2.StreetNo AS 'N°'
 
FROM OCRD T0
INNER JOIN OOAT T1 ON T1.BpCode = T0.CardCode
INNER JOIN CRD1 T2 ON T0.CardCode = T2.CardCode
Where T1.Status = 'A' and T1.Cancelled = 'N'
and t0.QryGroup6 = 'N'
AND T0.QryGroup8 = 'N'
AND T0.QryGroup2 ='N'
AND T0.QryGroup3 = 'N'

UNION ALL

SELECT DISTINCT


T0.[CardCode] as 'Código do Cliente',
T0.CardName as 'Nome do Cliente',
T0. CardFName AS 'Nome Fantasia',
T0.State1  AS 'UF',
T0.City AS 'Cidade',
T2.Street AS 'RUA/CAIXA POSTAL',
T2.StreetNo AS 'N°'
 
FROM OCRD T0
INNER JOIN CRD1 T2 ON T0.CardCode = T2.CardCode

Where 
 T0.CardType = 'C' and T0.[validFor] = 'Y' AND  T0.[QryGroup14] = 'Y'
 
 GROUP BY T0.CardCode,T0.CardName,T0. CardFName,T0.City,T0.State1,T2.Street,T2.StreetNo
