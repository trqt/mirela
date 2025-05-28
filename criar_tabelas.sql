CREATE TABLE UNIDADE (
    id INT PRIMARY KEY,
    cidade VARCHAR(255),
    estado VARCHAR(255),
    pais VARCHAR(255),
    predio VARCHAR(255)
);

CREATE TABLE USUARIO (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    sobrenome VARCHAR(255),
    data_nascimento DATE,
    sexo CHAR(1),
    cep VARCHAR(10),
    numero VARCHAR(10),
    telefone VARCHAR(15),
    email VARCHAR(255),
    senha VARCHAR(255),
    tipo_usuario VARCHAR(50)
);

CREATE TABLE PROFESSOR (
    id_usuario INT PRIMARY KEY,
    area_especializacao VARCHAR(255),
    titulacao VARCHAR(255),
    id_unidade INT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id),
    FOREIGN KEY (id_unidade) REFERENCES UNIDADE(id)
);


CREATE TABLE DEPARTAMENTO (
    codigo_unico INT PRIMARY KEY,
    nome VARCHAR(255),
    id_professor INT,
    id_unidade INT,
    FOREIGN KEY (id_professor) REFERENCES PROFESSOR(id_usuario),
    FOREIGN KEY (id_unidade) REFERENCES UNIDADE(id)
);


CREATE TABLE CURSO (
    codigo_unico INT PRIMARY KEY,
    nome VARCHAR(255),
    carga_horaria_total INT,
    numero_vagas INT,
    ementa TEXT,
    nivel_ensino VARCHAR(50),
    sala_padrao VARCHAR(50),
    id_departamento INT,
    id_unidade INT,
    FOREIGN KEY (id_departamento) REFERENCES DEPARTAMENTO(codigo_unico),
    FOREIGN KEY (id_unidade) REFERENCES UNIDADE(id)
);


CREATE TABLE DISCIPLINA (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    aulas_semanais INT,
    material_didatico TEXT,
    id_curso INT,
    id_unidade INT,
    FOREIGN KEY (id_curso) REFERENCES CURSO(codigo_unico),
    FOREIGN KEY (id_unidade) REFERENCES UNIDADE(id)
);

CREATE TABLE ALUNO (
    id_usuario INT PRIMARY KEY,
    id_unidade INT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id),
    FOREIGN KEY (id_unidade) REFERENCES UNIDADE(id)
);

CREATE TABLE OFERTA_DISCIPLINA (
    id INT PRIMARY KEY,
    id_disciplina INT,
    periodo VARCHAR(50),
    sala VARCHAR(50),
    capacidade INT,
    id_unidade INT,
    id_professor INT,
    FOREIGN KEY (id_disciplina) REFERENCES DISCIPLINA(id),
    FOREIGN KEY (id_unidade) REFERENCES UNIDADE(id),
    FOREIGN KEY (id_professor) REFERENCES PROFESSOR(id_usuario)
);

CREATE TABLE MATRICULA (
    id_matricula INT PRIMARY KEY,
    id_aluno INT,
    id_oferta INT,
    data_matricula DATE,
    status VARCHAR(50),
    nota DECIMAL(4,2),
    bolsa BOOLEAN,
    desconto DECIMAL(5,2),
    confirmada BOOLEAN,
    data_limite_cancelamento DATE,
    valor_taxa DECIMAL(10,2),
    status_pagamento VARCHAR(50),
    FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_usuario),
    FOREIGN KEY (id_oferta) REFERENCES OFERTA_DISCIPLINA(id)
);

CREATE TABLE REGRA_CURSO (
    id INT PRIMARY KEY,
    descricao TEXT,
    id_curso INT,
    FOREIGN KEY (id_curso) REFERENCES CURSO(codigo_unico)
);

CREATE TABLE MENSAGEM (
    id_mensagem INT PRIMARY KEY,
    remetente_id INT,
    timestamp TIMESTAMP,
    texto TEXT,
    FOREIGN KEY (remetente_id) REFERENCES USUARIO(id)
);

CREATE TABLE FUNCIONARIO (
    id_usuario INT PRIMARY KEY,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id)
);

CREATE TABLE AVISO (
    id INT PRIMARY KEY,
    autor_id INT,
    timestamp TIMESTAMP,
    texto TEXT,
    id_disciplina INT,
    id_funcionario INT,
    FOREIGN KEY (autor_id) REFERENCES USUARIO(id),
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_usuario),
    FOREIGN KEY (id_disciplina) REFERENCES DISCIPLINA(id)
);

CREATE TABLE AVALIACAO (
    id INT PRIMARY KEY,
    id_aluno INT,
    id_disciplina INT,
    id_professor INT,
    periodo VARCHAR(50),
    comentario TEXT,
    nota_didatica DECIMAL(4,2),
    nota_material DECIMAL(4,2),
    nota_conteudo DECIMAL(4,2),
    nota_infraestrutura DECIMAL(4,2),
    FOREIGN KEY (id_aluno) REFERENCES ALUNO(id_usuario),
    FOREIGN KEY (id_disciplina) REFERENCES DISCIPLINA(id),
    FOREIGN KEY (id_professor) REFERENCES PROFESSOR(id_usuario)
);

CREATE TABLE INFRASTRUTURA_NECESSARIA (
    id INT PRIMARY KEY,
    tipo VARCHAR(255)
);

CREATE TABLE OFERECER (
    id_curso INT,
    id_disciplina INT,
    PRIMARY KEY (id_curso, id_disciplina),
    FOREIGN KEY (id_curso) REFERENCES CURSO(codigo_unico),
    FOREIGN KEY (id_disciplina) REFERENCES DISCIPLINA(id)
);

CREATE TABLE REQUER_INFRAESTRUTURA (
    id_curso INT,
    id_infraestrutura INT,
    PRIMARY KEY (id_curso, id_infraestrutura),
    FOREIGN KEY (id_curso) REFERENCES CURSO(codigo_unico),
    FOREIGN KEY (id_infraestrutura) REFERENCES INFRASTRUTURA_NECESSARIA(id)
);

CREATE TABLE PRE_REQUISITO (
    id_disciplina_principal INT,
    id_disciplina_requisito INT,
    PRIMARY KEY (id_disciplina_principal, id_disciplina_requisito),
    FOREIGN KEY (id_disciplina_principal) REFERENCES DISCIPLINA(id),
    FOREIGN KEY (id_disciplina_requisito) REFERENCES DISCIPLINA(id)
);

CREATE TABLE GERENCIA (
    id_funcionario INT,
    id_oferta_disciplina INT,
    PRIMARY KEY (id_funcionario, id_oferta_disciplina),
    FOREIGN KEY (id_funcionario) REFERENCES FUNCIONARIO(id_usuario),
    FOREIGN KEY (id_oferta_disciplina) REFERENCES OFERTA_DISCIPLINA(id)
);

CREATE TABLE E_DESTINADA_A (
    id_mensagem INT,
    id_destinatario INT,
    PRIMARY KEY (id_mensagem, id_destinatario),
    FOREIGN KEY (id_mensagem) REFERENCES MENSAGEM(id_mensagem),
    FOREIGN KEY (id_destinatario) REFERENCES USUARIO(id)
);
