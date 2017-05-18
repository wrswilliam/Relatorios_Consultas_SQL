SELECT  DISTINCT (T0.CARDCODE)
	    ,T0.CardName AS 'Razão Social'
	    ,T0.CardFName AS 'Nome Fantasia'
		,T0.LicTradNum AS 'CNPJ'
		,T2.E_MailL
		,T1.AddrType+ '  '+T1.Street + ' , '+ T1.Block + ' , '+T1.ZipCode+ ' , '+T1.City+ ' , '+T1.State AS 'LOGRADOURO'

FROM OCRD T0
LEFT JOIN CRD1 T1 ON T0.CardCode = T1.CardCode
					AND T1.LineNum = 0
LEFT JOIN OCPR T2 ON T0.CardCode = T2.CardCode
					AND T2.E_MailL IS NOT NULL
					AND T2.NFeRcpn = 'Y'
WHERE T0.U_LG_Frete = 1




SELECT * FROM CRD1