-- 1) listar professores da área de 'Banco de Dados' ou 'IA', ordenado por titulação
SELECT p.id_usuario, u.nome, u.sobrenome, p.area_especializacao, p.titulacao
FROM PROFESSOR p
JOIN USUARIO u ON p.id_usuario = u.id
WHERE p.area_especializacao IN ('Banco de Dados', 'IA')
ORDER BY p.titulacao DESC;

-- 2) cursos com número de vagas > 100 e quantidade de disciplinas ofertadas por curso
SELECT c.codigo_unico, c.nome, c.numero_vagas, COUNT(d.id) AS total_disciplinas
FROM CURSO c
LEFT JOIN DISCIPLINA d ON d.id_curso = c.codigo_unico
GROUP BY c.codigo_unico, c.nome, c.numero_vagas
HAVING c.numero_vagas > 100
ORDER BY total_disciplinas DESC;

-- 3) alunos matriculados em ofertas de disciplinas ministradas por professor com titulação 'Doutor'
SELECT DISTINCT u.id, u.nome, u.sobrenome, od.id_professor
FROM ALUNO a
JOIN USUARIO u ON a.id_usuario = u.id
JOIN MATRICULA m ON m.id_aluno = a.id_usuario
JOIN OFERTA_DISCIPLINA od ON od.id = m.id_oferta
JOIN PROFESSOR p ON od.id_professor = p.id_usuario
WHERE p.titulacao = 'Doutor';

-- 4) média das notas de avaliação por disciplina no período '2025.1'
SELECT d.nome, AVG(av.nota_didatica) AS media_didatica, AVG(av.nota_material) AS media_material,
       AVG(av.nota_conteudo) AS media_conteudo, AVG(av.nota_infraestrutura) AS media_infraestrutura
FROM AVALIACAO av
JOIN DISCIPLINA d ON av.id_disciplina = d.id
WHERE av.periodo = '2025.1'
GROUP BY d.nome
ORDER BY media_didatica DESC;

-- 5) ofertas de disciplinas com capacidade abaixo de 30 e número de matrículas confirmadas
SELECT od.id, d.nome AS disciplina, od.capacidade, COUNT(m.id_matricula) AS matriculas_confirmadas
FROM OFERTA_DISCIPLINA od
JOIN DISCIPLINA d ON od.id_disciplina = d.id
LEFT JOIN MATRICULA m ON m.id_oferta = od.id AND m.confirmada = TRUE
GROUP BY od.id, d.nome, od.capacidade
HAVING od.capacidade < 30
ORDER BY matriculas_confirmadas DESC;

-- 6) funcionários que gerenciam ofertas de disciplinas e quantas ofertas gerenciam
SELECT f.id_usuario, u.nome, u.sobrenome, COUNT(g.id_oferta_disciplina) AS ofertas_gerenciadas
FROM FUNCIONARIO f
JOIN USUARIO u ON f.id_usuario = u.id
LEFT JOIN GERENCIA g ON f.id_usuario = g.id_funcionario
GROUP BY f.id_usuario, u.nome, u.sobrenome
ORDER BY ofertas_gerenciadas DESC;

-- 7) mensagens enviadas por usuário com mais de 10 mensagens, com contagem total
SELECT remetente_id, u.nome, u.sobrenome, COUNT(*) AS total_mensagens
FROM MENSAGEM m
JOIN USUARIO u ON m.remetente_id = u.id
GROUP BY remetente_id, u.nome, u.sobrenome
HAVING COUNT(*) > 10
ORDER BY total_mensagens DESC;
