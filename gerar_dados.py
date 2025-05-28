from faker import Faker
import random
from datetime import timedelta

fake = Faker("pt_BR")

n_usuarios     = int(input("qtd usuários total: "))
n_cursos       = int(input("qtd cursos: "))
n_deptos       = int(input("qtd departamentos: "))
n_disciplinas  = int(input("qtd disciplinas: "))
n_ofertas      = int(input("qtd ofertas de disciplina: "))
n_matriculas   = int(input("qtd matrículas: "))
n_mensagens    = int(input("qtd mensagens: "))
n_avaliacoes   = int(input("qtd avaliações: "))
n_infras       = int(input("qtd tipos de infraestrutura: "))

unidades = list(range(1, 21))                 # 20 unidades fixas
cursos   = list(range(1000, 1000 + n_cursos)) # pk pros cursos
infra_ids = list(range(1, n_infras + 1))

sql = []

# 1) UNIDADE (precisa existir antes das FKs)
for u in unidades:
    cidade = fake.city()
    estado = random.choices(["São Paulo", "Sólido"], weights=[0.9, 0.1])[0]
    pais = "Brasil"
    predio = f"Prédio {random.randint(1, 10)}"
    sql.append(
        f"""INSERT INTO UNIDADE (id, cidade, estado, pais, predio)
            VALUES ({u}, '{cidade}', '{estado}', '{pais}', '{predio}');"""
    )

# 2) USUÁRIO
usuarios = []
tipos = ["Aluno", "Professor", "Funcionário", "Administrador"]
sexos = ["M", "F", "Z", "8"]

for i in range(1, n_usuarios + 1):
    nome = random.choices(["Mirela", fake.first_name()], weights=[0.01, 0.99])[0]
    sobrenome = fake.last_name()
    nascimento = fake.date_of_birth(minimum_age=18, maximum_age=50)
    sexo = random.choice(sexos)
    cep = fake.postcode()
    numero = str(random.randint(1, 9999))
    telefone = ''.join(str(random.randint(0,9)) for _ in range(14))
    email = fake.email()
    senha = fake.password(length=12)
    tipo = random.choice(tipos)

    usuarios.append(i)
    sql.append(
        f"""INSERT INTO USUARIO (id, nome, sobrenome, data_nascimento, sexo, cep, numero,
                                 telefone, email, senha, tipo_usuario)
            VALUES ({i}, '{nome}', '{sobrenome}', '{nascimento}', '{sexo}', '{cep}', '{numero}',
                    '{telefone}', '{email}', '{senha}', '{tipo}');"""
    )

    
prof_range   = usuarios[int(n_usuarios*0.10):int(n_usuarios*0.30)]
func_range   = usuarios[int(n_usuarios*0.50):int(n_usuarios*0.60)]
aluno_range  = usuarios[int(n_usuarios*0.30):int(n_usuarios*0.90)]
# 3) FUNCIONÁRIO
for fid in func_range:
    sql.append(f"INSERT INTO FUNCIONARIO (id_usuario) VALUES ({fid});")

# 4) PROFESSOR
titulacoes = ["Mestre", "Doutor", "PhD", "Engenheiro de Base de Dados"]
for pid in prof_range:
    area = random.choice(["IA", "Cybersegurança", "Blockchain", "Ciberética", "Sistemas Quânticos"])
    tit  = random.choice(titulacoes)
    uni  = random.choice(unidades)
    sql.append(
        "INSERT INTO PROFESSOR (id_usuario, area_especializacao, titulacao, id_unidade) "
        f"VALUES ({pid}, '{area}', '{tit}', {uni});"
    )

# 5) DEPARTAMENTO (depende de PROFESSOR + UNIDADE)
for did in range(1, n_deptos + 1):
    chefe = random.choice(prof_range)
    uni   = random.choice(unidades)
    sql.append(
        "INSERT INTO DEPARTAMENTO (codigo_unico, nome, id_professor, id_unidade) "
        f"VALUES ({did}, 'Depto {fake.last_name()}', {chefe}, {uni});"
    )

# 6) CURSO (depende de DEPARTAMENTO + UNIDADE)
for cid in cursos:
    depto = random.randint(1, n_deptos)
    uni   = random.choice(unidades)
    nome  = f"Curso de {random.choice(['Engenharia', 'Ciência', 'Tecnologia'])} {random.choice(['da Informação', 'do Caos', 'Cognitiva'])}"
    carga = random.randint(2000, 4000)
    vagas = random.randint(30, 200)
    ementa = "O Curso tem como objetivo a dar 10 aos alunos que viraram noites fazendo o trabalho de BD"
    nivel = random.choice(["Graduação", "Tecnólogo", "Pós"])
    sala  = f"Sala {random.randint(100, 900)}"
    sql.append(
        "INSERT INTO CURSO (codigo_unico, nome, carga_horaria_total, numero_vagas, ementa, "
        "nivel_ensino, sala_padrao, id_departamento, id_unidade) "
        f"VALUES ({cid}, '{nome}', {carga}, {vagas}, '{ementa}', '{nivel}', '{sala}', {depto}, {uni});"
    )

# 7) DISCIPLINA (depende de CURSO + UNIDADE)
disciplinas = []
for did in range(1, n_disciplinas + 1):
    nome = random.choice(["Banco de Dados", "Criptografia Aplicada", "Redes Neurais", "Hacking Ético", "Neural Drift"])
    aulas = random.randint(2, 6)
    mat = f"Material via IPFS no cluster {random.choice(['NEON', 'ZION', 'VOX'])}"
    curso = random.choice(cursos)
    uni   = random.choice(unidades)
    disciplinas.append(did)
    sql.append(
        "INSERT INTO DISCIPLINA (id, nome, aulas_semanais, material_didatico, id_curso, id_unidade) "
        f"VALUES ({did}, '{nome}', {aulas}, '{mat}', {curso}, {uni});"
    )

