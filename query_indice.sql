
-- 1) índice B-tree em OFERTA_DISCIPLINA(id_disciplina)

-- drop índice se existir (sem índice)
DROP INDEX IF EXISTS idx_oferta_disciplina_id_disciplina;

-- consulta sem índice
EXPLAIN ANALYZE
SELECT * FROM OFERTA_DISCIPLINA WHERE id_disciplina = 12;

-- cria índice
CREATE INDEX idx_oferta_disciplina_id_disciplina ON OFERTA_DISCIPLINA(id_disciplina);

-- consulta com índice
EXPLAIN ANALYZE
SELECT * FROM OFERTA_DISCIPLINA WHERE id_disciplina = 12;



-- 2) índice hash em USUARIO(email)

-- drop índice se existir (sem índice)
DROP INDEX IF EXISTS idx_usuario_email_hash;

-- consulta sem índice
EXPLAIN ANALYZE
SELECT * FROM USUARIO WHERE email = 'montenegrodiego@example.org';

-- cria índice hash
CREATE INDEX idx_usuario_email_hash ON USUARIO USING hash(email);

-- consulta com índice
EXPLAIN ANALYZE
SELECT * FROM USUARIO WHERE email = 'montenegrodiego@example.org';



-- 3) índice GIN para full-text em AVALIACAO(comentario)

-- drop índice se existir (sem índice)
DROP INDEX IF EXISTS idx_avaliacao_comentario_gin;

-- consulta sem índice (full-text search)
EXPLAIN ANALYZE
SELECT * FROM AVALIACAO WHERE to_tsvector('portuguese', comentario) @@ to_tsquery('portuguese', 'bom');

-- cria índice GIN
CREATE INDEX idx_avaliacao_comentario_gin ON AVALIACAO USING gin(to_tsvector('portuguese', comentario));

-- consulta com índice (full-text search)
EXPLAIN ANALYZE
SELECT * FROM AVALIACAO WHERE to_tsvector('portuguese', comentario) @@ to_tsquery('portuguese', 'bom');
