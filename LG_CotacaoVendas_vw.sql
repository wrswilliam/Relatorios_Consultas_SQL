USE [SBOPRODEI]
GO

/****** Object:  View [dbo].[LG_CotacaoVendas_vw]    Script Date: 02/02/2017 09:44:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[LG_CotacaoVendas_vw]
AS

SELECT	Distinct --add william, pois estava trazendo itens duplicatos 02/02/17 09:47
		'NroCotacao'	= T0.DocNum, 
		'NomeEmpresa'	= isnull(T13.BPLName,t2.CompnyName),
		'Utilizacao'	= T12.Usage,  
		'Emissao'		= T0.DocDate, 
		'Vencto'		= T0.DocDueDate, 
		'Cliente'		= T0.CardCode, 
		'Nome'			= T0.CardName,
		'BairroEmp'		= isnull(T3.Block,T13.Block),
		'CidadeEmp'		= isnull(T3.City,T13.City),  
		'EndEmp'		= isnull(T3.Street,T13.Street),
		'NroEmp'		= isnull(T3.StreetNo,T13.StreetNo),
		'UFEmp'			= isnull(T3.State,T13.State),  
		'CEPEmp'		= isnull(T3.ZipCode,T13.ZipCode),
		'TelEmp'		= T2.Phone1,
		'CNPJEmp'		= T2.TaxIdNum,   
		'TipoEnd'		= T5.AddrType,
		'RuaCliente'	= T5.Street,
		'NroCliente'	= T5.StreetNo,
		'BairroCliente'	= T5.Block,
		'CEPCliente'	= T5.ZipCode,
		'CidadeCliente'	= T5.City,
		'UFCliente'		= T5.State,
		'TelCliente'	= T4.Phone1,
		'CNPJCliente'	= CASE
							  WHEN (T6.TaxId0 = '' or T6.TaxId0 is null) THEN T6.TaxId4 
							  ELSE T6.TaxId0  
						  END,  
		'IECliente'		= T6.TaxId1, 
		'Repres'		= T7.SlpName, 
		'Assessor'		= T4.AgentCode, 
		'Item'			= T1.ItemCode,
		'Descr'			= T8.ItemName,  
		'Qtd'			= T1.Quantity,
		'UM'			= T1.unitMsr,
		'PercDesc'		= T1.DiscPrcnt,
		'Preco'			= T1.PriceBefDi,
		'Total'			= t1.Quantity * t1.PriceBefDi,
		'TotComDesct'	= T1.TotalSumSy, 
		'CondPgto'		= T9.PymntGroup,
		'EndEntrega'	= T0.Address2, 
		'Transp'		= T11.CardName,
		'Obs'			= T0.Comments,
		--'Rodape'		= T0.Footer, --removido por william, pois não estava sendo utilizado e não deixava utilizad a função Distinct 02/02/17 09:47
		'Imposto'		= T0.VatSumSy,
		'DocTotal'		= T0.DocTotal,
		'DocEntry'      = T0.DocEntry      
from OQUT T0
	join QUT1 T1 on T0.DocEntry			= T1.DocEntry
	join OADM T2 on T2.CompnyName		= T2.CompnyName 
	left join ADM1 T3 on T3.Street		= T3.Street 
	join OCRD T4 on T0.CardCode			= T4.CardCode 
	join CRD1 T5 on T0.CardCode			= T5.CardCode 
				and T5.Address = t4.ShipToDef AND T5.AdresType = 'S'
	join CRD7 T6 on T0.CardCode			= T6.CardCode 
				and T6.Address = t4.ShipToDef
				and (isnull(T6.TaxId0,'') <> '' or isnull(T6.TaxId4,'') <> '')
				and isnull(T6.Address,'') <> ''
	join OSLP T7 on T4.SlpCode			= T7.SlpCode 
	join OITM T8 on T1.ItemCode			= T8.ItemCode
	join OCTG T9 on T0.GroupNum			= T9.GroupNum 
	left join RDR12 T10 on T0.DocEntry	= T10.DocEntry 
	left join OCRD  T11 on T10.Carrier	= T11.CardCode 
	left join OUSG T12 on T1.Usage = T12.ID
	left join OBPL T13 on T13.BPLId = T0.BPLId 

GO


