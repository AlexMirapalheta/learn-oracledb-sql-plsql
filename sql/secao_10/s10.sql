-- Seção 10: Implementando Constraints

-- Objetivos
    -- descrever constrainst de integridade
    -- criar e administrar constraints

-- O que são constraints
    -- garantem regras a nível de tabela
    -- deve ser satisfeita pela operação para ter sucesso
    -- previne a exclusão de uma tabela se houverem dependências

-- Tipos
    -- NOT NULL     : a coluna não pode ter valores nulos
    -- UNIQUE KEY   : a coluna ou combinação de colunas deve ter valores únicos em todas as linhas
    -- PRIMARY KEY  : identifica a chave primária (identifica de forma única cada linha)
    -- FOREIGN KEY  : identifica a chave estrangeira (estabelece relacionamento entre tabelas através das chaves)
    -- CHECK        : especifica uma condição que deve ser verdadeira

-- Diretrizes
    -- forneça um nome para a constraint ou o servidor gerará um utilizando o formato SYS_Cn
    -- crie a constraint no mesmo momento da tabela ou após a tabela ser criada
    -- defina no nível de coluna ou tabela
    -- visualize no dicionário de dados USER_CONSTRAINTS

-- Definindo
    -- CREAYE TABLE [schema.] table (column datatype [DEFAULT EXPR] [column_constraint], ... [table_constraint]);
    -- Ex.:
        -- CREATE TABLE tclientes(
        --  id NUMBER(6),
        --  nome VARCHAR2(35),
        --  ...
        --  comentarios NUMBER(1000) NOT NULL,
        --  CONSTRAINT tclientes_id_pk PRIMARY KEY(id)
        -- );
    -- normalmente são criadas ao mesmo tempo com a tabela
    -- podem ser adicionadas após a criação da tabela
    -- podem ser temporariamente desabilitadas

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Listando constraints do usuário
SELECT * FROM USER_CONSTRAINTS;

-- Listando todas as constraints do banco
SELECT * FROM ALL_CONSTRAINTS;

-- Criando a tabela de Cidades
CREATE TABLE tcidade (
    cod_cidade INTEGER NOT NULL,
    nome VARCHAR2(40),
    CONSTRAINT pk_cidade PRIMARY KEY(cod_cidade)
);

-- Criando tabela de Bairros
CREATE TABLE tbairro(
    cod_cidade INTEGER NOT NULL,
    cod_bairro INTEGER NOT NULL,
    nome VARCHAR2(40),
    CONSTRAINT pk_bairro PRIMARY KEY(cod_cidade, cod_bairro)
);

-- Adicionando FK a tabela de bairro (ligando a cidade)
ALTER TABLE tbairro
ADD CONSTRAINT fk_cod_cidade
FOREIGN KEY (cod_cidade) REFERENCES tcidade(cod_cidade);

-- Criando tabela de ruas
CREATE TABLE trua(
    cod_rua INTEGER NOT NULL,
    cod_cidade INTEGER,
    cod_bairro INTEGER,
    nome VARCHAR2(40),
    CONSTRAINT pk_rua PRIMARY KEY(cod_rua)
);

-- Adicionando FK a tabela de rua
ALTER TABLE trua
ADD CONSTRAINT fk_cidade_bairro
FOREIGN KEY (cod_cidade, cod_bairro)
REFERENCES tbairro(cod_cidade, cod_bairro);

-- Criando tabela de pessoas (fornecedores ou clientes)
CREATE TABLE tpessoa (
    cod_pessoa INTEGER NOT NULL,
    tipo VARCHAR2(1) NOT NULL,
    nome VARCHAR2(30) NOT NULL,
    pessoa VARCHAR2(1) NOT NULL,
    cod_rua INTEGER NOT NULL,
    cpf VARCHAR2(15),
    CONSTRAINT pk_pessoa PRIMARY KEY (cod_pessoa)
);

-- Adicionando Unique Key de cpf a tpessoa
ALTER TABLE tpessoa
ADD CONSTRAINT uk_cpf
UNIQUE (cpf);

-- Adicionando FK para trua em tpessoa
ALTER TABLE tpessoa
ADD CONSTRAINT fk_pessoa_rua
FOREIGN KEY (cod_rua)
REFERENCES trua(cod_rua);

