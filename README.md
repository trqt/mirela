# Escola Base de Dados


Para executar
```bash
# entre no ambiente
nix develop

# cria o banco de dados
psql -U postgres -c 'CREATE DATABASE universidade;'

# roda o script SQL para criar as tabelas
psql -U postgres -d universidade -f criar_tabelas.sql

# gera e insere dados sintéticos
python gerar_dados.py
```
