-- Seção 11: Criando Visões (Views)

-- Objetivos
    -- Descrever uma visão
    -- Criar uma visão
    -- Recuperar dados através de uma visão
    -- Alterar a definição de uma visão
    -- Inserir, atualizar e remover dados através de uma visão
    -- Remover uma visão

-- O que é uma visão?
    -- é uma tabela lógica baseada em uma tabela ou outra visão
    -- as tabelas nas quais uma visão é baseada são chamadas de tabelas básicas
    -- a visão é armazenada como um comando select no dicionário de dados

-- Porquê utilizar visões?
    -- para restringir o acesso ao banco de dados
    -- para tornar simples consultas complexas
    -- para permitir independência de dados
    -- para apresentar visões diferentes do mesmo dado

-- Visões Simples e Complexas
    -- CARACTERÍSTICA           | VISÃO SIMPLES  | VISÃO COMPLEXA
    -- Número de tabelas        | 1              | 2 ou mais
    -- Contém funções           | Não            | Sim
    -- Possui grupos de dados   | Não            | Sim
    -- DML através da visão     | Sim            | Talvez

-- Criando uma visão (sintaxe)
    -- CREATE [OR REPLACE] VIEW nome_visão [(alias[, alias] ...)]
    -- AS subquery
    -- [WITH CHECK OPTION [CONSTRAINT constraint]]
    -- [WITH READ ONLY]

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- criando uma view V_ALUNO
create or replace view V_ALUNO as
select cod_aluno as codigo, nome as aluno, salario, estado, cidade
from TALUNO
where estado = 'RS';

-- consultando view V_ALUNO
select * from V_ALUNO;


-- criando uma view V_CONTRATO_TOP
create or replace view V_CONTRATO_TOP as
select cod_contrato, desconto
from TCONTRATO
where desconto > 10;

-- consultando view V_CONTRATO_TOP
select * from V_CONTRATO_TOP;


-- consultando views do usuário
select view_name, text
from user_views;


-- criando view com parametros de saida
create or replace view V_ALUNO_SALARIO (cod, aluno, sal) as
select cod_aluno, nome, salario
from TALUNO;

-- consultando view V_ALUNO_SALARIO
select * from V_ALUNO_SALARIO;


-- criando view complexa V_CONTRATO
create or replace view V_CONTRATO as
select
    trunc(data) as data,
    nvl(max(desconto),0) as "maximo desconto",
    nvl(avg(desconto), 0) as "media desconto",
    count(*) as qtde
from TCONTRATO
group by trunc(data)
order by data desc;

-- consultando V_CONTRATO
select * from V_CONTRATO;


-- criando view simples V_PESSOA_F
create or replace view V_PESSOA_F as
select cod_pessoa, tipo, nome, cod_rua as rua
from TPESSOA
where tipo = 'F';

-- consultando V_PESSOA_F
select * from V_PESSOA_F;


-- criando consulta envolvendo view e tabela
select
    vpf.cod_pessoa as codigo,
    vpf.nome as pessoa,
    tc.nome as cidade,
    tr.nome as rua
from V_PESSOA_F vpf, TRUA tr, TCIDADE tc
where vpf.rua = tr.cod_rua
and tc.COD_CIDADE = tr.cod_cidade
order by vpf.nome;


-- operação DML com view V_CURSOS_1000
create or replace view V_CURSOS_1000 as
select cod_curso, nome, valor
from TCURSO
where valor = 1000
with check option constraint V_CURSOS_1000_CK;

-- consultando V_CURSOS_1000
select *
from V_CURSOS_1000;

-- inserindo dados na view V_CURSOS_1000 que deve falhar
-- SQL Error: ORA-01402: view WITH CHECK OPTION where-clause violation
insert into V_CURSOS_1000 (cod_curso, nome, valor)
values (52,'teste que deve falhar', 100);

-- inserindo dados na view V_CURSOS_1000 que deve inserir
-- dados inseridos na na tabela TCURSO através da view
insert into V_CURSOS_1000 (cod_curso, nome, valor)
values (52,'teste que deve funcionar', 1000);

-- consultando V_CURSOS_1000
-- registro codigo 52 deve ter sido inserido
select *
from V_CURSOS_1000;

-- removendo registros através da view
delete from V_CURSOS_1000
where cod_curso = 52;

-- consultando V_CURSOS_1000
-- registro codigo 52 deve ter sido removido
select *
from V_CURSOS_1000
where cod_curso = 52;

commit;


-- delete em view deve falhar
-- não pode fazer dml em view complexa
-- SQL Error: ORA-01732: data manipulation operation not legal on this view
delete from V_CONTRATO;


-- criando view somente leitura V_ALUNO_READ_ONLY
-- não permite DML
create or replace view V_ALUNO_READ_ONLY as
select cod_aluno as codigo, nome as aluno, cidade
from TALUNO
where estado = 'RS'
with READ ONLY;

-- consultando V_ALUNO_READ_ONLY
select *
from V_ALUNO_READ_ONLY;

-- delete na view V_ALUNO_READ_ONLY deve falhar
-- SQL Error: ORA-42399: cannot perform a DML operation on a read-only view
delete from V_ALUNO_READ_ONLY
where cidade = 'RIO GRANDE';

-- excluindo view
drop view V_ALUNO_READ_ONLY;
