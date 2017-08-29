--carteira tableau

SELECT                                                                        
 'Codigo PN'= T0.CardCode,      
 'NOME PN' = T6.CardName,                                           
  CASE T0.Closed WHEN 'N' THEN 'ABERTO' WHEN 'Y' THEN 'FECHADO' END STATUS, 
  CASE  WHEN T6.QryGroup9='Y'THEN'DIAMANTE' WHEN T6.QryGroup10='Y'THEN'OURO' WHEN T6.QryGroup11='Y'THEN'PRATA' WHEN T6.QryGroup12='Y'THEN'BRONZE' else 'OUTRAS' end 'Caracteristica PN'   
 ,CASE  WHEN T6.QryGroup15 ='Y' THEN 'IMPLANTA플O'
		WHEN T6.QryGroup16 ='Y' THEN 'IMPLANTA플O'
		WHEN T6.QryGroup17 ='Y' THEN 'IMPLANTA플O'
		WHEN T6.QryGroup18 ='Y' THEN 'CONTINUIDADE'
		WHEN T6.QryGroup19 ='Y' THEN 'CONTINUIDADE'
		WHEN T6.QryGroup20 ='Y' THEN 'CONTINUIDADE'
  END 'EST핯IO'
-- ,T4.Name
-- ,T1.U_NAME
 ,'Responsavel Pedg' = (T7.firstName +' '+T7.lastName)
 ,T6.U_LGO_PARC_IMPLE AS 'PARC/IMPL'
 ,T6.CITY
 ,T6.COUNTRY
 ,T6.STATE1
 , 'ESTADAO' = T8.NAME
FROM OCLG T0                                                                  
--  JOIN OUSR T1 ON T0.AttendUser = T1.USERID                                
--  JOIN OCLS T4 ON T0.CntctSbjct = T4.Code                                  
  JOIN OCRD T6 ON T0.CardCode = T6.CardCode    
  JOIN OHEM T7 ON T6.U_LGO_CodRespPed = T7.empID  
  JOIN OCST T8 ON T6.State1 = T8.Code                    
WHERE                                                                         
  T6.CardType = 'C'                                                     
 AND T6.CardCode NOT IN ('C00265','C00266')                                
 AND( QryGroup1 = 'Y' OR QryGroup14 = 'Y')                                 
 AND T0.inactive = 'N'