-- Seção 12: Outros Objetos de Banco de Dados

-- Objetivos
    -- Criar, alterar e utilizar sequencias
    -- criar e alterar indices

-- O que é uma sequencia
    -- automaticamente gera números únicos
    -- é um objeto compartilhado
    -- é normalmente utilizada para criar valores para chaves primárias
    -- substitui código de aplicação

-- Comando
    -- CREATE SEQUENCE sequence_name  <-- nome da sequência
    -- [INCREMENT BY n]               <-- valor de incremento da sequência
    -- [START WITH n]                 <-- valor inicial da sequência
    -- [MAXVALUE n | NOMAXVALUE]      <-- valor máximo que a sequência pode atingir
    -- [MINVALUE n | NOMINVALUE]      <-- valor mínimo que a sequência pode atingir
    -- [CYCLE | NOCYCLE]              <-- se chegar no valor máximo, reinicia ou para
    -- [CACHE n | NOCACHE];           <-- mantém os próximos n valores na memória para acesso rápido

-- Criando uma sequência
    -- create sequence sclientes_id
    -- increment by 1
    -- start with 201
    -- maxvalue 300
    -- nocache
    -- nocycle;

-- Indices Secundários (INDEX)

-- Sinônimos (SYNONYM)

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Criando uma sequência
create sequence sclientes_id
increment by 1
start with 201
maxvalue 300
nocache
nocycle;

-- Criando uma sequência para alunos
create sequence seq_aluno_01
start with 60
increment by 2
minvalue 60
maxvalue 100
nocache
nocycle;

-- Consultando a sequência
select sclientes_id.nextval from dual;  -- retorna o próximo valor da sequência

-- Inserindo dados na tabela de alunos utilizando a sequência
insert into TALUNO (cod_aluno, nome, cidade, cep, estado, salario, nascimento)
values (seq_aluno_01.nextval, 'Maria', 'Porto Alegre', '90000-000', 'RS', 2500, to_date('15/05/1990', 'dd/mm/yyyy'));

commit;

-- Consultando TALUNO
select * from TALUNO;

-- Consultando sequências do usuário
select * from user_sequences;

-- Consultando valor atual de uma sequência
select sclientes_id.currval from dual;

-- Alterando uma sequência
alter sequence seq_aluno_01
maxvalue 500;

-- Apagando uma sequência
drop sequence sclientes_id;

-- Criando indices secundários
create index ind_taluno_nome_1 on taluno(nome);

-- Na pesquisa COM o index o cost foi 1. Ele faz o index full scan
-- --------------------------------------------------------------------------------------
-- | Id  | Operation        | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
-- --------------------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT |                   |     1 |     6 |     1   (0)| 00:00:01 |
-- |*  1 |  INDEX FULL SCAN | IND_TALUNO_NOME_1 |     1 |     6 |     1   (0)| 00:00:01 |
-- --------------------------------------------------------------------------------------
select nome
from taluno
where nome like '%A%';

-- Na pesquisa SEM o index o cost foi 3. Ele faz o table full scan
-- ----------------------------------------------------------------------------
-- | Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
-- ----------------------------------------------------------------------------
-- |   0 | SELECT STATEMENT  |        |     1 |    12 |     3   (0)| 00:00:01 |
-- |*  1 |  TABLE ACCESS FULL| TALUNO |     1 |    12 |     3   (0)| 00:00:01 |
-- ----------------------------------------------------------------------------
select cidade
from taluno
where cidade like '%A%';

-- Listando os index do usuário
select * from USER_INDEXES;

-- Apagando um index
drop index ind_taluno_nome_1;

-- Criando um sinônimo
create synonym ALU for TALUNO;

-- Consultando TALUNO usando o synonym
select * from ALU;
