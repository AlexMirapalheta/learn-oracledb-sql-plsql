# learn-oracledb-sql-plsql

## Dados do Treinamento

- **Nome:** Curso Completo de Banco de Dados Oracle SQL e PL/SQL
- **Duração:** 16,5 horas
- **Link:** https://compassuol.udemy.com/course/curso-completo-de-oracle/
- **Arquivos fornecidos pelo curso**
  - **scripts**: `sql/course_base_files`
  - **ebook**: `ebook/Oracle+SQL+Ebook.pdf`
- **Certificado de conclusão:**


## Seção 01 - Instalações Relacionadas

Todas as configurações consideram a execução no `Ubuntu 24.04.3 LTS`

### 1. Banco de Dados Oracle XE 11g

- Imagem utilizada:
A imagem mais utilizada e estável para Oracle XE 11g é a do repositório wnameless (https://github.com/wnameless/docker-oracle-xe-11g)

- Baixar a imagem:
```bash
docker pull wnameless/oracle-xe-11g-r2
```

- Executar o container: Primeira Inicialização
```bash
docker run -d --name oracle-xe11 --shm-size=2g -p 1521:1521 -p 8080:8080 -e ORACLE_ALLOW_REMOTE=true -v oracle-xe-data:/u01/app/oracle/oradata wnameless/oracle-xe-11g-r2
```
- Executar o container: Demais Inicializações
```bash
docker start oracle-xe11
```
- Executar o container: Para Container
```bash
docker stop oracle-xe11
```
- Conexão ao Banco
  - HOST: localhost
  - PORT: 1521
  - SID: xe
  - USER: system
  - PASS: oracle

- Acessar o Oracle APEX:
  - URL: http://localhost:8080/apex/apex_admin
  - username: ADMIN
  - password: admin

*Obs.: senha sugerida para troca após o primeiro acesso: `Adm!n1234567890`*

- Entrar no container e usar o SQL*Plus
```bash
# entra no container com bash
docker exec -it oracle-xe11 bash

# já dentro do container:
su - oracle
/u01/app/oracle/product/11.2.0/xe/bin/sqlplus / as sysdba
```

- Alterar senha de SYS/SYSTEM (opcional)
   - Dentro do SQL*Plus:
```sql
alter user sys identified by novaSenha;
alter user system identified by novaSenha;
```

### 2. SQL Tools

**Opções:**

1. **DBeaver**
```bash
sudo snap install dbeaver-ce
```
2. **Oracle SQL Developer Extension for VSCode**

```bash
# Instalação: abra o VS Code Quick Open (Ctrl+P), cole o comando à seguir, pressione enter e siga os passos de instalação propostos.

ext install Oracle.sql-developer
```
Link: https://marketplace.visualstudio.com/items?itemName=Oracle.sql-developer


### 3. Oracle SQL Developer

**Instalar o JDK (Java Development Kit)**

O SQL Developer requer um JDK instalado. A opção recomendada é o **OpenJDK 17**:
```bash
sudo apt update
sudo apt install openjdk-17-jdk

# ou utilizando o seu gerenciador de instalações (sdkman, asdf, etc.)
# Exemplo: sdkman
# 1) instalar
#    $ sdk install java 17.0.18-amzn
# 2) para verificar o local da instalação
#    $ sdk home java 17.0.18-amzn
#    R: /home/user_name/.sdkman/candidates/java/17.0.18-amzn
```

**Baixar e instalar o SQL Developer**
1. Baixe o arquivo versão zip em https://www.oracle.com/br/database/sqldeveloper/technologies/download/#sqldev-install-linux
2. Descompacte o conteúdo:
```bash
cd ~/Downloads
unzip sqldeveloper-*-no-jre.zip
```
3. Mova a pasta para /opt (mais linux like)
```bash
sudo mv sqldeveloper-24.3.1.347.1826-no-jre/sqldeveloper/ /opt/
```
4. Acesse a pasta, de permissão de execução ao script e o execute
```bash
cd sqldeveloper
chmod +x sqldeveloper.sh
./sqldeveloper.sh
```
5. Informe o caminho do JDK quando solicitado (talvez identifique sozinho)
```bash
# ou conforme a sua instalação
/home/user_name/.sdkman/candidates/java/17.0.18-amzn
```
6. Ajustar permissões (boa prática)
```bash
# Permitir que apenas root altere os arquivos, mas você consiga executar
sudo chown -R root:root /opt/sqldeveloper
sudo chmod -R 755 /opt/sqldeveloper
```
7. Criar um atalho para facilitar o uso
```bash
# Crie um pequeno script em /usr/local/bin/sqldeveloper que entra no diretório certo e executa o .sh

sudo tee /usr/local/bin/sqldeveloper >/dev/null <<'EOF'
#!/usr/bin/env bash
cd /opt/sqldeveloper || { echo "Não encontrei /opt/sqldeveloper"; exit 1; }
exec bash ./sqldeveloper.sh "$@"
EOF

sudo chmod +x /usr/local/bin/sqldeveloper
```
8. Criar o ícone no menu de aplicativos
- Criar o arquivo .desktop
```bash
mkdir -p ~/.local/share/applications

tee ~/.local/share/applications/sqldeveloper.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Oracle SQL Developer
Comment=Ferramenta de desenvolvimento SQL da Oracle
Exec=/usr/local/bin/sqldeveloper
Terminal=false
Type=Application
Categories=Development;Database;IDE;
Icon=/opt/sqldeveloper/icon.png
StartupNotify=true
EOF
```
- Permitir execução
```bash
chmod +x ~/.local/share/applications/sqldeveloper.desktop
```
- Atualizar lista de aplicativos (opcional)
```bash
update-desktop-database ~/.local/share/applications 2>/dev/null || true
# ou simplesmente reinicializar a sessão
```

## Seção 01 - Configurações Iniciais

Como boa prática, criar usuário e tablespace específico para o desenvolvimento do curso (não usar o admin).

Utilizar o conteúdo do arquivo `sql/secao_01/s01_script_criacao_tablespace.txt` para criação de:
- Cria tablespace p/ dados
- Cria usuario (dono das tabelas)
- Cria e define a "role" de privilegios (perfil)
- Atribuir perfil ao novo usuário

Criar tabelas e inserir registros conforme arquivo `sql/secao_01/s01.sql`


## Seção 02 - Execução de Comandos SQL Básicos: SELECT
- Revisão teórica
  - Escrevendo comandos
  - Padrões de cabeçalhos de colunas
  - Expressões Aritiméticas
  - Precedência de operadores
  - Definindo um valor nulo
  - Definindo um Alias de coluna
  - Operador de Concatenação
  - String de caracteres literais
  - Linhas Duplicadas
  - Tipos
- Exemplos

Anotações e exemplos contidos no arquivo `sql/secao_02/s02.sql`


## Seção 03 - Restringindo e Ordenando Dados
- Revisão teórica
  - Limitando as linhas selecionadas
    - clausula WHERE
    - Condições
      - composição
      - strings de caractere e Datas
      - operadores de comparação: =, >, >=, <. <=, <> ou !=
      - outros operadores de comparação: BETWEEN...AND..., IN, LIKE, IS NULL
      - precedência
  - Ordenação
- Exemplos

Anotações e exemplos contidos no arquivo `sql/secao_03/s03.sql`


## Seção 04 - Funções Básicas
- Revisão teórica
  - descrever os vários tipos de funções disponĩveis em SQL
  - utilizar vários tipos de funções em comandos SELECT
    - Tipo Caractere: CONCAT, INITCAP, INSTR, LENGTH, LOWER, LPAD, REPLACE, RPAD, SUBSTR e UPPER
    - Tipo Numérica: ROUND, TRUNC e MOD
    - Tipo Data: SYSDATE, MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, ROUND(D,'MONTH') e TRUNC(D,'MONTH')
    - Tipo Transformação: TO_CHAR
    - Tipo Gerais: NVL e NVL2
    - Tipo Expressão Condicional: CASE e DECODE
- Exemplos

Anotações e exemplos contidos no arquivo `sql/secao_04/s04.sql`


## Seção 05 - Exibindo Dados a Partir de Multiplas Tabelas
- Revisão teórica
  - obtendo dados a partir de multiplas tabelas
  - o que é um JOIN ?
  - produto cartesiano
  - qualificando nomes de colunas ambíguas
  - tipos de JOINS
    - Equi join
    - Non equi join
    - Outer join
    - Self join
- Exemplos

Anotações e exemplos contidos no arquivo `sql/secao_05/s05.sql`

## Seção 06 - Agregando Dados Utilizando Funções de Grupo
- Revisão Teórica
  - o que são funções de grupo
  - tipos de funções de grupo
    - AVG
    - COUNT
    - MAX
    - MIN
    - SUM
  - sintaxe básica
    - descrever o uso de funções de grupo
    - agrupar dados utilizando GROUP BY
    - incluir ou excluir linhas agrupadas utilizando HAVING
- Exemplos

Anotações e exemplos contidos no arquivo `sql/secao_06/s06.sql`
