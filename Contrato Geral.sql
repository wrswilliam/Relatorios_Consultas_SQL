--contrato geral

SELECT 
T0.[Number], 
T0.[Method],
T0.AbsID  AS 'Nº Contrato',

T0.[BpCode], 
T0.[BpName], 
T2.CardFName, 
T2.LicTradNum  AS 'CNPJ',
T2.City        AS 'Cidade',
T2.State1      AS 'UF',

'Responsavel Pedg' = (T3.firstName +' '+T3.lastName) , --ADICIONADO WILLIAM 02/02/2016
'Responsavel Rel' = (T4.firstName +' '+T4.lastName) , --ADICIONADO WILLIAM 02/02/2016
'Respomsavel Com' = (T5.firstName +' '+T5.lastName) , --ADICIONADO WILLIAM 02/02/2016

T2.[QryGroup1] AS 'Contrato',
T2.[QryGroup2] AS 'Piloto',
T2.[QryGroup3] AS 'Franqueado',
T2.[QryGroup4] AS 'Mantenedor',
T2.[QryGroup8] AS 'Filantropico',
T2.[QryGroup7] AS 'Revendedor',
T2.[QryGroup6] AS 'Publico',
T2.[QryGroup5] AS 'Privado',
T2.[QryGroup9] AS 'Diamante',
T2.[QryGroup10] AS 'Ouro',
T2.[QryGroup11] AS 'Prata',
T2.[QryGroup12] AS 'Bronze',
T2.[QryGroup14] AS 'Serviço',
T2.[QryGroup45] AS 'A',
T2.[QryGroup46] AS 'B',
T2.[QryGroup47] AS 'C',
T2.[QryGroup15] AS 'Basico Imp',
T2.[QryGroup16] AS 'Medio Imp',
T2.[QryGroup17] AS 'Pleno Imp',
T2.[QryGroup18] AS 'Basico Con',
T2.[QryGroup19] AS 'Medio Con',
T2.[QryGroup20] AS 'Pleno Con',


T0.U_LGO_AContrato,
T0.U_LGO_CMKT,

T2.U_LGO_Parc_Imple as'Parceria/Implementação',

 T0.[StartDate], 
 T0.[EndDate], 
 T0.[TermDate], 
 T0.[Type], 
 T0.[Owner], 
 T1.[ItemCode], 
 T1.[ItemName], 
 cast(T1.[UnitPrice] as decimal(10,2)) as 'Preço Unitário' ,  
 T0.U_LG_Total AS 'Total Aluno Contrato',
 cast(T1.[PlanQty] as int) As 'Quantidade Planejada', 
 cast(T1.[CumQty]  as int) AS 'Quantidade Cumprida', 
 T1.[CumAmntLC], 
 T1.[CumAmntFC], 
 T1.[LineStatus], 
 T1.[AgrLineNum], 
 T0.[Series], 
 T0.[Cancelled], 
 T0.[Status] 
 

 FROM  [dbo].[OOAT] T0  
 INNER  JOIN [dbo].[OAT1] T1  ON  T1.[AgrNo] = T0.[AbsID]   
 INNER JOIN OCRD T2 ON T0.BpCode = T2.CardCode
 LEFT JOIN OHEM T3 ON T3.empID = T2.U_LGO_CodRespPed --ADICIONADO WILLIAM 02/02/2016
 LEFT JOIN OHEM T4 ON T4.empID = T2.U_LGO_CodRespRel --ADICIONADO WILLIAM 02/02/2016
 LEFT JOIN OHEM T5 ON T5.empID = T2.U_LGO_CodRespCom --ADICIONADO WILLIAM 02/02/2016
	

 WHERE T0.[Number] > 0
 AND  T0.[BpType] = 'C'  
 AND  (T0.[Cancelled] = 'N')  
 AND  T0.[Status] = 'A' 
 AND  T0.[Method] = 'I'
 AND  T1.[LineStatus] = 'O'
 ORDER BY T0.[AbsID],T1.[ItemCode]