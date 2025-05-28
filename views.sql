
-- 1) visão: alunos com matrícula ativa, curso e professor responsável pela oferta
CREATE VIEW vw_alunos_matriculados AS
SELECT
  u.id AS id_aluno,
  u.nome || ' ' || u.sobrenome AS nome_aluno,
  c.nome AS nome_curso,
  p.id_usuario AS id_professor,
  p.area_especializacao,
  od.periodo
FROM MATRICULA m
JOIN ALUNO a ON m.id_aluno = a.id_usuario
JOIN USUARIO u ON a.id_usuario = u.id
JOIN OFERTA_DISCIPLINA od ON m.id_oferta = od.id
JOIN PROFESSOR p ON od.id_professor = p.id_usuario
JOIN DISCIPLINA d ON od.id_disciplina = d.id
JOIN CURSO c ON d.id_curso = c.codigo_unico
WHERE m.status = 'ativa';

-- 2) visão: avaliações detalhadas por disciplina e professor
CREATE VIEW vw_avaliacoes_detalhadas AS
SELECT
  d.nome AS disciplina,
  p.id_usuario AS id_professor,
  u.nome || ' ' || u.sobrenome AS nome_professor,
  AVG(av.nota_didatica) AS media_didatica,
  AVG(av.nota_material) AS media_material,
  AVG(av.nota_conteudo) AS media_conteudo,
  AVG(av.nota_infraestrutura) AS media_infraestrutura
FROM AVALIACAO av
JOIN DISCIPLINA d ON av.id_disciplina = d.id
JOIN PROFESSOR p ON av.id_professor = p.id_usuario
JOIN USUARIO u ON p.id_usuario = u.id
GROUP BY d.nome, p.id_usuario, u.nome, u.sobrenome;

-- 3) visão: ofertas de disciplinas com capacidade e quantidade de matrículas confirmadas
CREATE VIEW vw_ofertas_com_matriculas AS
SELECT
  od.id,
  d.nome AS disciplina,
  od.periodo,
  od.sala,
  od.capacidade,
  COUNT(m.id_matricula) AS matriculas_confirmadas
FROM OFERTA_DISCIPLINA od
JOIN DISCIPLINA d ON od.id_disciplina = d.id
LEFT JOIN MATRICULA m ON m.id_oferta = od.id AND m.confirmada = TRUE
GROUP BY od.id, d.nome, od.periodo, od.sala, od.capacidade;