# 8) ALUNO (depende de USUÁRIO + UNIDADE)
for aid in aluno_range:
    uni = random.choice(unidades)
    sql.append(f"INSERT INTO ALUNO (id_usuario, id_unidade) VALUES ({aid}, {uni});")

# 9) OFERTA_DISCIPLINA (depende de DISCIPLINA + PROFESSOR + UNIDADE)
ofertas = []
for oid in range(1, n_ofertas + 1):
    disc = random.choice(disciplinas)
    periodo = random.choice(["2024.1", "2024.2", "2025.1"])
    sala = f"Lab-{random.randint(1,50)}"
    cap = random.randint(20,60)
    uni = random.choice(unidades)
    prof = random.choice(prof_range)
    ofertas.append(oid)
    sql.append(
        "INSERT INTO OFERTA_DISCIPLINA (id, id_disciplina, periodo, sala, capacidade, id_unidade, id_professor) "
        f"VALUES ({oid}, {disc}, '{periodo}', '{sala}', {cap}, {uni}, {prof});"
    )

# 10) MATRÍCULA (depende de ALUNO + OFERTA_DISCIPLINA)
for mid in range(1, n_matriculas + 1):
    aluno = random.choice(aluno_range)
    oferta = random.choice(ofertas)
    date = fake.date_between(start_date="-1y", end_date="today")
    nota = round(random.uniform(0,10),2)
    desconto = round(random.uniform(0,50),2)
    taxa = round(random.uniform(200,1500),2)
    sql.append(
        "INSERT INTO MATRICULA (id_matricula, id_aluno, id_oferta, data_matricula, status, nota, bolsa, desconto, "
        f"confirmada, data_limite_cancelamento, valor_taxa, status_pagamento) "
        f"VALUES ({mid}, {aluno}, {oferta}, '{date}', 'ativa', {nota}, {random.choice(['TRUE','FALSE'])}, "
        f"{desconto}, TRUE, '{date + timedelta(days=45)}', {taxa}, 'pago');"
    )

# 11) MENSAGEM  & destinatários
mensagens = []
for msg_id in range(1, n_mensagens + 1):
    remet = random.choice(usuarios)
    carimbo = fake.date_time_this_decade()
    texto = random.choice([
        "encontro no lab às 13h", "houve vazamento no cluster", "suba os logs no S3",
        "verifique o token no Git", "não compartilhe a senha root", "acesso negado ao proxy zeta"
    ])
    mensagens.append(msg_id)
    sql.append(
        f"INSERT INTO MENSAGEM (id_mensagem, remetente_id, timestamp, texto) "
        f"VALUES ({msg_id}, {remet}, '{carimbo}', '{texto}');"
    )
    # encaminhar pra um random user
    dest = random.choice(usuarios)
    sql.append(
        f"INSERT INTO E_DESTINADA_A (id_mensagem, id_destinatario) VALUES ({msg_id}, {dest});"
    )

# 12) INFRASTRUTURA_NECESSÁRIA
for iid in infra_ids:
    tipo = random.choice(["Servidor", "Cluster GPU", "Switch Óptico", "Terminal Segurado", "Ambiente Isolado"])
    sql.append(f"INSERT INTO INFRASTRUTURA_NECESSARIA (id, tipo) VALUES ({iid}, '{tipo}');")

# 13) AVALIAÇÃO
for aid in range(1, n_avaliacoes + 1):
    aluno = random.choice(aluno_range)
    prof  = random.choice(prof_range)
    disc  = random.choice(disciplinas)
    avaliacao = random.choice(["muito bom", "bom", "ruim"])
    sql.append(
        "INSERT INTO AVALIACAO (id, id_aluno, id_disciplina, id_professor, periodo, comentario, "
        f"nota_didatica, nota_material, nota_conteudo, nota_infraestrutura) "
        f"VALUES ({aid}, {aluno}, {disc}, {prof}, '2025.1', 'muito bom', "
        f"{random.uniform(6,10):.2f}, {random.uniform(6,10):.2f}, {random.uniform(6,10):.2f}, {random.uniform(6,10):.2f});"
    )

# 14) INFRA/CURSO  |  PRE-REQ  |  GERENCIA  |  OFERECER  (N:N com ON CONFLICT pra evitar dup)
for _ in range(max(n_infras, n_ofertas, n_disciplinas)):
    curso = random.choice(cursos)
    disc  = random.choice(disciplinas)
    infra = random.choice(infra_ids)
    oferta = random.choice(ofertas)
    func   = random.choice(func_range)

    sql.append(f"INSERT INTO OFERECER (id_curso, id_disciplina) VALUES ({curso}, {disc}) ON CONFLICT DO NOTHING;")
    sql.append(f"INSERT INTO REQUER_INFRAESTRUTURA (id_curso, id_infraestrutura) VALUES ({curso}, {infra}) ON CONFLICT DO NOTHING;")
    sql.append(f"INSERT INTO PRE_REQUISITO (id_disciplina_principal, id_disciplina_requisito) "
               f"VALUES ({disc}, {random.choice(disciplinas)}) ON CONFLICT DO NOTHING;")
    sql.append(f"INSERT INTO GERENCIA (id_funcionario, id_oferta_disciplina) VALUES "
               f"({func}, {oferta}) ON CONFLICT DO NOTHING;")

# — dump final —
with open("dados.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql))

print(">> dados.sql gerado com sucesso!")
