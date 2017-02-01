SELECT 
	T0.OpprID Oportunidade,
	T0.CardCode,
	T0.CardName,
	T1.City Cidade,
	T2.Descript Regiao,
	T1.U_LG_RespCom Consultor,
	T3.Step_ID Est_Oport,
	T0.OpenDate
FROM OOPR T0
	INNER JOIN OCRD T1 ON T0.CardCode = T1.CardCode
	INNER JOIN OTER T2 ON T0.Territory = T2.TerritryID
	INNER JOIN OPR1 T3 ON T0.OpprID = T3.OpprID
GROUP BY T0.OpprID,T0.CardCode,T0.CardName,T1.City,
		 T2.Descript,T1.U_LG_RespCom,T3.Step_ID,T0.OpenDate
		 