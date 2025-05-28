
-- 1) índice B-tree clássico em uma FK muito consultada (consulta de ofertas por disciplina)
CREATE INDEX idx_oferta_disciplina_id_disciplina ON OFERTA_DISCIPLINA(id_disciplina);
-- justificação: consultas filtrando ofertas por disciplina vão acelerar muito usando esse índice, 
-- já que id_disciplina é usado em JOINs e WHERE.

-- 2) índice hash para acelerar busca exata na tabela USUARIO por email (busca de login, por exemplo)
CREATE INDEX idx_usuario_email_hash ON USUARIO USING hash(email);
-- justificação: buscas por email são exatas e frequentes (login, recuperação), hash é ideal pra lookup rápido.

-- 3) índice GIN para texto em avaliações (comentário), caso queira busca full-text simples
CREATE INDEX idx_avaliacao_comentario_gin ON AVALIACAO USING gin(to_tsvector('portuguese', comentario));
-- justificação: pesquisas textuais no comentário da avaliação ficam rápidas e eficientes para palavras e termos.
