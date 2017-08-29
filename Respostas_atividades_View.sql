USE [SBODESENV]
GO

/****** Object:  View [dbo].[LGO_RespostasAtividades_vw]    Script Date: 04/08/2017 14:48:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[LGO_RespostasAtividades_vw] as

SELECT 
'Código atividade' = T0.ClgCode,
--'OBS atividade'    = T0.Details,
'Cód. Tipo'		   = T0.CntctType,
'Tipo'			   = T4.Name,
'Cód. Assunto'	   = T0.CntctSbjct,
'Assunto'		   = T5.Name,
'Código PN'		   = T0.CardCode,
'Nome do PN'       = (Select CardName from OCRD AX where T0.CardCode = AX.CardCode),
'Nome Fantasia'	   = (Select C.CardFname from OCRD C where T0.CardCode = C.CardCode),
'Parce/Imple'	   = (Select D.U_LGO_Parc_Imple From OCRD D where T0.Cardcode = D.CardCode),
'Atividade Ano'    = T0.U_LGO_PARC_IMPLE,
'Colaborador'      = T1.U_Name,
'Responsavel Pedg' = (T8.firstName +' '+T8.lastName) , --ADICIONADO WILLIAM 11/02/2016
'Responsavel Rel' = (T9.firstName +' '+T9.lastName) , --ADICIONADO WILLIAM 11/02/2016
'Departamento'     = t6.Name,
'Data inicio'      = convert (nvarchar,T0.Recontact,103),
'Data de término'  =  convert (nvarchar,T0.EndDate,103),
'Código da Pergunta' = T2.U_CodPerg,
'Pergunta'			= T2.U_Pergunta,
'Código da Resposta' = T3.U_CodResp,
'Resposta'           = T3.U_Resposta,
'Obs da Resposta'   = T2.U_OBS2,
CASE  WHEN T0.ParentType = 191 THEN 'ATIVIDADE DO CHAMADO'
	  else 'ATIVIDADE FORA DO CHAMADO'
END 'Origem Atividade',
'SIM / NÃO'			= T3.U_Checado

FROM 
OCLG T0
JOIN OUSR T1 ON T0.AttendUser = T1.USERID
JOIN OUDP T6 ON T1.Department = T6.Code
JOIN [@LGCCLASAT] T2 ON T2.U_CodAtiv = T0.ClgCode
JOIN [@LGLCCLASAT] T3 ON T2.Code = T3.Code
JOIN OCLT T4 on T0.CntctType = T4.Code
JOIN OCLS T5 ON T0.CntctSbjct = T5.Code
JOIN OCRD T7 ON T0.CardCode = T7.CardCode
LEFT JOIN OHEM T8 ON T8.empID = T7.U_LGO_CodRespPed --ADICIONADO WILLIAM 11/02/2016
LEFT JOIN OHEM T9 ON T9.empID = T7.U_LGO_CodRespRel --ADICIONADO WILLIAM 11/02/2016


WHERE T3.U_Checado = 'SIM' and T0.U_LGO_PARC_IMPLE >
= '2014/2015'





GO


