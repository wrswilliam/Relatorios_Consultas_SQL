DECLARE @RELATORIO_FABIO TABLE(
	CODIGO_PN NVARCHAR (8)
   ,NOME_FANTASIA NVARCHAR (255)
   ,CIDADE NVARCHAR(255)
   ,ESTADO NVARCHAR(2)
   ,ITEMCODE NVARCHAR (10)
   ,ITEMNAME NVARCHAR (255)
   ,ITEMGROUP INT
   ,QTD_PLANEJADA INT
   ,QTD_ACOMULADA INT
   ,QTD_PENDENTE INT
   ,VALOR_NOTA DECIMAL (10,2)
   ,VALORMC DECIMAL (10,2)
   ,QTD_PEDIDO INT
   
)

INSERT INTO @RELATORIO_FABIO (CODIGO_PN,NOME_FANTASIA,CIDADE,ESTADO
   ,ITEMCODE,ITEMNAME,ITEMGROUP,QTD_PLANEJADA,QTD_ACOMULADA,QTD_PENDENTE 
   ,VALOR_NOTA,VALORMC,QTD_PEDIDO) (SELECT
	 T1.BpCode AS 'C�digo PN'
	,T2.CARDFNAME AS 'Nome Fantasia'
	,T2.CITY AS 'CIDADE'
	,T2.State1 AS 'ESTADO'
	,T0.ItemCode
	,T0.ItemName
	,T0.ItemGroup
	,cast (T0.PlanQty as decimal) 'Qtd Planejada'
	
	,'Qtdade Acomulada' = CAST( ISNULL((SELECT SUM(T0x1.Quantity) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolu��o de Nota de Sa�da
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolu��o de Entrega
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RDN1 T0x1 JOIN ORDN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum AND T0x2.SEQCODE <>'1'),0) AS DECIMAL)
	,'Qtdade Pedente' = CAST(CASE WHEN (T0.PlanQty - (ISNULL((SELECT SUM(T0x1.Quantity) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolu��o de Nota de Sa�da
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)) -
							--Devolu��o de Entrega
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RDN1 T0x1 JOIN ORDN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum AND T0x2.SEQCODE <>'1'),0)) < 0 THEN 0
							ELSE (T0.PlanQty - (ISNULL((SELECT SUM(T0x1.Quantity) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) - 
							--Devolu��o de Nota de Sa�da
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)) -
							--Devolu��o de Nota de Entrega
							ISNULL((SELECT SUM(T0x1.Quantity) FROM RDN1 T0x1 JOIN ORDN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum AND T0x2.SEQCODE <>'1'),0)) end AS DECIMAL)
 	,'Valor Nota de Sa�da' = CAST(ISNULL((SELECT SUM(T0x1.LineTotal) FROM INV1 T0x1 JOIN OINV T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0) -
							--Devolu��o Nota de Sa�da
							ISNULL((SELECT SUM(T0x1.LineTotal) FROM RIN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)-
							--Devolu��o de Entrega
							ISNULL((SELECT SUM(T0x1.LineTotal) FROM RDN1 T0x1 JOIN ORIN T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)AS DECIMAL(10,2))
             ,T0.PlanAmtLC as 'Valor(MC)'

	,'Qtdade Pedido' = CAST(ISNULL((SELECT SUM(T0x1.Quantity) FROM RDR1 T0x1 JOIN ORDR T0x2 ON T0x1.DocEntry = T0x2.DocEntry AND T0x2.CANCELED = 'N' 
							WHERE T0x1.ItemCode = T0.Itemcode AND T0x1.AgrNo = T0.AgrNo and T0x1.AgrLnNum = T0.AgrLineNum),0)AS decimal)
    
FROM OAT1 T0
	INNER JOIN OOAT T1 ON T0.AgrNo = T1.AbsID
	INNER JOIN OCRD T2 ON T2.CARDCODE = T1.BpCode

WHERE t1.StartDate >= '2016-08-01'
AND t1.EndDate <= '2017-12-31'
AND T1.Cancelled = 'N'
AND T1.Status IN ('A','T')
AND T1.U_LGO_AContrato = 'Privado'
AND T1.U_LGO_CMKT = 'N�O'
AND T2.QryGroup2 ='N'
AND T2.QryGroup5 ='Y'
AND T2.QryGroup14 ='N'
AND T0.ITEMCODE IN ('RE00001','RE00013','RE00025','RE00031','RE00037','RE00043','RE00050','RE00060','RE00065','RE00083','RE00070','RE00087','RE00232','RE00228','RE00154')--,'RE00227'
) 
SELECT  DISTINCT
		 R0.ITEMNAME
		,CASE WHEN R0.ITEMNAME = 	'O Brilho da Inteligencia Kit - Aluno - Parte 1' OR R0.ITEMNAME = 'O Brilho da Inteligencia - Aluno - Parte 1'	THEN	'3 anos EI'
			  WHEN R0.ITEMNAME = 	'Ciranda da Inteligencia Aluno li�ao 1'						THEN	'4 anos EI'
			  WHEN R0.ITEMNAME = 	'Jogos da Inteligencia Aluno li�ao 1'						THEN	'5 anos EI'
			  WHEN R0.ITEMNAME = 	'Olimpiadas da Inteligencia Aluno parte 1'					THEN	'1� ano EFI'
			  WHEN R0.ITEMNAME = 	'Inteligencia Saudavel Aluno parte 1'						THEN	'2� ano EFI'
		  	  WHEN R0.ITEMNAME = 	'Rela�oes Saudaveis Aluno parte 1'							THEN	'3� ano EFI'
			  WHEN R0.ITEMNAME = 	'Cidade da Memoria Aluno parte 1'							THEN	'4� ano EFI'
			  WHEN R0.ITEMNAME = 	'Armadilhas da Mente Aluno li�ao 1'							THEN	'5 �ano EFI'
			  WHEN R0.ITEMNAME = 	'Mentes Brilhantes Aluno parte 1'							THEN	'6� ano EFII'
			  WHEN R0.ITEMNAME = 	'Codigos da Inteligencia Aluno parte 1'						THEN	'7� ano EFII'
			  WHEN R0.ITEMNAME = 	'EU no Comando da Mente Aluno parte 1'						THEN	'8� ano EFII'
			  WHEN R0.ITEMNAME = 	'Ser Humano Sem Fronteiras Aluno li�ao 1'					THEN	'9� ano EFII'
			  WHEN R0.ITEMNAME = 	'Identidade A Lideran�a do EU Aluno li�ao 1'				THEN	'1� ano EM'
			  WHEN R0.ITEMNAME = 	'Eu em Cena - Aluno - Parte 1'								THEN	'2� ano EM'
			  WHEN R0.ITEMNAME = 	'Gest�o da Emo�ao Vestibular e Profissao Aluno Parte 1'	OR R0.ITEMNAME = 	'Gestao da Emocao Vestibular e Profissao Aluno Parte 1'	THEN	'3� ano EM'
			  WHEN R0.ITEMNAME = 	'Em Familia - Desenvolvendo a Inteligencia Socioemocional'	THEN	'Familia'

		 END SEGMENTO
		,'QTD_KIT' = (SELECT COUNT (A.ITEMNAME) FROM @RELATORIO_FABIO A WHERE A.ITEMNAME =  R0.ITEMNAME)
		,'QTD_ALUNO' = (SELECT SUM
        ,SUM(CAST(R0.QTD_PLANEJADA AS INT)) QTD_PLANEJADA
		,SUM(CAST(R0.QTD_ACOMULADA AS INT)) QTD_ALUNO_EI
		,'COTACAO' = ISNULL((SELECT SUM(CAST(T1.Quantity AS INT)) FROM OQUT T0 INNER JOIN QUT1 T1 ON T0.DocEntry = T1.DocEntry
															   WHERE T1.Dscription = R0.ITEMNAME AND T0.DOCSTATUS = 'O'),0)
			
		FROM @RELATORIO_FABIO R0
	PIVOT(
		  SUM(R0.QTD_PENDENTE) FOR
			R0.ITEMCODE IN (RE00001,RE00013,RE00025,RE00031,RE00037,RE00043,RE00050,RE00060,RE00065,RE00083,RE00070,RE00087,RE00232,RE00228,RE00154)
		) AS R0
		GROUP BY R0.ITEMNAME