-- Adicionando Check de tipo em tpessoa
ALTER TABLE tpessoa
ADD CONSTRAINT ck_pessoa_tipo
CHECK (tipo IN ('C', 'F'));

-- Adicionando Check de pessoa em tpessoa
ALTER TABLE tpessoa
ADD CONSTRAINT ck_pessoa_jf
CHECK (pessoa IN ('J', 'F'));

-- Inserindo cidades
INSERT INTO tcidade VALUES(1, 'Novo Hamburgo');
INSERT INTO tcidade VALUES(2, 'Ivoti');
INSERT INTO tcidade VALUES(3, 'Sapiranga');
INSERT INTO tcidade VALUES(4, 'Taquara');
INSERT INTO tcidade VALUES(5, 'Rio Grande');
COMMIT;

SELECT * FROM TCIDADE;

-- Inserindo Bairros
INSERT INTO tbairro VALUES(1,1,'Centro');
INSERT INTO tbairro VALUES(1,2,'Chulé');

INSERT INTO tbairro VALUES(2,1,'Centro');
INSERT INTO tbairro VALUES(2,2,'Rio Branco');

INSERT INTO tbairro VALUES(3,1,'Centro');
INSERT INTO tbairro VALUES(3,2,'Fritz');

INSERT INTO tbairro VALUES(4,1,'Centro');
INSERT INTO tbairro VALUES(4,2,'Amaral');

INSERT INTO tbairro VALUES(5,1,'Centro');
INSERT INTO tbairro VALUES(5,2,'São João');

COMMIT;

SELECT * FROM tbairro;

SELECT c.nome Cidade, b.nome Bairro
FROM tbairro b
INNER JOIN tcidade c ON c.COD_CIDADE = b.COD_CIDADE;

-- Inserindo ruas
INSERT INTO trua VALUES(1, 1, 1, 'Marcílio Dias');
INSERT INTO trua VALUES(2, 2, 2, 'Fritz e Frida');
INSERT INTO trua VALUES(3, 3, 1, 'Jacobina');
INSERT INTO trua VALUES(4, 4, 2, 'Ferrador');
INSERT INTO trua VALUES(5, 5, 1, 'General Neto');
COMMIT;

SELECT * FROM trua;

SELECT c.nome Cidade, b.nome Bairro, r.nome Rua
FROM trua r
INNER JOIN tbairro b ON r.cod_bairro = b.cod_bairro AND r.COD_CIDADE = b.cod_cidade
INNER JOIN tcidade c ON r.cod_cidade = c.COD_CIDADE;

-- Inserindo pessoas
INSERT INTO tpessoa VALUES(1, 'C', 'Fulano', 'F', 1, '12345678900');
INSERT INTO tpessoa VALUES(2, 'F', 'Beltrano', 'J', 2, '98765432100');
INSERT INTO tpessoa VALUES(3, 'F', 'Ciclano', 'F', 5, '98599097091');
COMMIT;

SELECT * FROM tpessoa;

-- Apagando constraint
-- ALTER TABLE tpessoa DROP CONSTRAINT nome_da_constraint

-- Adicionando check com intervalo de valores em desconto de tcontrato
ALTER TABLE tcontrato
ADD CONSTRAINT ck_tcontrato_desconto
CHECK (desconto BETWEEN 0 AND 30);

-- Desabilitando CONSTRAINT
ALTER TABLE tpessoa
DISABLE CONSTRAINT uk_cpf;

-- Habilitando CONSTRAINT
ALTER TABLE tpessoa
ENABLE CONSTRAINT uk_cpf;

-- Listando CONSTRAINTS de uma tabela
SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TPESSOA';

SELECT constraint_name, column_name
FROM USER_CONS_COLUMNS
WHERE TABLE_NAME = 'TPESSOA';

SELECT object_name, object_type
FROM USER_OBJECTS
WHERE OBJECT_NAME IN ('TPESSOA');

-- Excluindo CONSTRAINTS
ALTER TABLE tcontrato
DROP CONSTRAINT ck_tcontrato_desconto;

SELECT * FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TCONTRATO';
