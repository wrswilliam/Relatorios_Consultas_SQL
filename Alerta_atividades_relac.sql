-- BEGIN
--TABELA AUXILIAR ALERTA_Attvd_Rel

CREATE TABLE  ALERTA_Attvd_Rel
		( ATIVIDADE INT PRIMARY KEY NOT NULL,
		  CLIENTE NVARCHAR(255),
		  DETALHES NVARCHAR (255),
		  DT_INIC_ATIVI DATE,
		  DT_TERM_ATIVI DATE,
		  ATENDENTE NVARCHAR (255) )
--END

-- BEGIN
--INSERT ATIVIDADE PARA PESSOAS DO RELACIONAMENTO
insert into ALERTA_Attvd_Rel (ATIVIDADE,CLIENTE,DETALHES,DT_INIC_ATIVI,DT_TERM_ATIVI,ATENDENTE)  (

SELECT 
	   T0.ClgCode
	  ,T0.CARDCODE
	  ,T0.Details
	  ,T0.Recontact
	  ,T0.endDate
	  ,T1.U_NAME
	FROM OCLG T0
	INNER JOIN OUSR T1 ON T1.INTERNAL_K = cast(T0.AttendUser as nvarchar)
	INNER JOIN OHEM T2 ON T2.userId = INTERNAL_K
	WHERE Closed = 'N'
	AND inactive = 'N'
	AND T2.dept = 5
	and t0.U_LGO_PARC_IMPLE >= '2016/2017'

	)
--END

--BEGIN
--TRANSACTION ALERTA ATIVIDADES RELACIONAMENTO
--alerta atividades relacionamento
if @object_type = '33' and @transaction_type  in ('A','U')
BEGIN
	DECLARE
	 @COD_ATT INT
	,@COD_CLI NVARCHAR(255)
	,@DETALHES NVARCHAR(255)
	,@DT_INC DATE
	,@DT_TER DATE
	,@ATEND NVARCHAR(255)
	,@DEP INT
	,@FECHADO NVARCHAR(255)
	,@INACTIVE NVARCHAR(255)
	,@A INT

	SET @COD_ATT = (SELECT AT0.CLGCODE  FROM OCLG AT0 WHERE AT0.ClgCode = @list_of_cols_val_tab_del)
	SET @COD_CLI = (SELECT AT1.CardCode  FROM OCLG AT1 WHERE AT1.ClgCode = @list_of_cols_val_tab_del)
	SET @FECHADO = (SELECT AT2.CLOSED  FROM OCLG AT2 WHERE AT2.ClgCode = @list_of_cols_val_tab_del)
	SET @INACTIVE = (SELECT AT3.inactive  FROM OCLG AT3 WHERE AT3.ClgCode = @list_of_cols_val_tab_del)
	SET @DETALHES = (SELECT AT4.Details  FROM OCLG AT4 WHERE AT4.ClgCode = @list_of_cols_val_tab_del)
	SET @DT_INC = (SELECT AT5.Recontact  FROM OCLG AT5 WHERE AT5.ClgCode = @list_of_cols_val_tab_del)
	SET @DT_TER = (SELECT AT6.endDate  FROM OCLG AT6 WHERE AT6.ClgCode = @list_of_cols_val_tab_del)
	SET @ATEND = (select T1.U_NAME from OCLG T0  INNER JOIN OUSR T1 ON T1.INTERNAL_K = cast(T0.AttendUser as nvarchar) INNER JOIN OHEM T2 ON T2.userId = INTERNAL_K where ClgCode = @list_of_cols_val_tab_del)
	SET @DEP = (select T2.dept from OCLG T0  INNER JOIN OUSR T1 ON T1.INTERNAL_K = cast(T0.AttendUser as nvarchar) INNER JOIN OHEM T2 ON T2.userId = INTERNAL_K where ClgCode = @list_of_cols_val_tab_del)
	
	IF (@DEP = 5 AND @FECHADO = 'N' AND @INACTIVE = 'N')
		
		BEGIN
			SET @A =(select COUNT(*) from ALERTA_Attvd_Rel WHERE ATIVIDADE = @COD_ATT)
				IF @A = 0 
					BEGIN
						INSERT INTO ALERTA_Attvd_Rel (ATIVIDADE,CLIENTE,DETALHES,DT_INIC_ATIVI,DT_TERM_ATIVI,ATENDENTE)
						VALUES (@COD_ATT,@COD_CLI,@DETALHES,@DT_INC,@DT_TER,@ATEND)
					END
				ELSE
					BEGIN
						UPDATE ALERTA_Attvd_Rel SET CLIENTE = @COD_CLI
												   ,DETALHES = @DETALHES
												   ,DT_INIC_ATIVI = @DT_INC
												   ,DT_TERM_ATIVI = @DT_TER
												   ,ATENDENTE = @ATEND
					END
		END

		ELSE IF ((@DEP <> 5 AND (@FECHADO = 'Y' AND @INACTIVE = 'N') OR (@FECHADO = 'N' AND @INACTIVE = 'Y')) OR
			     (@DEP <> 5 AND (@FECHADO = 'N' AND @INACTIVE = 'N') OR (@FECHADO = 'N' AND @INACTIVE = 'N')) OR
				 (@DEP = 5 AND  (@FECHADO = 'Y' AND @INACTIVE = 'N') OR (@FECHADO = 'N' AND @INACTIVE = 'Y')))
		BEGIN 
				DELETE ALERTA_Attvd_Rel WHERE ATIVIDADE = @COD_ATT
		END

END	 
-- END
