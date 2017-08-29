--Analise Aluno Indicadores
SELECT  
	 t0.desc_tipoUsuario as tipo_usuario
    ,t6.Desc_TipoPergunta as tipo_pergunta
    ,t1.descricao as pergunta
    ,t1.id as id_pergunta
    ,t2.desc_segmento as segmento
    ,t2.id as id_seg
    ,t3.DescResp
    ,t4.id as id_resp
    ,t3.nota
    ,t5.cardFname
from tipo_usuario t0
inner join perguntas_clean t1 on t0.id = t1.tipo_usuario_id
inner join segmentos_perguntas t2 on t1.segmentos_perguntas_id = t2.id
inner join perguntas_gabarito t3 on t1.id = t3.id_perguntas
inner join respostas t4 on t3.id = t4.resposta 
					    and t1.id = t4.perguntas_id 
inner join clientes t5 on t4.Perguntas_Segmentos_Perguntas_Clientes_Id = t5.id
inner join tipo_pergunta t6 on t1.tipo_pergunta_id = t6.id
where t6.id = 1 and t1.tipo_usuario_id = 1
order by t1.id

--Analise Professores Indicadores
SELECT  
	 t0.desc_tipoUsuario as tipo_usuario
    ,t6.Desc_TipoPergunta as tipo_pergunta
    ,t1.descricao as pergunta
    ,t1.id as id_pergunta
    ,t2.desc_segmento as segmento
    ,t2.id as id_seg
    ,t3.DescResp
    ,t4.id as id_resp
    ,t3.nota
    ,t5.cardFname
from tipo_usuario t0
inner join perguntas_clean t1 on t0.id = t1.tipo_usuario_id
inner join segmentos_perguntas t2 on t1.segmentos_perguntas_id = t2.id
inner join perguntas_gabarito t3 on t1.id = t3.id_perguntas
inner join respostas t4 on t3.id = t4.resposta 
					    and t1.id = t4.perguntas_id 
inner join clientes t5 on t4.Perguntas_Segmentos_Perguntas_Clientes_Id = t5.id
inner join tipo_pergunta t6 on t1.tipo_pergunta_id = t6.id
where t1.tipo_usuario_id = 2
order by t1.id