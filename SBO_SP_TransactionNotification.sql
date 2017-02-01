USE [SBOPRODEI]
GO
/****** Object:  StoredProcedure [dbo].[SBO_SP_TransactionNotification]    Script Date: 01/02/2017 13:20:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER proc [dbo].[SBO_SP_TransactionNotification] 

@object_type nvarchar(20), 				-- SBO Object Type
@transaction_type nchar(1),			-- [A]dd, [U]pdate, [D]elete, [C]ancel, C[L]ose
@num_of_cols_in_key int,
@list_of_key_cols_tab_del nvarchar(255),
@list_of_cols_val_tab_del nvarchar(255)

AS

begin

-- Return values
declare @error  int				-- Result (0 for no error)
declare @error_message nvarchar (200) 		-- Error string to be displayed
select @error = 0
select @error_message = N'Ok'

--------------------------------------------------------------------------------------------------------------------------------

--	ADD	YOUR	CODE	HERE

--------------------------------------------------------------------------------------------------------------------------------

-- AddOn B1Plus - Início

				Exec LG_TransactionNotification
					 @object_type =  @object_type, 				
                     @transaction_type = @transaction_type ,			
                     @num_of_cols_in_key = @num_of_cols_in_key,
                     @list_of_key_cols_tab_del = @list_of_key_cols_tab_del,
                     @list_of_cols_val_tab_del = @list_of_cols_val_tab_del,
					 @error = @error OUTPUT,
					 @error_message = @error_message OUTPUT
					 
-- AddOn B1Plus - Fim


-- Add B1PlusFiscal - Início

			Exec LG_BloqueioFiscal_proc
						@object_type =  @object_type, 				
                     	@transaction_type = @transaction_type ,			
                     	@num_of_cols_in_key = @num_of_cols_in_key,
                     	@list_of_key_cols_tab_del = @list_of_key_cols_tab_del,
                     	@list_of_cols_val_tab_del = @list_of_cols_val_tab_del,
						@error = @error OUTPUT,
						@error_message = @error_message OUTPUT

-- Addon B1PlusFiscal - FIM


-- AddOn B1PlusNFe - Início
	       Exec LG_NFeTransactionNotification
					 @object_type				= @object_type, 				
                     @transaction_type			= @transaction_type ,			
                     @num_of_cols_in_key		= @num_of_cols_in_key,
                     @list_of_key_cols_tab_del	= @list_of_key_cols_tab_del,
                     @list_of_cols_val_tab_del	= @list_of_cols_val_tab_del,
				     @error						= @error OUTPUT,
				     @error_message				= @error_message OUTPUT
-- AddOn B1PlusNFe - Fim

--travar atividades
--if @object_type = '33' and @transaction_type in ('A','U')
--begin
--	--if ((select count(*) from OCLG where ClgCode = @list_of_cols_val_tab_del and isnull(U_LGO_SAP,'') = '') >0)
--	--begin
--	Set @error = 1
--	set @error_message = 'Atividades em Manutenção pela Lago Consultoria - conforme solicitação da Camila Cury!'
--end

--Alteração: Rebecka
---Data: 07/06/2016

------Variaveis ------
declare  @CardType AS CHAR(1),
			@CardName VARCHAR(100),
			@CardFName VARCHAR(100),
			@Phone1 VARCHAR(20),
			@Celular VARCHAR(50),
			@Codepn VARCHAR(100),
		    @Grupo VARCHAR(20),
			@email VARCHAR(100),
			@cpf1 varchar(20),
			@cnpj1 varchar(20)
		
			select 
				@CardType = cardtype,
				@CardName = CardName,
				@CardFName = CardFName,
				@Phone1 = Phone1,
				@Celular = Cellular,
				@Codepn = CardCode,
				@email=E_Mail
										from OCRD WITH(nolock)
		where cardcode = @list_of_cols_val_tab_del  
--		-- Validação do cadastro de PN
	IF(@object_type in ('2') AND @transaction_type in ('A', 'U')) 
	BEGIN 

--	-- valida Nome do PN
					IF(ISNULL(@CardName,'') = '') AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN001) - Nome do PN deve ser preenchido'
						SELECT @error, @error_message
						RETURN
					END
				
					-- valida Nome fantasia do PN
					IF(ISNULL(@CardFName,'') = '') AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN002) - Nome fantasia do PN deve ser preenchido'
						SELECT @error, @error_message
						RETURN
					END
--						-- ids dos endereços
					--if( not exists (select Address from CRD1 with(nolock) where CardCode = @list_of_cols_val_tab_del and AdresType = 'B' and Address = 'COBRANCA' ) )
					--BEGIN
					--	SET @Error = 1
					--	SET @Error_message = '(PN003) - O Cadastro deve possuir pelo menos um endereço de cobrança que tenha como id o texto COBRANCA'
					--	SELECT @error, @error_message
					--	RETURN
					--END
			
					-- enderenco - cobranca
					if(exists(select AddrType from CRD1 with(nolock) where CardCode = @list_of_cols_val_tab_del and AddrType is null )) AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN004) - Preencha o tipo de logradouro para o endereço'
						SELECT @error, @error_message
						RETURN
					END
			
					if(exists (select Street from CRD1 with(nolock) where CardCode = @list_of_cols_val_tab_del and Street is null))AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN005) -Preencha rua/caixa postal para o endereço'
						SELECT @error, @error_message
						RETURN
					END
			
					if(exists(select StreetNo from CRD1 with(nolock) where CardCode = @list_of_cols_val_tab_del and StreetNo is null)) AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN006) - Preencha rua n° para o endereço'
						SELECT @error, @error_message
						RETURN
					END

			
					if(exists(select Block from CRD1  with(nolock) where CardCode = @list_of_cols_val_tab_del and Block is null)) AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN007) - Preencha o bairro para o endereco'
						SELECT @error, @error_message
						RETURN
					END
--				
			
					if(exists(select City from CRD1  with(nolock) where CardCode = @list_of_cols_val_tab_del and City is null)) AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN008) - Preencha a cidade para o endereco'
						SELECT @error, @error_message
						RETURN
					END
			
					if(exists(select State from CRD1  with(nolock) where CardCode = @list_of_cols_val_tab_del and State is null)) AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN009) - Preencha o estado para o endereco'
						SELECT @error, @error_message
						RETURN
					END
			
					if(exists (select county from CRD1  with(nolock) where CardCode = @list_of_cols_val_tab_del and County is null))AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN010) - Preencha o município para o endereco'
						SELECT @error, @error_message
						RETURN
					END
			
					if(exists(select Country from CRD1  with(nolock) where CardCode = @list_of_cols_val_tab_del and Country is null))AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						SET @Error = 1
						SET @Error_message = '(PN011) - Preencha o país para o endereco'
						SELECT @error, @error_message
						RETURN
					END

						-- valida cpf_cnpj
					declare @cpf varchar(20);
					declare @cnpj varchar(20);
				
					set @cnpj = (select taxid0 from crd7  with(nolock) where cardcode = @list_of_cols_val_tab_del and Address = '' ) 
					set @cpf = (select taxid4 from crd7  with(nolock) where cardcode = @list_of_cols_val_tab_del and Address = '') 
									
					if(@cnpj is null or @cnpj = '') AND (ISNULL(@CardType,'') = 'C')
					BEGIN
						if(@cpf is null or @cpf = '') AND (ISNULL(@CardType,'') = 'C')
						BEGIN
							SET @Error = 1
							SET @Error_message = '(PN012) - CPF/CNPJ deve ser preenchido'
							SELECT @error, @error_message
							RETURN
						END
							
	---Valida Grupos PN---
	--Pessoa Fisica--
	if(exists
		(select groupcode from OCRD  with(nolock) 
			where CardCode = @list_of_cols_val_tab_del 
				and((@cpf is not null or @cpf <> '') )
				AND (GroupCode <> 115) AND (ISNULL(@CardType,'') = 'C')))
						BEGIN
						SET @Error = 1
						SET @Error_message = '(PN013) - O grupo do PN não pode ser diferente de Pessoa Física ' 
					
						SELECT @error, @error_message
						RETURN
					END

---
	if(exists
		(select groupcode from OCRD  with(nolock) 
			where CardCode = @list_of_cols_val_tab_del 
				and((@cpf is not null or @cpf <> '') )
				AND (GroupCode =115) AND (U_LGO_INDFINAL <>1 or U_LGO_INDFINAL is null) AND (ISNULL(@CardType,'') = 'C')))
						BEGIN
						SET @Error = 1
						SET @Error_message = '(PN014) - PN Pessoa Física, tem que está marcado como Consumidor Final ' 
					
						SELECT @error, @error_message
						RETURN
					END

--Pessoa Juridica--
if(exists
		(select groupcode from OCRD  with(nolock) 
			where CardCode = @list_of_cols_val_tab_del 
				and((@cnpj is not null or @cnpj <> '') )
				AND (GroupCode<>115) AND (ISNULL(@CardType,'') = 'C')))
						BEGIN
						SET @Error = 1
						SET @Error_message = '(PN015) - PN Pessoa Juridica, O grupo não pode ser Pessoa Física ' 
					
						SELECT @error, @error_message
						RETURN
					END
			end
			
	if(exists
		(select groupcode from OCRD  with(nolock) 
			where CardCode = @list_of_cols_val_tab_del 
				and((@cnpj is not null or @cnpj <> '') )
				AND (GroupCode in (102,104)) AND (U_LGO_INDFINAL <>1 or U_LGO_INDFINAL is null)   and (ISNULL(@CardType,'') = 'C')))
						BEGIN
						SET @Error = 1
						SET @Error_message = '(PN016) - PN Pessoa Juridica, para o grupo especifico deve ser marcado como consumidor final ' 
					
						SELECT @error, @error_message
						RETURN
					END
		if(exists
		(select groupcode from OCRD  with(nolock) 
			where CardCode = @list_of_cols_val_tab_del 
				and((@cnpj is not null or @cnpj <> '') )
				AND (GroupCode in (100)) AND (U_LGO_INDFINAL =1  or U_LGO_INDFINAL is null) and (ISNULL(@CardType,'') = 'C')))
						BEGIN
						SET @Error = 1
						SET @Error_message = '(PN017) - PN Pessoa Juridica, para o grupo Rev.Contribuinte NÃO deve ser marcado como consumidor final ' 
					
						SELECT @error, @error_message
						RETURN
					END
					END


------------------------------------------------------------------------------------------------------------------------
-------------------- MENU: Vendas - C/R   ------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

--Transaction contrato-chuva de vendas
--Obriga Usuario a Preencher total de Aluno (U_LG_Total)

IF @object_type = '1250000025' and @transaction_type in ('A','U')

BEGIN
  IF ((SELECT COUNT(*) FROM OOAT T0
			 WHERE T0.AbsID = @list_of_cols_val_tab_del
			 AND T0.U_LG_Total IS NULL) > 0)
	BEGIN
	 
		
		SET @error = 100;
			SET @error_message = 'Favor, habilitar campos de usuário, total de alunos obrigatorio preenchimento'
	END
	END

--Trava de contrato assinado tirada a pedido da camila cury 18/12/15 -- william
if @object_type = '1250000025' and @transaction_type in ('U')
begin
	IF (select count(*) from OOAT T0 join OCRD T1 on T0.BpCode = T1.CardCode
							where T0.AbsID = @list_of_cols_val_tab_del and
								  T1.U_LG_StatusCon <> '5' and t0.Status = 'A')>0
	begin
		set @error = 101
		set @error_message = 'Cliente não está com contrato assinado. Não é possível autorizar contrato!'
	end
End

--##Regra 102----------ALTERAÇÃO DE STATUS DO CONTRATO PERMITIDA APENAS PARA ALGUNS USUÁRIOS-----------------
--Autor: Rodrigo Zampieri - 03/06/2015	
--if @object_type = '1250000025' and @transaction_type in ('A','U')
--begin
--	IF (select count(*) from OOAT T0 join AOAT T1 on T0.AbsID = T1.AbsID
--							where T0.AbsID = @list_of_cols_val_tab_del 
--							and T1.LogInstanc = (SELECT Max(LogInstanc) FROM AOAT WHERE AbsID = @list_of_cols_val_tab_del)
--						    and T0.UserSign2 NOT IN (5,25,66,77,88,20,111,134)
--							AND t0.Status <> T1.Status)>0
--	begin
--		set @error = 102
--		set @error_message = 'Esse usuário não tem permissão para alterar o Status desse Contrato, favor solicitar para os usuários responsáveis.'
--	end
--End

--##Regra 103----------ADICIONAR CONTRATO COM O STATUS AUTORIZADO É PERMITIDO APENAS PARA ALGUNS USUÁRIOS-----------------
--Autor: Rodrigo Zampieri - 03/06/2015	
if @object_type = '1250000025' and @transaction_type in ('A')
begin
	IF (select count(*) from OOAT T0 
							where T0.AbsID = @list_of_cols_val_tab_del 
							and T0.UserSign NOT IN (5,25,66,77,88,20,134)
							AND T0.Status NOT IN ('D','F'))>0
	begin
		set @error = 103
		set @error_message = 'Esse usuário não tem permissão para preencher o Status desse Contrato com a opção Autorizado, favor solicitar para os usuários com permissão.'
	end
End



--Transaction Pedido de Venda
--Obrigatorio Contrato vinculado ao Pedido de venda a nivel de linha

IF @object_type = '17' and @transaction_type in ('A','U')

BEGIN
  IF ((SELECT COUNT(*) FROM RDR1 T0
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del and T0.ItemCode not like 'MK%'
			 AND T0.AgrNo IS NULL) > 0)
	BEGIN
	 
		
		SET @error = 104;
			SET @error_message = 'Item não encontrado no contrato do cliente!'
	END
	END

-- CAMPO DESCONTO TEM QUE ESTAR ZERADO -- solicitação rafa fin.

IF @object_type = '17' and @transaction_type in ('A','U')
	BEGIN
		IF ((SELECT COUNT(*) FROM ORDR
				WHERE DOCENTRY = @list_of_cols_val_tab_del
					AND DiscSum > 0)>0)
			BEGIN
				SET @ERROR = 789
				SET @ERROR_MESSAGE ='O campo desonto deve estar vazio'
			
		END
	END

---- UPDATE CAMPO CIDADE E ESTADO DE ACORDO COM O ENDEREÇO DE DESTINATÁRIO DO CLIENTE

IF @object_type = '17' and @transaction_type in ('A')

BEGIN
update T0
	set    T0.U_LG_CityC = T1.CityS
	FROM   ORDR T0 JOIN RDR12 T1 ON T0.DOCENTRY = T1.DOCENTRY
	WHERE T0.DocEntry = @list_of_cols_val_tab_del 
END

IF @object_type = '17' and @transaction_type in ('A')

BEGIN

update T0
	set    T0.U_LG_StateC = T1.StateS
	FROM   ORDR T0 JOIN RDR12 T1 ON T0.DOCENTRY = T1.DOCENTRY
	WHERE T0.DocEntry = @list_of_cols_val_tab_del 

END

--Verificar campos de usuario na saida de mercadoria
--Autor: Helber 
if @object_type = '60' and @transaction_type in ('A','U')

	begin
	if ((select count(*) from OIGE where DocEntry = @list_of_cols_val_tab_del and U_LG_Depar is null)> 0)
	
	begin
		set @error = 105;
		set @error_message = 'Preencher Departamento - Campo de Usuário'
	end
	end


--Verificar campos de usuario na saida de mercadoria
--Autor: Helber 
if @object_type = '60' and @transaction_type in ('A','U')

	begin
	if ((select count(*) from OIGE where docentry = @list_of_cols_val_tab_del and U_LG_Colab is null) > 0)
	
	begin
	   set @error = 106;
	   set @error_message = 'Preencher Colaborador - Campo de Usuário'
	end
end 


--Verificar campo se campo desconto no Pedido esta divergente do PN
-- Autor: Helber - 24/10/2014
-- Descomentado por William Rodrigues da Silva
--IF @object_type = '17' and @transaction_type in ('A','U')

--BEGIN
--  IF ((SELECT COUNT(*) FROM ORDR T0 join OCRD t1 on T0.CardCode = T1.CardCode
--			 WHERE T0.DocEntry = @list_of_cols_val_tab_del and
--			 T0.DiscPrcnt <> T1.Discount) > 0)
--	BEGIN
	 
		
--		SET @error = 105;
--			SET @error_message = 'Desconto aplicado no Pedido de Venda diferente do cadastro do PN'
--	END
--END


--Verificar campo se campo desconto na nota fiscal de venda esta divergente do PN
-- Autor: Helber - 24/10/2014 
-- Descomentado por William Rodrigues da Silva
--IF @object_type = '13' and @transaction_type in ('A','U')

--BEGIN
--  IF ((SELECT COUNT(*) FROM OINV T0 join OCRD t1 on T0.CardCode = T1.CardCode
--			 WHERE T0.DocEntry = @list_of_cols_val_tab_del and
--			 T0.DiscPrcnt <> T1.Discount) > 0)
--	BEGIN
	 
		
--		SET @error = 106;
--			SET @error_message = 'Desconto aplicado na Nota Fiscal de Saída diferente do cadastro do PN'
--	END
--END


--Verificar a data de entrega do pedido de Venda
--Autor: Helber - 27/10/2014

if @object_type = '17' and @transaction_type in ('A','U')

BEGIN
	if ((select count(*) FROM ORDR T0
			 where T0.DocEntry = @list_of_cols_val_tab_del and
			 T0.DocDueDate < GETDATE() +20) >0)
	BEGIN
		set @error = 107;
		SET @error_message = 'Data de Entrega menor que 20 dias! Por Favor, alterar Data de Entrega'
	END
END


-- Verificar o Frete no Pedido de Venda
-- Autor: Helber - 27/10/2014

if @object_type = '17' and @transaction_type in ('A','U')

BEGIN
	if ((select count(*) FROM RDR12 T0 where T0.DocEntry = @list_of_cols_val_tab_del  and
			 isnull(T0.Incoterms,'') = '') > 0)
	BEGIN
		set @error = 108;
		SET @error_message = 'Tipo de Frete em Branco, preencher na guia Imposto'
	END
END


-- Verificar campo sujeito a imposto = Nao NF
-- Helber
if @object_type = '13' and @transaction_type in ('A','U')

BEGIN
	if ((select count(*) FROM INV1 T0 where T0.DocEntry = @list_of_cols_val_tab_del  and
			 T0.TaxStatus <> 'Y' ) > 0)
	BEGIN
		set @error = 109;
		SET @error_message = 'Alterar campo Sujeito a Imposto para SIM!'
	END

--##Regra 120 Verifica se o preço da Nota Fiscal de Saída é o mesmo da lista de preço do Cadastro do PN - Chamado 30242.
--Rodrigo Zampieri 31/08/2015

	If (select count(*) FROM INV1 A 
						JOIN OINV B ON A.DocEntry = B.DocEntry
						JOIN OCRD C ON B.CardCode = C.CardCode
						JOIN ITM1 D ON A.ItemCode = D.ItemCode AND C.ListNum = D.PriceList
						where A.DocEntry = @list_of_cols_val_tab_del
						AND A.PriceBefDi <> D.Price
						AND B.SeqCode not in (-2,35,38) 
						AND B.UserSign2 not in (5,9,16,96)) > 0
	BEGIN
		set @error = 120;
		SET @error_message = 'O preço unitário dos itens desse documento são diferentes da Lista de preços desse cliente, favor entrar em contato com o Financeiro.'
	END

END

--Trava para nao permitir inserir nota fiscal de saida com desconto no total
--Quando ocorrer trocar o desconto do total pelo desconto na linha
--Autor: Helber
IF @object_type = '13' and @transaction_type in ('A')
BEGIN
  IF ((SELECT COUNT(*) FROM OINV T0 
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del and
			 T0.DiscPrcnt > '0.000000') > 0)
	BEGIN
	 
		
		SET @error = 110;
			SET @error_message = 'Aplicar Desconto nas linhas do documento!'
	END
END


--Não permitir inserir PV com desconto na linha, para item marcado só imposto.
--Autor: Helber - data: 22/04/2015
--Alterado por William tirado só imposto e colocado Gratuito 11-05-16
if @object_type = '17' and @transaction_type in ('A','U')

BEGIN
	if ((select count(*) FROM RDR1 T0 where T0.DocEntry = @list_of_cols_val_tab_del  and
			 T0.FreeChrgBP = 'Y' AND T0.DiscPrcnt > 0) > 0) -- FreeChrgBP gratuito
			 --T0.TaxOnly = 'Y' AND T0.DiscPrcnt > 0) > 0) TaxOnlySó imposto
	BEGIN
		set @error = 111;
		SET @error_message = 'Existe desconto para algum item bonificado, zerar desconto na linha do item. '
	END
END
	

--################ - Esboço Pedido de Venda - ###############--                   

             IF @transaction_type in('A','U') AND @object_type = '112'
                    BEGIN
                    IF (SELECT OBJTYPE FROM ODRF WHERE DOCENTRY =  @list_of_cols_val_tab_del) IN ('13', '17')
                           BEGIN
                           --##Regra---------- Verifica se o A Utilização do Pedido é Nula
                           IF (select COUNT (*) from ODRF T0 JOIN DRF1 T1 on T1.DocEntry = T0.DocEntry
                                        WHERE T0.DocEntry = @list_of_cols_val_tab_del 
                                        AND T0.DATASOURCE = 'I'
                                        AND isnull(T1.Usage,'') = '') > 0
                                  BEGIN
                                        SET @error = 111
                                        SET @error_message = 'Documento deve ter uma Utilização'
                                  END
                           
                                  Else IF Exists(Select T0.DocEntry
                                           From DRF1 T0
                                                      JOIN ODRF T1 ON T0.DOCENTRY = T1.DOCENTRY
                                           Where T0.DOCENTRY = @list_of_cols_val_tab_del 
                                                AND T0.objtype in ('17')
                                               AND T1.DATASOURCE = 'I'
                                               And ISNULL(T0.TAXCODE,'') = '') 
                                  Begin
                                        Set @error = 112
                                        Set @error_message = 'Obrigatório informar o Código de Imposto.'
                                  End
                                  Else IF Exists(Select T0.DocEntry
                                           From DRF1 T0
                                                      JOIN ODRF T1 ON T0.DOCENTRY = T1.DOCENTRY
                                                      JOIN DRF12 T2 ON T0.DOCENTRY = T2.DOCENTRY

                                           Where T0.DOCENTRY = @list_of_cols_val_tab_del 
                                                AND T0.objtype in ('17')
                                               AND T1.DATASOURCE = 'I'
                                               And ISNULL(T2.INCOTERMS,'') = '' and (T0.Usage <> '13')) 
                                  Begin
                                        Set @error = 113
                                        Set @error_message = 'Tipo de Frete em Branco, preencher na guia Imposto'
                                  End
								  else if (select count(*) FROM DRF1 T0 where T0.DocEntry = @list_of_cols_val_tab_del  and
										T0.FreeChrgBP = 'Y' AND T0.DiscPrcnt > 0 AND T0.objtype in ('17')) > 0 -- (TaxOnly)troca de só imposto para gratuito william 11/05/16
									BEGIN
										set @error = 114;
										SET @error_message = 'Existe desconto para algum item bonificado, zerar desconto na linha do item. '
									END
									else IF (SELECT COUNT(*) FROM DRF1 T0 WHERE T0.DocEntry = @list_of_cols_val_tab_del and
											 T0.ObjType in ('17') and isnull(T0.OcrCode, '') = '')> 0
									BEGIN
										SET @error = 115;
										SET @error_message = 'Preencher Centro de Custo!'
									END
									else  IF (SELECT COUNT(*) FROM DRF1 T0
											WHERE T0.DocEntry = @list_of_cols_val_tab_del and T0.ItemCode not like 'MK%'
											AND T0.AgrNo IS NULL and T0.ObjType in ('17')) > 0
									BEGIN
	 									SET @error = 116;
										SET @error_message = 'Item não encontrado no contrato do cliente!'
								END
							END
                    END 
--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: Vendas - C/R - FIM   ------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: Contabilidade de Custo   ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

--Transaction Centro de Custo
--Obriga Preenchimento da Filial OPRC,U_LG_BPLId
IF @object_type = '61' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM OPRC T0
			 WHERE T0.PrcCode = @list_of_cols_val_tab_del and Isnull(T0.U_LG_BPLId,'')= '' and Isnull(T0.U_LG_BPLId2,'')='' ) > 0)
		BEGIN

			SET @error = 203;
			SET @error_message = 'Preenchimento obrigatório da Matriz ou Filial'
		END
	END
	
--Transaction Pedido de Compra
--Verifica se a filial é igual do centro de Custo    
IF @object_type = '22' and @transaction_type in ('A','U')

	BEGIN
		IF (SELECT COUNT(*) FROM OPOR T0 INNER JOIN POR1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			 and isnull(T1.OcrCode,'') = '' ) > 0
		BEGIN

			SET @error = 204;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

--Transaction Recebimento
--Verifica se a filial é igual do centro de Custo
IF @object_type = '20' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM OPDN T0 INNER JOIN PDN1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 205;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

--Transaction Devolução de Mercadoria
--Verifica se a filial é igual do centro de Custo
IF @object_type = '21' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM ORPD T0 INNER JOIN RPD1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 206;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

----Transaction Nota Fiscal de Entrada
----Verifica se a filial é igual do centro de Custo
IF @object_type = '18' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM OPCH T0 INNER JOIN PCH1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			 and T1.itemcode <> 'SI00001' 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 207;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

--Transaction Devolução de NF de Entrada
--Verifica se a filial é igual do centro de Custo
IF @object_type = '19' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM ORPC T0 INNER JOIN RPC1 T1 ON T0.DocEntry = T1.DocEntry
		   	 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 208;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

--Transaction Pedido de Venda		 
--Verifica se a filial é igual do centro de Custo
IF @object_type = '17' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM ORDR T0 INNER JOIN RDR1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			 and isnull(T1.OcrCode, '') = '') > 0)
		BEGIN

			SET @error = 209;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

--Transaction Entrega de Mercadoria
--Verifica se a filial é igual do centro de Custo
IF @object_type = '15' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM ODLN T0 INNER JOIN DLN1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 210;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

--Transaction Devolução de Entrega
--Verifica se a filial é igual do centro de Custo
IF @object_type = '16' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM ORDN T0 INNER JOIN RDN1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 211;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

----Transaction Nota Fiscal de Venda
----Verifica se a filial é igual do centro de Custo
IF @object_type = '13' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM OINV T0 INNER JOIN INV1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del
			 and T1.itemcode <> 'SI00001' 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 212;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END
	
--Transaction Devolução Nota Fiscal de Venda
--Verifica se a filial é igual do centro de Custo
IF @object_type = '14' and @transaction_type in ('A','U')

	BEGIN
		IF ((SELECT COUNT(*) FROM ORIN T0 INNER JOIN RIN1 T1 ON T0.DocEntry = T1.DocEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del 
			  and isnull(T1.OcrCode,'') = '' ) > 0)
		BEGIN

			SET @error = 213;
			SET @error_message = 'Preencher Centro de Custo!'
		END
	END

------FLAG SÓ IMPOSTO TEM QUE ESTA DESMARCADA E GRATUITO TEM QUE ESTA MARCADA
------WILLIAM R. SILVA 21-09-2016
IF @object_type = '14' and @transaction_type in ('A','U')
	BEGIN
		IF((SELECT COUNT (*) FROM ORIN T0
			INNER JOIN RIN1 T1 ON T0.DOCENTRY = T1.DOCENTRY
			WHERE T0.DocEntry = @list_of_cols_val_tab_del AND  T1.TaxOnly = 'Y' )>0)
				
				BEGIN
						SET @error = 800;
						SET @error_message = 'DESMARQUE SÓ IMPOSTO, E MARQUE GRATUITO'
				END
		
	END



--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: Contabilidade de Custo FIM   ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: COMPRAS A/P   ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


--Verfica se Recebimento de Mercadoria tem Pedido de compra
--Helber
IF @object_type = '20' and @transaction_type in ('A')

	BEGIN
		IF ((SELECT COUNT(*) FROM PDN1
			WHERE DocEntry = @list_of_cols_val_tab_del and ISNULL(BASEENTRY,'') = '') > 0)

		BEGIN
			SET @error = 301;
			SET @error_message = 'Recebimento não tem pedido de Compra, favor providência-lo!'
		END
	END


--Verfica se o Nota Fiscal de Entrada tem pedido de compra
--Helber
--Atualizado Rodrigo Zampieri 18.03.2015 adicionado parâmetro para desconsiderar os itens 'DE00003','DE00004','DE00005'.
--Atualizado William Silva 16.02.2016 adicionado parâmetro para desconsiderar os itens demais itens.
IF @object_type = '18' and @transaction_type in ('A')

	BEGIN
		IF ((SELECT COUNT(*) FROM PCH1 
						WHERE DocEntry = @list_of_cols_val_tab_del and ISNULL(BaseEntry,'') = ''
						AND ItemCode not in ('DE00001','DE00003','DE00004','DE00005','DE00006','DE00007',
											 'DE00008','DE00009','DE00010','DE00011','DE00012','DE00013',
											 'DE00014','DE00015','DE00016','DE00017','DE00018','DE00019',
											 'DE00020','DE00021','DE00022','DE00023','DE00024','DE00025',
											 'DE00026','DE00027','DE00028','DE00029','DE00030','DE00031',
											 'DE00032','DE00033','DE00034','DE00035','DE00036','DE00037',
											 'DE00038','DE00039','DE00040','DE00041','DE00042','DE00043',
											 'DE00044','DE00045','DE00046','DE00047','DE00048','IM00014',
											 'IMP0001','IMP0002','IMP0003','IMP0004','IMP0005','IMP0006',
											 'IMP0007','IMP0008','IMP0009','IMP0010','IMP0011','IMP0012',
											 'IMP0013','IMP0014','IMP0015','IMP0016')) > 0)

		BEGIN
			SET @error = 302;
			SET @error_message = 'Nota Fiscal de Entrada não tem pedido de compra, favor providência-lo!'
		END
	END


--Transaction Nota Fiscal de Entrada
--Valida se o Modelo é NFe, Valida se Tem XML, e Valida Chave de Acesso--
IF @object_type = '18' and @transaction_type = 'A'
BEGIN
	
	--Verifica se  nota for NF, é modelo NF-e e CT-e
	IF ((SELECT COUNT(*) FROM OPCH T0 
		 WHERE T0.DocEntry = @list_of_cols_val_tab_del AND T0.Model in ('39', '44') AND T0.SeqCode = '-2') > 0)
	BEGIN
		--Verifica se o arquivo é XML
		IF ((SELECT COUNT(*) FROM OPCH T0 LEFT JOIN ATC1 T1 ON T0.AtcEntry = T1.AbsEntry
			 WHERE T0.DocEntry = @list_of_cols_val_tab_del AND T1.FileExt = 'XML') > 0)
		BEGIN
			--verifica se chave de acesso esta diferente do Nome do Arquivo
			IF ((SELECT COUNT(*) FROM OPCH T0 LEFT JOIN ATC1 T1 ON T0.AtcEntry = T1.AbsEntry
				WHERE T0.DocEntry = @list_of_cols_val_tab_del AND  IsNULL(T0.U_chaveacesso,'') <> T1.FileName) > 0)
			BEGIN
					

				SET @error = 303;
				SET @error_message = 'Arquivo em Anexo Diferente de Extenção XML ou Chave de acesso diferente do Nome do arquivo XML'
			END
		
	  
		END -- IF ARQUIVO XML
		ELSE
		BEGIN
			SET @error = 304;
			SET @error_message ='O arquivo não é XML.'
		END -- ELSE ARQUIVO XML
	END
END


	      
--################ - Esboço Pedido de Compra - ###############--                   

		IF @transaction_type in('A','U') AND @object_type = '112'
			BEGIN
			IF (SELECT OBJTYPE FROM ODRF WHERE DOCENTRY =  @list_of_cols_val_tab_del) IN ('22')
				BEGIN
				--##Regra---------- Verifica se o A Utilização do Pedido é Nula     '1470000113', '18', '22',
				IF (select COUNT (*) from ODRF T0 JOIN DRF1 T1 on T1.DocEntry = T0.DocEntry
						WHERE T0.DocEntry = @list_of_cols_val_tab_del 
						AND isnull(T1.Usage,'') = ''
						and T0.DataSource = 'I') > 0
					BEGIN
						SET @error = 305
						SET @error_message = 'Documento deve ter uma Utilização'
					END
					Else IF Exists(Select T0.DocEntry
						   From DRF1 T0
						   Where T0.DOCENTRY = @list_of_cols_val_tab_del 
							 AND T0.objtype in ('18', '22')
							 And ISNULL(T0.TAXCODE,'') = '' and (T0.Usage <> '13')) 
					Begin
						Set @error = 306
						Set @error_message = 'Obrigatório informar o Código de Imposto.'
					END
					Else IF Exists(Select T0.DocEntry
						   From DRF1 T0
						   Where T0.DOCENTRY = @list_of_cols_val_tab_del 
							 AND T0.objtype in ('22')
							 And ISNULL(T0.Ocrcode,'') = '') 
					Begin
						Set @error = 307
						Set @error_message = 'Obrigatório informar centro de custo.'
					END
					
				END
			END	


--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: COMPRAS A/P FIM  ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: CADASTROS  ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


--Cadastro de PN deve ter caracteristica
--Autor: Helber 21/08/2014
--Caracteristica do PN - Informar se o cliente é Contrato ou Piloto
IF @object_type = '2' and @transaction_type in ('A', 'U')
BEGIN
	IF (SELECT COUNT(*) FROM OCRD
	    WHERE CardCode = @list_of_cols_val_tab_del and
		Cardtype = 'C' and QryGroup1 = 'N' and QryGroup2 = 'N' and QryGroup3 = 'N' and QryGroup4 = 'N' and QryGroup7 = 'N'and QryGroup8 = 'N'
		and QryGroup13 = 'N' and QryGroup14 = 'N' and QryGroup48 ='N' and QryGroup63 ='N' and QryGroup64 ='N' )>0
		
		BEGIN

			SET @error = 401;
			SET @error_message = 'Determinar Características do Cliente - Contrato, Piloto, Franqueado, Mantenedor, Filantrópico, Serviço, Próprio, Ex-Cliente ou Consultor EI'
		END
		end


--Verificar se o campo Projeto esta em Branco no Cadastro do PN
--Helber 29/09
IF @object_type = '2' and @transaction_type in ('A','U')  
BEGIN
             IF ((SELECT COUNT(*) FROM OCRD A 
                     WHERE A.CardCode = @list_of_cols_val_tab_del AND A.CardType = 'C'
                    AND A.ProjectCod is null ) > 0)
				
             BEGIN
             
             SET @error = 402;
             SET @error_message = 'Projeto do cliente em branco, preencher o Projeto!'
       
			end
           END


--Verificar se o campo Projeto esta em Branco no Cadastro do PN
--Helber 29/09
IF @object_type = '2' and @transaction_type in ('A','U')  
BEGIN
             IF ((SELECT COUNT(*) FROM OCRD A 
                     WHERE A.CardCode = @list_of_cols_val_tab_del AND A.CardType = 'C'
                    AND A.ProjectCod <> A.CardCode ) > 0)
				
             BEGIN
             
             SET @error = 403;
             SET @error_message = 'Projeto do cliente diferente do código do cliente!'
       
			end
 
 --##Regra 404----------ALTERAÇÃO DE CARACTERÍSTICAS PERMITIDA APENAS PARA ALGUNS USUÁRIOS-----------------
--Autor: Rodrigo Zampieri - 14/05/2015		
		
		IF (SELECT COUNT (*) FROM OCRD a
			JOIN ACRD b ON a.Cardcode = b.CardCode
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and b.LogInstanc = (SELECT Max(LogInstanc) FROM ACRD WHERE CardCode = @list_of_cols_val_tab_del)
			and a.UserSign2 not in (005,5,19,20,25,53,059,66,73,77,88,97,111,114,115,8,84,132,134,135,138)
			and (a.QryGroup1 <> b.QryGroup1	or a.QryGroup2 <> b.QryGroup2 or a.QryGroup3 <> b.QryGroup3	or a.QryGroup4 <> b.QryGroup4
			or a.QryGroup5 <> b.QryGroup5 or a.QryGroup6 <> b.QryGroup6	or a.QryGroup7 <> b.QryGroup7 or a.QryGroup8 <> b.QryGroup8
			or a.QryGroup9 <> b.QryGroup9 or a.QryGroup10 <> b.QryGroup10 or a.QryGroup11 <> b.QryGroup11 or a.QryGroup12 <> b.QryGroup12
			or a.QryGroup13 <> b.QryGroup13	or a.QryGroup15 <> b.QryGroup15	or a.QryGroup16 <> b.QryGroup16	or a.QryGroup17 <> b.QryGroup17
			or a.QryGroup18 <> b.QryGroup18	or a.QryGroup19 <> b.QryGroup19	or a.QryGroup20 <> b.QryGroup20	or a.QryGroup23 <> b.QryGroup23	
			or a.QryGroup24 <> b.QryGroup24	or a.QryGroup25 <> b.QryGroup25	or a.QryGroup26 <> b.QryGroup26	or a.QryGroup27 <> b.QryGroup27	
			or a.QryGroup28 <> b.QryGroup28	or a.QryGroup29 <> b.QryGroup29	or a.QryGroup30 <> b.QryGroup30	or a.QryGroup31 <> b.QryGroup31	
			or a.QryGroup32 <> b.QryGroup32	or a.QryGroup33 <> b.QryGroup33	or a.QryGroup34 <> b.QryGroup34	or a.QryGroup35 <> b.QryGroup35
			or a.QryGroup36 <> b.QryGroup36	or a.QryGroup37 <> b.QryGroup37	or a.QryGroup38 <> b.QryGroup38	or a.QryGroup39 <> b.QryGroup39
			or a.QryGroup40 <> b.QryGroup40	or a.QryGroup41 <> b.QryGroup41	or a.QryGroup42 <> b.QryGroup42	or a.QryGroup45 <> b.QryGroup45	
			or a.QryGroup46 <> b.QryGroup46	or a.QryGroup47 <> b.QryGroup47)
			) > 0

			BEGIN
				SET @error = 404;
				SET @error_message = 'Esse usuário não tem permissão para alterar as Características do PN, favor solicitar para os usuários responsáveis.'
			END 

--##Regra 405----------ALTERAÇÃO DE STATUS DO CONTRATO PARA ENVIADO PERMITIDA APENAS PARA ALGUNS USUÁRIOS-----------------
--Autor: Rodrigo Zampieri - 15/06/2015		
		
		IF (SELECT COUNT (*) FROM OCRD a
			JOIN ACRD b ON a.Cardcode = b.CardCode
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and b.LogInstanc = (SELECT Max(LogInstanc) FROM ACRD WHERE CardCode = @list_of_cols_val_tab_del)
			and a.UserSign2 not in (5,17,77,88,111)
			and a.U_LG_StatusCon = 4
			) > 0

			BEGIN
				SET @error = 405;
				SET @error_message = 'Esse usuário não tem permissão para alterar o status do contrato para enviado, favor solicitar para os usuários responsáveis.'
			END 
--##Regra 406----------ALTERAÇÃO DE DESCONTO, LISTA DE PREÇO OU CONDIÇÃO DE PAGAMENTO PERMITIDA APENAS PARA ALGUNS USUÁRIOS-----------------
--Autor: Rodrigo Zampieri - 29/07/2015		
		
		IF (SELECT COUNT (*) FROM OCRD a
			JOIN ACRD b ON a.Cardcode = b.CardCode
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and b.LogInstanc = (SELECT Max(LogInstanc) FROM ACRD WHERE CardCode = @list_of_cols_val_tab_del)
			and a.UserSign2 not in (5,9,17,77,111,6)
			and a.CardType <> 'L' -- alteração da trava para permitir que os demais usuarios só alterem a condições de pagamentos apenas para PN Leads.
			and (a.Discount <> b.Discount or a.ListNum <> b.ListNum or a.GroupNum <> b.GroupNum)
			) > 0

			BEGIN
				SET @error = 406;
				SET @error_message = 'Esse usuário não tem permissão para alterar o % total de desconto ou a Lista de preços ou a Condição de Pagamento, favor solicitar para os usuários responsáveis.'
			END 


END

IF @object_type = '2' and @transaction_type in ('A')  
BEGIN

--##Regra 407----------TRAVA PREENCHIMENTO DE CAMPO DE CARACTERÍSTICAS NA ADIÇÃO DO CADASTRO-----------------
--Autor: Rodrigo Zampieri - 14/05/2015

		IF (SELECT COUNT (*) FROM OCRD a
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and a.UserSign not in (005,5,19,20,25,53,66,73,77,88,97,111,114)	
			and (a.QryGroup1 <> 'N'	or a.QryGroup2 <> 'N' OR a.QryGroup3 <> 'N'	OR a.QryGroup4 <> 'N'
			OR a.QryGroup5 <> 'N' OR a.QryGroup6 <> 'N'	or a.QryGroup7 <> 'N' or a.QryGroup8 <> 'N'
			or a.QryGroup9 <> 'N' or a.QryGroup10 <> 'N' or a.QryGroup11 <> 'N' or a.QryGroup12 <> 'N' or a.QryGroup13 <> 'N'
			or a.QryGroup15 <> 'N'	or a.QryGroup16 <> 'N'	or a.QryGroup17 <> 'N'	or a.QryGroup18 <> 'N'
			or a.QryGroup19 <> 'N'	or a.QryGroup20 <> 'N'	or a.QryGroup23 <> 'N'	or a.QryGroup24 <> 'N'
			or a.QryGroup25 <> 'N'	or a.QryGroup26 <> 'N'	or a.QryGroup27 <> 'N'	or a.QryGroup28 <> 'N'
			or a.QryGroup29 <> 'N'	or a.QryGroup30 <> 'N'	or a.QryGroup31 <> 'N'	or a.QryGroup32 <> 'N'
			or a.QryGroup33 <> 'N'	or a.QryGroup34 <> 'N'	or a.QryGroup35 <> 'N'	or a.QryGroup36 <> 'N'
			or a.QryGroup37 <> 'N'	or a.QryGroup38 <> 'N'	or a.QryGroup39 <> 'N'	or a.QryGroup40 <> 'N'
			or a.QryGroup41 <> 'N'	or a.QryGroup42 <> 'N'	or a.QryGroup45 <> 'N'	or a.QryGroup46 <> 'N'
			or a.QryGroup47 <> 'N')) > 0

			BEGIN
				SET @error = 407;
				SET @error_message = 'Esse usuário não tem permissão para preencher a característica do PN, favor solicitar para os usuários responsáveis atualizarem o cadastro posteriormente.'
			END

--##Regra 408----------TRAVA CADASTRO DE PN COM STATUS DO CONTRATO COMO ENVIADO-----------------
--Autor: Rodrigo Zampieri - 15/06/2015

		IF (SELECT COUNT (*) FROM OCRD a
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and a.UserSign not in (5,17,77,111)	
			and a.U_LG_StatusCon = 4) > 0

			BEGIN
				SET @error = 408;
				SET @error_message = 'Esse usuário não tem permissão para cadastrar o PN com o status do contrato como enviado, favor solicitar para os usuários responsáveis atualizarem o cadastro posteriormente.'
			END

--##Regra 409----------TRAVA CADASTRO DE PN PARA DESCONTO, LISTA DE PREÇO E CONDIÇÃO DE PAGAMENTO-----------------
--Autor: Rodrigo Zampieri - 29/07/2015

		IF (SELECT COUNT (*) FROM OCRD a
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and a.UserSign not in (5,20,73,77,97,66,111)	
			and (a.Discount <> 0 or a.ListNum <> 1 or a.GroupNum not in(-2,15))) > 0

			BEGIN
				SET @error = 409;
				SET @error_message = 'Esse usuário não tem permissão para preencher % total de desconto ou alterar Lista de Preço ou alterar Condição de Pagamento, favor solicitar para os usuários responsáveis atualizarem o cadastro.'
			END

	
			END





--Verificar campo utilização padrao no cadastro do item
--Autor: Helber - 24/10/2014
if @object_type = '4' and @transaction_type in ('A','U')
BEGIN
	if ((select count(*) from OITM where
		 ItemCode = @list_of_cols_val_tab_del and
		 Series = '58' and
		  U_LG_Utilizacao is null) > 0)

		 BEGIN

		 set @error = 408;
		 set @error_message = 'Preencher no campo de usuário a utilização padrão do Item'

		 end
END



---Transction Preenchimento do CNPJ
--Autor: Diogo/Helber 23/10/2014
IF @object_type = '2' and @transaction_type in ('A','U') BEGIN
UPDATE A

SET A.LicTradNum = B.Taxid0

FROM OCRD A 
JOIN CRD7 B ON A.CardCode = B.CardCode

WHERE Isnull(B.Address ,'') = '' AND B.AddrType = 'S' AND A.CardCode = @list_of_cols_val_tab_del AND ISNULL(B.Taxid0,'') <> ''
END



--Não permitir cadastrar Contrato-Guarda Chuva de vendas, caso o cliente seja LEAD.
--Trava para evitar bug do SAP, uma vez cadastrado o contrato e cliente como lead, nao altera para Cliente.
--Autor: Helber - 10/02/2015
if @object_type = '1250000025' and @transaction_type in ('A')
begin
	if (select count(*) from OOAT T0 join OCRD T1 on T0.BpCode = T1.CardCode
							where T0.AbsID = @list_of_cols_val_tab_del and
								  T1.CardType = 'L')>0
	begin
	set @error = 409;
	set @error_message = 'Cliente encontra-se como Lead, alterar cadastro para Cliente'
	end
End

--Nao permitir cadastrar Lead sem CNPJ
--Helber 11/06
-- Segundo IF William, Lead CPF PF -- 17/02/16
IF @object_type = '2' and @transaction_type in ('A','U')  
BEGIN
    IF ((SELECT COUNT(*) FROM OCRD A join CRD7 B on A.CardCode = B.CardCode
                     WHERE A.CardCode = @list_of_cols_val_tab_del AND A.CardType = 'L'
					  AND A.GroupCode <> 115
					 AND isnull(B.Taxid0,'') = '' and B.AddrType = 'S') > 0)
	

--IF ((SELECT COUNT(*) FROM OCRD A join CRD7 B on A.CardCode = B.CardCode
--                     WHERE A.CardCode = @list_of_cols_val_tab_del AND A.CardType = 'L' AND A.GroupCode = 115
--					 AND isnull(B.Taxid4,'') = '' and B.AddrType = 'S') > 0)			
          BEGIN
             SET @error = 410;
             SET @error_message = 'Preencher CNPJ na guia Identificações Fiscais!'
		end

	end

---NÃO PERMITIR CNPJ DUPLICATO NO CADASTRO PN (CLIENTE OU LEAD)
------WILLIAM R. SILVA 21-09-2016

IF @object_type = '2' and @transaction_type in ('A')  
BEGIN
	DECLARE
		@CNPJI NVARCHAR(30),
		@CNPJV NVARCHAR(30),
		@PN   NVARCHAR(30)

		SET @CNPJI = (SELECT LicTradNum FROM OCRD WHERE CARDCODE = @list_of_cols_val_tab_del and GroupCode <> 118)
		set @CNPJV = (SELECT LicTradNum FROM OCRD where LicTradNum = @CNPJI AND CardType IN ('L','C'))
		
		BEGIN
		 IF (@CNPJV IS NOT NULL)
			BEGIN
				 SET @PN = (SELECT CARDCODE FROM OCRD WHERE LicTradNum = @CNPJV  AND CARDTYPE IN ('L','C'))
			     print CONCAT('CNPJ JÁ EXISTE NO PN: ', @PN)
			END
		END
END
--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: CADASTROS - FIM  ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: ATIVIDADES    ------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--DATA: 01/07/2015
--Autor: Helber

-- Bloquear inserção diferente do código.
if @object_type = 'LGOCPARIMP' and @transaction_type in ( 'A','U')
begin
	if ((select count(*) from [@LGOCPARIMP] where code <> Name) > 0)
		begin
			set @error = 501
			set @error_message = 'Codigo diferente do Nome'
		end
end


----Não permitir cadastrar atividade diferente de Reunião
IF @object_type = '33' AND @transaction_type IN ('A','U')
BEGIN
	IF ((select count(*) from OCLG where ClgCode = @list_of_cols_val_tab_del 
										and Action <> 'M') >0)
	BEGIN
		set @error = 502
		set @error_message = 'Alterar atividade para Reunião!'
	END
END


----Não perimitir atividade sem Parceria/Implementação (campo de usuario)
IF @object_type = '33' AND @transaction_type IN ('A','U')
BEGIN
	IF ((select count(*) from OCLG where ClgCode = @list_of_cols_val_tab_del 
										and ISNULL(U_LGO_PARC_IMPLE,'') = '')>0)
	BEGIN
		set @error = 503
		set @error_message = 'Preencher Atividade Por Ano da atividade!'
	END
END

--------------------------------------------------------------------------------------------------------------------------
---------------------- MENU: ATIVIDADES- FIM  -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------


-- Bloquear quantidade menor que 90% dos itens na quantidade do contrato.
-- Autor: Desenvolvimento - 28/10/2014
-- Manutenção pelo Oswaldo - 21/01/2014 para permitir solicitações avulsas após primeira cotação
-- Alterado por Rodrigo Pitta - 09/02/2015 (Chamado 26500)

if @object_type = '23' and @transaction_type = 'A'
BEGIN

DECLARE
@CardCode as nvarchar(15),
@QuantidadeContrato as decimal(19, 2),
@QuantidadeCotacao as decimal(19, 2),
@NoventaPerCentMenos as decimal(19, 2),
@ItemCode as varchar(30),
@Agrno as int
--,
--@NoventaPerCentMais as decimal(19, 2)

set @CardCode = (select CardCode from OQUT where DocEntry = @list_of_cols_val_tab_del)
set @Agrno = (select top 1 Agrno from QUT1 where DocEntry  = @list_of_cols_val_tab_del)

if (

		select 

		count(t0.DocEntry)

		from OQUT t0
		join QUT1 t1 on T0.DocEntry = t1.DocEntry
		join OAT1 t2 on T2.AgrNo = T1.Agrno

		where t0.CardCode = @CardCode
		and
		t0.CANCELED <> 'Y'
		--and
		--t0.ObjType = '23'
		and
		t0.DocEntry <> @list_of_cols_val_tab_del
		and
		T1.AgrNo = @Agrno
		--Convert(nvarchar(10), t0.DocDate, 112) between 
 
		--case when MONTH(GETDATE()) < 06 then
		--	 convert(nvarchar(4), YEAR(GETDATE())) + '0101'
		--	 else
		--	 convert(nvarchar(4), YEAR(GETDATE())) + '0601'	  
		--	  end
		--and
		--case when MONTH(GETDATE()) < 06 then
		--	 convert(nvarchar(4), YEAR(GETDATE())) + '0530'
		--	 else
		--	 convert(nvarchar(4), YEAR(GETDATE())) + '1231'	  
		--	  end


) = 0 
BEGIN

	DECLARE TransacCursor cursor dynamic for

	select 
	t1.PlanQty	,
	t2.Quantity	,
	t1.ItemCode 
	from 
	OOAT t0
	join OAT1 t1 on t0.AbsID = t1.AgrNo
	join QUT1 t2 on t1.ItemCode = t2.ItemCode and t2.Agrno = T1.AgrNo
	where t0.BpCode = @CardCode
	and t2.DocEntry = @list_of_cols_val_tab_del
	and t0.Status = 'A'
	and t1.linestatus = 'O'

	Open TransacCursor
	fetch first from TransacCursor into @QuantidadeContrato, @QuantidadeCotacao, @ItemCode

	While @@FETCH_STATUS = 0
	begin
	
		--set @NoventaPerCentMais = ((@QuantidadeContrato/100) * 10) + @QuantidadeContrato
		set @NoventaPerCentMenos = @QuantidadeContrato - ((@QuantidadeContrato/100) * 10)

		if @QuantidadeCotacao < floor(@NoventaPerCentMenos)
		BEGIN
		
			set @error = '1'
			set @error_message = 'Quantidade solicitada menor que a quantidade contratada! - Item: ' + @ItemCode 

		END
	 
		 Fetch next from TransacCursor into  @QuantidadeContrato, @QuantidadeCotacao, @ItemCode
	end

	Close TransacCursor
	Deallocate TransacCursor


END --end if


END --end if principal


--Autor: Oswaldo - data: 02/06/2015
if @object_type = '23' and @transaction_type = 'A'
begin
update QUT1 set SpecPrice = 'N' where DocEntry = @list_of_cols_val_tab_del --and TaxOnly = 'Y'
end


-- Select the return values
select @error, @error_message


------------------------------------procedure nota saida-----------------------------------------------

if @object_type = '13' and @transaction_type ='A'
BEGIN
DECLARE 
		 @PG_NOME_CLIENTE NVARCHAR (250)
		,@PG_NOMEF_CLIENTE NVARCHAR (250)
		,@PG_CARDCODE NVARCHAR(30)
		,@PG_CNPJ NVARCHAR(20)
		,@PG_LOG NVARCHAR(100)
		,@PG_RUA NVARCHAR (100)
		,@PG_NUMERO NVARCHAR(100)
		,@PG_BAIRRO NVARCHAR(100)
		,@PG_CIDADE NVARCHAR(100)
		,@PG_ESTADO NVARCHAR(100)
		,@PG_CEP NVARCHAR(100)
		,@PG_EMAIL NVARCHAR(100)
		,@PG_DATA_NOTA DATE
		,@PG_NUMERO_NOTA INT
		,@PG_NUMERO_DOC INT
		,@PG_NUMERO_DOC_BASE INT
		,@PG_SERIE NVARCHAR (25)
		,@PG_CODIGO_ITEM NVARCHAR (50)
		,@PG_DESC_ITEM NVARCHAR(60)
		,@PG_ABV_ITEM NVARCHAR(15)
		,@PG_QTD_VENDA INT
		,@PG_QTD_DEV INT
		,@PG_STATUS INT
		,@PG_CANCELED NVARCHAR(2)
		,@CONT INT
		,@LineNum INT

		SET @CONT = (SELECT COUNT(1) FROM INV1 WHERE DOCENTRY =  @list_of_cols_val_tab_del)
		SET @LineNum = 0
		

		WHILE @LineNum < @CONT
		BEGIN
				SELECT @PG_NOME_CLIENTE = T1.CARDNAME
					 , @PG_NOMEF_CLIENTE =(SELECT CARDFNAME FROM OCRD OC WHERE OC.CARDCODE = T1.CARDCODE)
					 , @PG_CARDCODE = T1.CARDCODE
					 , @PG_LOG = (SELECT ADDRTYPE FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_RUA = (SELECT STREET FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_NUMERO = (SELECT STREETNO FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_BAIRRO = (SELECT Block FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_CIDADE = (SELECT CITY FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_ESTADO = (SELECT STATE FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_CEP = (SELECT ZipCode FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_EMAIL = (SELECT E_MAIL FROM OCRD CD WHERE CD.CARDCODE = T1.CARDCODE)
					 , @PG_CNPJ = T1.LicTradNUm
					 , @PG_DATA_NOTA = T1.DOCDATE
					 , @PG_NUMERO_NOTA =  T1.SERIAL
					 , @PG_NUMERO_DOC = T1.DOCNUM
					 , @PG_NUMERO_DOC_BASE = T0.BaseEntry
					 , @PG_CODIGO_ITEM  = T0.ITEMCODE
					 , @PG_DESC_ITEM    = T0.DSCRIPTION
					 , @PG_ABV_ITEM = (SELECT FRGNNAME FROM OITM WHERE ITEMCODE = T0.ITEMCODE)
					 , @PG_QTD_VENDA = T0.QUANTITY
					 , @PG_CANCELED = T1.CANCELED
			 

					 FROM INV1  T0
					  INNER JOIN OINV T1 ON T0.DOCENTRY = T1.DOCENTRY 
					  INNER JOIN OITM T2 ON T0.ITEMCODE = T2.ITEMCODE
					  WHERE T1.DocEntry =  @list_of_cols_val_tab_del
					  and LineNum = @LineNum
					
					IF @PG_CODIGO_ITEM = (SELECT ITEMCODE FROM OITM WHERE ITEMCODE = @PG_CODIGO_ITEM AND QryGroup25 ='Y')
						BEGIN
							SET @PG_STATUS = 1;

							DECLARE 
									@QryGroup2 NVARCHAR(1),@QryGroup3 NVARCHAR(1),@QryGroup4 NVARCHAR(1), @QryGroup5 NVARCHAR(1),@QryGroup6 NVARCHAR(1),
									@QryGroup7 NVARCHAR(1),	@QryGroup8 NVARCHAR(1),	@QryGroup9 NVARCHAR(1),@QryGroup10 NVARCHAR(1),
									@QryGroup11 NVARCHAR(1),@QryGroup12 NVARCHAR(1),@QryGroup13 NVARCHAR(1),@QryGroup14 NVARCHAR(1)

		
								  SELECT @QryGroup2 = QryGroup2,@QryGroup3 = QryGroup3,@QryGroup4 = QryGroup4,@QryGroup5 =QryGroup5,@QryGroup6 =QryGroup6,@QryGroup7 =QryGroup7,
										 @QryGroup8 = QryGroup8,@QryGroup9 = QryGroup9,@QryGroup10 = QryGroup10,@QryGroup11 = QryGroup11,@QryGroup12 =QryGroup12,
										 @QryGroup13 =QryGroup13,@QryGroup14 =QryGroup14
										 FROM OITM where ItemCode = @PG_CODIGO_ITEM

										   IF (@QryGroup2 = 'Y') BEGIN SET @PG_SERIE ='2EI'   END 
										   IF (@QryGroup3 = 'Y') BEGIN SET @PG_SERIE ='1EF'   END 
										   IF (@QryGroup4 = 'Y') BEGIN SET @PG_SERIE ='2EF'   END 
										   IF (@QryGroup5 = 'Y') BEGIN SET @PG_SERIE ='3EF'   END 
										   IF (@QryGroup6 = 'Y') BEGIN SET @PG_SERIE ='4EF'   END 
										   IF (@QryGroup7 = 'Y') BEGIN SET @PG_SERIE ='5EF'   END 
										   IF (@QryGroup8 = 'Y') BEGIN SET @PG_SERIE ='6EF'   END 
										   IF (@QryGroup9 = 'Y') BEGIN SET @PG_SERIE ='7EF'   END 
										   IF (@QryGroup10 = 'Y') BEGIN SET @PG_SERIE ='8EF'  END 
										   IF (@QryGroup11 = 'Y') BEGIN SET @PG_SERIE ='9EF'  END 
										   IF (@QryGroup12 = 'Y') BEGIN SET @PG_SERIE ='1EM'  END 
										   IF (@QryGroup13 = 'Y') BEGIN SET @PG_SERIE ='2EM'  END 
										   IF (@QryGroup14 = 'Y') BEGIN SET @PG_SERIE ='3EM'  END 

							     		    INSERT INTO PRODUTOS_GENIOS (PG_NOME_CLIENTE,PG_NOMEF_CLIENTE,PG_CARDCODE,PG_CNPJ,PG_LOG,PG_RUA,PG_NUMERO,PG_BAIRRO,PG_CIDADE,PG_ESTADO,PG_CEP,PG_EMAIL,PG_DATA_NOTA,PG_NUMERO_NOTA,PG_NUMERO_DOC,PG_NUMERO_DOC_BASE,PG_SERIE,PG_CODIGO_ITEM, PG_DESC_ITEM,PG_ABV_ITEM,PG_QTD_VENDA,PG_QTD_DEV,PG_QTD_CONF,PG_STATUS,PG_CANCELED) 
									        VALUES (@PG_NOME_CLIENTE,@PG_NOMEF_CLIENTE,@PG_CARDCODE,@PG_CNPJ,@PG_LOG ,@PG_RUA,@PG_NUMERO,@PG_BAIRRO,@PG_CIDADE,@PG_ESTADO,@PG_CEP,@PG_EMAIL,@PG_DATA_NOTA,@PG_NUMERO_NOTA,@PG_NUMERO_DOC,@PG_NUMERO_DOC_BASE,@PG_SERIE,@PG_CODIGO_ITEM,@PG_DESC_ITEM,@PG_ABV_ITEM,@PG_QTD_VENDA,0,@PG_QTD_VENDA,@PG_STATUS,@PG_CANCELED);
											
								END
										SET @LineNum = @LineNum +1;
							END	
		END

------------------------------------procedure nota dev-----------------------------------------------


if @object_type = '14' and @transaction_type ='A'
BEGIN

		SET @CONT = (SELECT COUNT(1) FROM RIN1 WHERE DOCENTRY =  @list_of_cols_val_tab_del)
		SET @LineNum = 0
		

		WHILE @LineNum < @CONT
		BEGIN
				SELECT @PG_NOME_CLIENTE = T1.CARDNAME
					 , @PG_NOMEF_CLIENTE =(SELECT CARDFNAME FROM OCRD OC WHERE OC.CARDCODE = T1.CARDCODE)
					 , @PG_CARDCODE = T1.CARDCODE
					 , @PG_LOG = (SELECT ADDRTYPE FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_RUA = (SELECT STREET FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_NUMERO = (SELECT STREETNO FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_BAIRRO = (SELECT Block FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_CIDADE = (SELECT CITY FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_ESTADO = (SELECT STATE FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_CEP = (SELECT ZipCode FROM CRD1 C1 WHERE C1.CARDCODE = T1.CARDCODE and C1.adresType = 'S')
					 , @PG_EMAIL = (SELECT E_MAIL FROM OCRD CD WHERE CD.CARDCODE = T1.CARDCODE)
					 , @PG_CNPJ = T1.LicTradNUm
					 , @PG_DATA_NOTA = T1.DOCDATE
					 , @PG_NUMERO_NOTA =  T1.SERIAL
					 , @PG_NUMERO_DOC = T1.DOCNUM
					 , @PG_NUMERO_DOC_BASE = T0.BaseEntry
					 , @PG_CODIGO_ITEM  = T0.ITEMCODE
					 , @PG_DESC_ITEM    = T0.DSCRIPTION
					 , @PG_ABV_ITEM = (SELECT FRGNNAME FROM OITM WHERE ITEMCODE = T0.ITEMCODE)
					 , @PG_QTD_DEV = T0.QUANTITY
					 , @PG_CANCELED = T1.CANCELED
			 

					 FROM RIN1  T0
					  INNER JOIN ORIN T1 ON T0.DOCENTRY = T1.DOCENTRY 
					  INNER JOIN OITM T2 ON T0.ITEMCODE = T2.ITEMCODE
					  WHERE T1.DocEntry =  @list_of_cols_val_tab_del
					  and LineNum = @LineNum
					
					IF @PG_CODIGO_ITEM = (SELECT ITEMCODE FROM OITM WHERE ITEMCODE = @PG_CODIGO_ITEM AND QryGroup25 ='Y')
						BEGIN
							SET @PG_STATUS = 2;

								
								  SELECT @QryGroup2 = QryGroup2,@QryGroup3 = QryGroup3,@QryGroup4 = QryGroup4,@QryGroup5 =QryGroup5,@QryGroup6 =QryGroup6,@QryGroup7 =QryGroup7,
										 @QryGroup8 = QryGroup8,@QryGroup9 = QryGroup9,@QryGroup10 = QryGroup10,@QryGroup11 = QryGroup11,@QryGroup12 =QryGroup12,
										 @QryGroup13 =QryGroup13,@QryGroup14 =QryGroup14
										 FROM OITM where ItemCode = @PG_CODIGO_ITEM

										   IF (@QryGroup2 = 'Y') BEGIN SET @PG_SERIE ='2EI'   END 
										   IF (@QryGroup3 = 'Y') BEGIN SET @PG_SERIE ='1EF'   END 
										   IF (@QryGroup4 = 'Y') BEGIN SET @PG_SERIE ='2EF'   END 
										   IF (@QryGroup5 = 'Y') BEGIN SET @PG_SERIE ='3EF'   END 
										   IF (@QryGroup6 = 'Y') BEGIN SET @PG_SERIE ='4EF'   END 
										   IF (@QryGroup7 = 'Y') BEGIN SET @PG_SERIE ='5EF'   END 
										   IF (@QryGroup8 = 'Y') BEGIN SET @PG_SERIE ='6EF'   END 
										   IF (@QryGroup9 = 'Y') BEGIN SET @PG_SERIE ='7EF'   END 
										   IF (@QryGroup10 = 'Y') BEGIN SET @PG_SERIE ='8EF'  END 
										   IF (@QryGroup11 = 'Y') BEGIN SET @PG_SERIE ='9EF'  END 
										   IF (@QryGroup12 = 'Y') BEGIN SET @PG_SERIE ='1EM'  END 
										   IF (@QryGroup13 = 'Y') BEGIN SET @PG_SERIE ='2EM'  END 
										   IF (@QryGroup14 = 'Y') BEGIN SET @PG_SERIE ='3EM'  END 

										    INSERT INTO PRODUTOS_GENIOS (PG_NOME_CLIENTE,PG_NOMEF_CLIENTE,PG_CARDCODE,PG_CNPJ,PG_LOG,PG_RUA,PG_NUMERO,PG_BAIRRO,PG_CIDADE,PG_ESTADO,PG_CEP,PG_EMAIL,PG_DATA_NOTA,PG_NUMERO_NOTA,PG_NUMERO_DOC,PG_NUMERO_DOC_BASE,PG_SERIE, PG_CODIGO_ITEM, PG_DESC_ITEM,PG_ABV_ITEM,PG_QTD_VENDA,PG_QTD_DEV,PG_QTD_CONF,PG_STATUS,PG_CANCELED) 
									        VALUES (@PG_NOME_CLIENTE,@PG_NOMEF_CLIENTE,@PG_CARDCODE,@PG_CNPJ,@PG_LOG ,@PG_RUA,@PG_NUMERO,@PG_BAIRRO,@PG_CIDADE,@PG_ESTADO,@PG_CEP,@PG_EMAIL,@PG_DATA_NOTA,@PG_NUMERO_NOTA,@PG_NUMERO_DOC,@PG_NUMERO_DOC_BASE,@PG_SERIE,@PG_CODIGO_ITEM,@PG_DESC_ITEM,@PG_ABV_ITEM,0,@PG_QTD_DEV,@PG_QTD_DEV,@PG_STATUS,@PG_CANCELED);
										

								END
										SET @LineNum = @LineNum +1;
							END	
		END



end


















