SELECT T0.CARDCODE,
	   T0.CARDNAME,
	   T0.CardType,
	   T0.LicTradNum AS 'CNPJ CADASTRO',
	   T1.LicTradNum AS 'CNPJ ENDEREÇO',
	   T2.TaxId0 AS 'CNPJ IND. FISCAL'
FROM OCRD T0
INNER JOIN CRD1 T1 ON T0.CardCode = T1.CardCode
INNER JOIN CRD7 T2 ON T0.CardCode = T2.CardCode
WHERE T0.LicTradNum IS NULL OR T0.LicTradNum = ''
AND CardType IN ('C','L')
ORDER BY CardType


select * from CRD7