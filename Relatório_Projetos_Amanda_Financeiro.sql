AMANDA

SELECT 
	T0.NUMBER AS 'N° da Transaçâo',
	T0.BaseRef AS 'Doc Base',
	T0.RefDate AS 'Data de Lançamento',
	T0.TaxDate AS 'Data do Documento',
	T0.DueDate AS 'Data de Vencimento',
	T1.ShortName AS 'Cta.contáb./cód.PN',
	T1.ContraAct AS 'Conta de ContraPartida',
	T2.CardName as 'Nome PN',
	T3.Project as 'Projeto',
	T3.OcrCode AS 'Regra de distribuição',
	t3.Dscription as 'Descrição', 
	cast(t3.Price as decimal(10,2)) as 'Preço'

	FROM OJDT T0
	INNER JOIN JDT1 T1 ON T0.Ref1 = T1.Ref1
						and t0.LocTotal = t1.Credit
	INNER JOIN OCRD T2 ON T1.ShortName = T2.CARDCODE
	INNER JOIN PCH1 T3 ON T1.Ref1 = cast(T3.DocEntry as nvarchar)
	
	
	
order by T3.Project