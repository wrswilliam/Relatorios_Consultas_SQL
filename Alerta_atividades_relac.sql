--create procedure Rel_Ativ_Relc
--AS
  DECLARE 
	 @ATT_ORIGRM INT
	,@ATT_NEXT INT
	,@ATT_OLD INT
	,@DEP INT

	SET @ATT_ORIGRM = (SELECT MAX(G0.CLGCODE) FROM OCLG G0)
	SET @ATT_NEXT = (SELECT TB1.ATIVIDADE FROM Relat_Attvd_Rel TB1)
	SET @ATT_OLD = (SELECT TB1.ATIVIDADE_OLD FROM Relat_Attvd_Rel TB1)
	SET @DEP = (select T2.dept from OCLG T0  INNER JOIN OUSR T1 ON T1.INTERNAL_K = cast(T0.AttendUser as nvarchar) INNER JOIN OHEM T2 ON T2.userId = INTERNAL_K where ClgCode = @ATT_ORIGRM)
		BEGIN
			select 
				T0.Clgcode
			   ,T0.Cardcode
			   ,T0.Recontact
			   ,T0.endDate
			   ,T0.Priority
			   ,T0.Details
			   ,T1.U_NAME

			   
			from OCLG T0
			 INNER JOIN OUSR T1 ON T1.INTERNAL_K = cast(T0.AttendUser as nvarchar)
			 INNER JOIN OHEM T2 ON T2.userId = INTERNAL_K
			  where ClgCode >= @ATT_OLD and ClgCode <= @ATT_ORIGRM
			        AND T2.dept = 5

					IF @DEP = 5
					BEGIN
						IF @ATT_ORIGRM > @ATT_NEXT
						BEGIN
							UPDATE Relat_Attvd_Rel SET ATIVIDADE = @ATT_NEXT
						END
					END
				

		END
		 

		SELECT TB1.* FROM Relat_Attvd_Rel TB1

	
		
		--CREATE TABLE Relat_Attvd_Rel
		--( ATIVIDADE INT PRIMARY KEY NOT NULL,
		--  ATIVIDADE_OLD INT )
