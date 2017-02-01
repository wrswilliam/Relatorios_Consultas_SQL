--OPORTUNIDADE_VENDA_GERAL (Retorna as informações das Oportunidades de vendas,  
--tanto Leads e aqueles que viraram Clientes após o consultor vencer a oportunidade)

SELECT 
	T0.OpprID AS NUM_OPORTUNIDADE,
	T0.CardCode,
	T0.CardName,
	CASE T1.CardType
		WHEN 'L' THEN 'LEAD'
		WHEN 'C' THEN 'CLIENTE'
	END TIPO_PN,
	T1.City Cidade,
	T2.Descript Regiao,
	(T8.firstNAME + T8.lastNAME) AS RESP_COMERCIAL,
	T7.SlpName AS VENDEDOR,
	T0.U_LGO_Coordenador AS COORDENADOR,
	T6.Descript AS FONTE_DE_INFORMACAO,
	T4.Descript as Est_Oport ,
	T5.Descript AS Interesse,
	T0.OpenDate,
	T3.Step_Id AS NUM_ETAPA,
	T3.ClosePrcnt AS PORCENTAGEM_PROSPECCAO,
	T0.MaxSumLoc AS VALOR_POTENCIAL,
	CASE T0.Status 
		WHEN 'w' THEN 'Venceu'
		WHEN 'o' THEN 'Aberto' 
		WHEN 'l' THEN 'Perdeu'
	END AS STATUS_OPORTUNIDADE,
	CASE T1.U_LG_StatusCon 
		WHEN 1 THEN 'Aguardando Ficha cadastral'
		WHEN 2 THEN 'Em Elaboração'
		WHEN 3 THEN 'Alteração de Cláusula'
		WHEN 4 THEN 'Enviado'
		WHEN 5 THEN 'Assinado'
		WHEN 6 THEN 'Encerrado'
	 END AS Status_Contrato,
	T1.U_LGO_Tot_Geral AS TOTAL_ALUNOS_ESCOLA_CAD_PN,
	T0.U_LGO_Tot_Geral AS TOTAL_ALUNO_OPORTUNIDADE
	
FROM OOPR T0
	INNER JOIN OCRD T1 ON T0.CardCode = T1.CardCode
	LEFT JOIN OTER T2 ON T0.Territory = T2.TerritryID
	LEFT JOIN OPR1 T3 ON T0.OpprID = T3.OpprID
    LEFT JOIN OOST T4 ON T4.STEPID = T3.Step_Id
	LEFT JOIN OOIR T5 ON T0.IntRate = T5.Num
	LEFT JOIN OOSR T6 ON T0.Source = T6.Num
	LEFT JOIN OSLP T7 ON T0.SlpCode = T7.SlpCode
	LEFT JOIN OHEM T8 ON T1.U_LGO_CodRespCom = T8.empID 
 where
	 T3.Line = (select max(Line) from OPR1 T3 where T0.OpprId = T3.OpprId)
	 				 			  
GROUP BY T0.OpprID,T0.CardCode,T0.CardName,T1.CardType,T1.City,
		 T2.Descript,(T8.firstNAME + T8.lastNAME),T4.descript,T5.Descript,T0.OpenDate,T3.Step_Id,
		 T3.ClosePrcnt,T0.MaxSumLoc,T1.U_LG_StatusCon,T1.U_LGO_Tot_Geral,T0.U_LGO_Tot_Geral,T0.SlpCode,
		 T0.Status,T6.Descript,T7.SlpName,T0.U_LGO_Coordenador