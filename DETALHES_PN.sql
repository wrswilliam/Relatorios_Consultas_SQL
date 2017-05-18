SELECT 
		T1.CardCode
 	   ,T1.CardName AS RAZAO_SOCIAL
	   ,T1.CardFName AS NOME_FANTASIA
	   ,T0.Name AS ID_CONTATO
	   ,T0.FirstName + ' ' + T0.MiddleName + ' ' + T0.LastName AS NOME_CONTATO
	   ,T0.Tel1 AS TELEFONE1
	   ,T0.Tel2 AS TELEFONE2
	   ,T0.Cellolar AS CELULAR
	   ,T0.E_MailL
 FROM OCPR T0
 INNER JOIN OCRD T1 ON T0.CardCode = T1.CardCode
 WHERE T1.CardType ='C'
	AND T1.FROZENFOR = 'N'
