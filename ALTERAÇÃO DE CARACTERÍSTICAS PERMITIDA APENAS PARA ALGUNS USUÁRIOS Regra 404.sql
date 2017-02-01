--##Regra 404----------ALTERAÇÃO DE CARACTERÍSTICAS PERMITIDA APENAS PARA ALGUNS USUÁRIOS-----------------
--Autor: Rodrigo Zampieri - 14/05/2015		
		
		IF (SELECT COUNT (*) FROM OCRD a
			inner JOIN ACRD b ON a.Cardcode = b.CardCode
			WHERE a.CardCode = @list_of_cols_val_tab_del
			and b.LogInstanc = (SELECT Max(LogInstanc) FROM ACRD WHERE CardCode = @list_of_cols_val_tab_del)
			and a.UserSign2 not in (5,23,66,77,88) 
			and (a.QryGroup1 <> b.QryGroup1	or a.QryGroup2 <> b.QryGroup2 or a.QryGroup3 <> b.QryGroup3	or a.QryGroup4 <> b.QryGroup4
				or a.QryGroup5 <> b.QryGroup5 or a.QryGroup6 <> b.QryGroup6	or a.QryGroup7 <> b.QryGroup7 or a.QryGroup8 <> b.QryGroup8
				or a.QryGroup9 <> b.QryGroup9 or a.QryGroup10 <> b.QryGroup10 or a.QryGroup11 <> b.QryGroup11 or a.QryGroup12 <> b.QryGroup12
				or a.QryGroup15 <> b.QryGroup15	or a.QryGroup16 <> b.QryGroup16	or a.QryGroup17 <> b.QryGroup17	or a.QryGroup18 <> b.QryGroup18
				or a.QryGroup19 <> b.QryGroup19	or a.QryGroup20 <> b.QryGroup20	or a.QryGroup23 <> b.QryGroup23	or a.QryGroup24 <> b.QryGroup24
				or a.QryGroup25 <> b.QryGroup25	or a.QryGroup26 <> b.QryGroup26	or a.QryGroup27 <> b.QryGroup27	or a.QryGroup28 <> b.QryGroup28
				or a.QryGroup29 <> b.QryGroup29	or a.QryGroup30 <> b.QryGroup30	or a.QryGroup31 <> b.QryGroup31	or a.QryGroup32 <> b.QryGroup32
				or a.QryGroup33 <> b.QryGroup33	or a.QryGroup34 <> b.QryGroup34	or a.QryGroup35 <> b.QryGroup35	or a.QryGroup36 <> b.QryGroup36
				or a.QryGroup37 <> b.QryGroup37	or a.QryGroup38 <> b.QryGroup38	or a.QryGroup39 <> b.QryGroup39	or a.QryGroup40 <> b.QryGroup40
				or a.QryGroup41 <> b.QryGroup41	or a.QryGroup42 <> b.QryGroup42	or a.QryGroup45 <> b.QryGroup45	or a.QryGroup46 <> b.QryGroup46
				or a.QryGroup47 <> b.QryGroup47)
			) > 0

			BEGIN
				SET @error = 404;
				SET @error_message = 'Esse usuário não tem permissão para alterar as Características do PN, favor solicitar para os usuários responsáveis.'
			END 
END

a
