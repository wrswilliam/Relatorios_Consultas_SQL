CREATE TABLE RELATORIO_AMANDA (
		NUMBER INT,
		BaseRef INT,
		RefDate DATE,
		TaxDate DATE,
		DueDate DATE,
		ShortName NVARCHAR(55),
		ContraAct NVARCHAR(55),
		CardName NVARCHAR(255),
		Project NVARCHAR(55),
		OcrCode NVARCHAR(55),
		Dscription NVARCHAR(500), 
		Price  DECIMAL(10,2)
	)
	
DECLARE 
		--VARIAVEIS PARA CONTROLE
		@TIPO INT,
		@QTD INT,
		@CONT INT,
		--VARIAVEIS PARA TABELA
		@NUMBER INT,
		@BaseRef INT,
		@RefDate DATE,
		@TaxDate DATE,
		@DueDate DATE,
		@ShortName NVARCHAR(55),
		@ContraAct NVARCHAR(55),
		@CardName NVARCHAR(255),
		@Regra NVARCHAR(55),
		@OcrCode NVARCHAR(55),
		@Dscription NVARCHAR(500), 
		@Price  DECIMAL(10,2)
 BEGIN 

	SET @QTD = (SELECT MAX(TRANSID) as qtd FROM OJDT)

	SET @CONT =1

	WHILE @CONT <= @QTD
	BEGIN
			SET @TIPO = (SELECT TransType FROM OJDT WHERE TransId =  @CONT) 
			
			
					IF @TIPO  =  -3 --SALDO FINAL

					BEGIN
						SELECT  @NUMBER  =  T0.NUMBER
							   ,@BaseRef =  T0.BaseRef 
							   ,@RefDate =  T0.RefDate 
							   ,@TaxDate =  T0.TaxDate 
							   ,@DueDate =  T0.DueDate 
							   ,@ShortName = T1.ShortName
							   ,@ContraAct = T1.ContraAct 
							   ,@CardName = T2.CardName
							   ,@Regra = T1.ProfitCode
							   ,@Dscription = NULL
							   ,@Price = NULL
					    FROM OJDT T0
						INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
											AND t0.LocTotal = t1.Credit
						INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
						
						INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
											VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					END;
						
					 IF @TIPO = 13 --A/R Invoice

					 BEGIN
						SELECT  @NUMBER  =  T0.NUMBER
							   ,@BaseRef =  T0.BaseRef 
							   ,@RefDate =  T0.RefDate 
							   ,@TaxDate =  T0.TaxDate 
							   ,@DueDate =  T0.DueDate
							   ,@ShortName = T1.ShortName
							   ,@ContraAct = T1.ContraAct 
							   ,@CardName = T2.CardName
							   ,@Regra = T3.OcrCode 
							   ,@Dscription = t3.Dscription 
							   ,@Price = t3.Price 
						FROM OJDT T0
						INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
											AND t0.LocTotal = t1.Credit
						INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
						INNER JOIN INV1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

						INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
											VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;

					
					IF @TIPO = 14 --A/R Credit Memo
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN RIN1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;
			
			
					IF @TIPO = 15 --Delivery
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN DLN1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;
			
						
			
					IF @TIPO = 16 --DEVOLU?O
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN RDN1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;
						
					IF @TIPO = 18 --DEVOLU?O
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN PCH1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;			
			
					IF @TIPO = 19 --DEVOLU?O NOTA DE ENTRADA
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN RPC1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;			

					IF @TIPO = 20 --recebimento de mercadoria
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN PDN1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;		

					IF @TIPO = 21 --DEVOLU?O  de mercadoria
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN RPD1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;		

					IF @TIPO = 24 --CONTAS A RECEBER
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T5.OcrCode 
								   ,@Dscription = t5.Dscription 
								   ,@Price = t5.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN RCT2 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
							INNER JOIN OINV T4 ON T4.DocEntry =T3.DocEntry
							INNER JOIN INV1 T5 ON T5.DocEntry = T4.DOCENTRY 
							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	

					IF @TIPO = 30 --LC
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T1.ProfitCode
								   ,@Dscription = NULL
								   ,@Price = NULL
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	
					
					IF @TIPO = 46 --CONTAS A PAGAR
			
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T5.OcrCode 
								   ,@Dscription = t5.Dscription 
								   ,@Price = t5.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN VPM2 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
							INNER JOIN OPCH T4 ON T4.DocNum=T3.DocEntry
							INNER JOIN PCH1 T5 ON T5.DocEntry = T4.DOCENTRY 
							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	

					IF @TIPO = 59 --ENTRADA DE MERCADORIA
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN IGN1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;				

					IF @TIPO = 60 --Saida DE MERCADORIA
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN IGE1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;

					IF @TIPO = 69 --DESPESAS DE IMPORTA?O
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.PriceFOB 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN IPF1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;


					IF @TIPO = 162 --REAVALIA?O DE ESTOQUE
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = t3.Dscription 
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN MRV1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;

					IF @TIPO = 202 --ORDEM DE PRODU?O
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T4.ItemName
								   ,@Price = NULL
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN WOR1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
							INNER JOIN OITM T4 ON T3.ITEMCODE = T4.ITEMCODE

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;

					IF @TIPO = 203 --ADIANTAMENTO DE CLIENTE
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T3.Dscription
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN DPI1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
						

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;


					IF @TIPO = 204 --ADIANTAMENTO DE FORNECEDOR
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T3.Dscription
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN DPO1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
						

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;

					IF @TIPO = 10000071 --LAN?MENTO DE ESTOQUE
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T4.ItemName
								   ,@Price = t3.Price 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN IQR1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
						    INNER JOIN OITM T4 ON T3.ITEMCODE = T4.ITEMCODE

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	

					IF @TIPO = 1470000049 --CAPITALIZA?O
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T4.ItemName
								   ,@Price = t3.LineTotal
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN ACQ1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
						    INNER JOIN OITM T4 ON T3.ITEMCODE = T4.ITEMCODE

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	

					IF @TIPO = 1470000075 --DEPRECIA?O MANUAL
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T4.ItemName
								   ,@Price = t3.LineTotal 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN MDP1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
						    INNER JOIN OITM T4 ON T3.ITEMCODE = T4.ITEMCODE

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	


					IF @TIPO = 1470000094 --BAIXA
					 BEGIN
							SELECT  @NUMBER  =  T0.NUMBER
								   ,@BaseRef =  T0.BaseRef 
								   ,@RefDate =  T0.RefDate 
								   ,@TaxDate =  T0.TaxDate 
								   ,@DueDate =  T0.DueDate
								   ,@ShortName = T1.ShortName
								   ,@ContraAct = T1.ContraAct 
								   ,@CardName = T2.CardName
								   ,@Regra = T3.OcrCode 
								   ,@Dscription = T4.ItemName
								   ,@Price = t3.LineTotal 
							FROM OJDT T0
							INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
												AND t0.LocTotal = t1.Credit
							INNER JOIN OCRD T2 ON T1.ContraAct = T2.Cardcode
							INNER JOIN RTI1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
						    INNER JOIN OITM T4 ON T3.ITEMCODE = T4.ITEMCODE

							INSERT INTO RELATORIO_AMANDA (NUMBER,BaseRef,RefDate,TaxDate,DueDate,ShortName,ContraAct,CardName,Project,OcrCode,Dscription,Price)
												VALUES   (@NUMBER,@BaseRef,@RefDate,@TaxDate,@DueDate,@ShortName,@ContraAct,@CardName,@Regra,@OcrCode,@Dscription,@Price)
					 END;	

					--ELSE PRINT  ('VERIFIQUE ESSE TIPO DE TRANSA?O NO SCRIPT: ' + CAST(@TIPO AS NVARCHAR))
	
			SET @CONT = @CONT +1
		
END