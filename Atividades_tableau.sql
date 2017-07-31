-- atividades tableau

SELECT DISTINCT
	t0.Closed,
	T6.CardFName,
	t0.ClgCode,                                                                              
	CAST(t2.U_CodPerg as nvarchar(max))[CodPerg],                                                   
	CAST(U_CodAtiv as nvarchar(max))[CodAtiv], 
	T4.NAME AS Assunto,                                                     
	CAST(U_Pergunta as nvarchar(max))[Perg],                                                        
	CAST(U_CodAssunto as nvarchar(max))[Ass],	                                                    
	CAST(U_Resposta as nvarchar(max))[Resp],                                                        
	CAST(T0.CardCode as nvarchar(max))[CardCode],                                                      
	CAST(AttendUser as nvarchar(max))[AttendUser],  
	T5.firstName + T5.lastName AS U_NAME,
	t0.U_LGO_PARC_IMPLE                                               
FROM OCLG t0                                                                                    
	INNER JOIN [@LGCCLASAT] T2 ON T2.U_CodAtiv = T0.ClgCode                                         
	INNER join [@LGLCCLASAT] T3 ON t2.code = t3.code 
	INNER JOIN OCLS T4 ON T4.CODE = T0.CntctSbjct --and t4.Active = 'Y'
	INNER JOIN OHEM T5 ON T0.AttendUser = T5.USERID
	INNER JOIN OCRD T6 ON T0.CardCode = T6.CardCode
					  AND T6.U_LGO_CodRespPed = T5.empID
                 
WHERE t3.u_checado = 'SIM'                                                                      
  AND T0.inactive = 'N'             


  union all

  SELECT DISTINCT
    t0.Closed,
	T6.CardFName,
	t0.ClgCode,                                                                              
	CodPerg ='',                                                   
	CodAtiv ='', 
	T4.NAME AS Assunto,                                                     
	Perg ='',                                                        
	Ass ='',	                                                    
	Resp ='',                                                        
    T0.CardCode,                                                      
	t0.AttendUser ,  
	T5.firstName + T5.lastName AS U_NAME,
	t0.U_LGO_PARC_IMPLE                                               
FROM OCLG t0                                                                                    
	INNER JOIN OCLS T4 ON T4.CODE = T0.CntctSbjct
	INNER JOIN OHEM T5 ON T0.AttendUser = T5.USERID
	INNER JOIN OCRD T6 ON T0.CardCode = T6.CardCode
					  AND T6.U_LGO_CodRespPed = T5.empID
                                               
WHERE CLOSED = 'N'                                                             
  AND T0.inactive = 'N'


