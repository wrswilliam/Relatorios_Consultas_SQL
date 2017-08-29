USE [SBOPRODEI]
GO

/****** Object:  View [dbo].[GEAC_EtiquetaEntrega_vw]    Script Date: 25/07/2017 11:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*****************************************************************************
* Nome : GEAC_EtiquetaEntrega_vw
* Autor: 
* Data : 
* Descrição: Lista entregas c/respectivos pedidos e volumes
*
* -------------------------------------------------------------------------------------------
* Histórico de atualizações
* -------------------------------------------------------------------------------------------
* Data       | Descrição                                            | Autor
* -------------------------------------------------------------------------------------------
* 20/06/2017   
* Criação da VIEW
* -------------------------------------------------------------------------------------------
* 21/06/2017   
* Inserção do Volume de e Volume ate
* -------------------------------------------------------------------------------------------*/
ALTER VIEW [dbo].[GEAC_EtiquetaEntrega_vw]
as
SELECT DISTINCT
	T0.DocEntry as NroEntrega,
	Isnull(T1.BaseRef,'') as PedidoBase,
	T0.CardCode as CodCliente,
	T0.CardName as NomeCliente,
	T3.City as Cidade,
	Min(Isnull(T2.U_VolEntry,'')) as VolDe,
	Max(Isnull(T2.U_VolEntry,'')) as VolAte,
	Isnull(T4.Carrier,'') as CodTransp
FROM 
	ODLN T0
LEFT JOIN DLN1 T1 ON T1.DocEntry = T0.DocEntry
LEFT JOIN [@LGOLDWMSCONF] T2 ON T2.U_OrderEntry  = T1.BaseRef  --T0.DocEntry LIGAÇÃO TABELA ERRADO, AJUSTE WILLIAM 25/07/17
LEFT JOIN CRD1 T3 ON T3.CardCode = T0.CardCode and T3.Address = T0.ShipToCode and T3.AdresType = 'S'
LEFT JOIN DLN12 T4 ON T4.DocEntry = T0.DocEntry 
Group by T0.DocEntry,T1.BaseRef,T0.CardCode,T0.CardName,T3.City,T4.Carrier 

GO


