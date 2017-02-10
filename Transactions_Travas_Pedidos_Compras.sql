--- Verifica data de compra viagem

IF @object_type ='22' AND @transaction_type = ('A')
	BEGIN
		IF(
			(SELECT COUNT(*) FROM OPOR T0 INNER JOIN POR1 T1 ON T0.DocEntry = T1.DocEntry
				WHERE T0.DocEntry = @list_of_cols_val_tab_del
					  AND (convert(date,t1.U_LGO_Data) <> convert(date,GETDATE())
					  AND T1.ITEMCODE IN ('CO00082','CO01233')))>0 )
	

	BEGIN
			SET @error = 2525
			SET @error_message = 'O PEDIDO DE VIAGEM TEM QUE SER FEITO NO DIA ATUAL'

	end
	end

---Verifica data de entrega está no prazo

IF @object_type ='22' AND @transaction_type = ('U')
		DECLARE @DATECREATE DATE
	BEGIN
	    SET @DATECREATE = (SELECT T0.CreateDate FROM OPOR T0 INNER JOIN POR1 T1 ON T0.DocEntry = T1.DocEntry
				WHERE T0.DocEntry = @list_of_cols_val_tab_del)+30

		IF((SELECT COUNT(*) FROM OPOR T0 INNER JOIN POR1 T1 ON T0.DocEntry = T1.DocEntry
				WHERE T0.DocEntry = @list_of_cols_val_tab_del
					  AND CONVERT(DATE,T0.DocDueDate) < CONVERT(DATE,@DATECREATE))>0)
	   BEGIN
	    
			SET @error = 2626
			SET @error_message = 'A DATA DE ENTREGA TEM QUE SER MAIOR QUE 30 DIAS DA DATA DE LANÇAMENTO'
		END
	END
	
	
--Transaction Pedido de Compra
--Verifica se a filial é igual do centro de Custo    
IF @object_type = '22' and @transaction_type in ('A','U')

	BEGIN
		IF (SELECT COUNT(*) FROM OPOR T0 INNER JOIN POR1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			 and isnull(T1.OcrCode,'') = '' AND t0.Confirmed = 'Y' ) > 0
		BEGIN

			SET @error = 204;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END