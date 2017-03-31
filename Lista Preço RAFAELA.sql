SELECT 
	T0.CardCode AS CODIGO_PN,
	T0.CardName AS RAZAO_SOCIAL,
	T0.CardFName AS NOME_FANTASIA,
	--T0.CardType AS TIPO_CLIENTE,
	T3.ListName AS LISTA_PRECO,
	cast(T0.Discount as decimal(10,2)) AS '% DE DESCONTO',
	T0.QryGroup15 AS PLANO_BAS_IMP,
	T0.QryGroup16 AS PLANO_MED_IMP,
	T0.QryGroup17 AS PLANO_PLE_IMP,
	T0.QryGroup18 AS PLANO_BAS_CONT,
	T0.QryGroup19 AS PLANO_BAS_CONT,
	T0.QryGroup20 AS PLANO_BAS_CONT,
    T1.City AS CIDADE,
    T1.STATE
FROM OCRD T0
	INNER JOIN CRD1 T1 ON T0.CardCode = T1.CardCode
	INNER JOIN OPLN T3 ON T0.ListNum = T3.ListNum
	WHERE T0.QryGroup1 = 'Y' OR T0.QryGroup4 = 'Y'
	AND T0.CardType = 'C'
	
GROUP BY T0.CardCode,T0.CardName,T0.CardFName,
		 ListName,T0.CardType,T0.Discount,
		 T0.QryGroup15,T0.QryGroup16,T0.QryGroup17,
		 T0.QryGroup18,T0.QryGroup19,T0.QryGroup20,
		 T1.City,T1.STATE