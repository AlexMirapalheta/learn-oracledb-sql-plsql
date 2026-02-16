-- Seção 09: Criando e Gerenciando Tabelas

-- Objetivos
    -- descrever os principais objetos do banco de dados
    -- criar tabelas
    -- descrever os tipos de dados que podem ser utilizados na definição de colunas
    -- alterar a definição de tabelas
    -- remover, renomear e truncar tabelas

-- Convenções de nome
    -- começar com letras
    -- possuir de 1 até 30 caracteres
    -- possuir apenas A-Z, a-z, 0-9, _, $ e #
    -- não podem possuir o mesmo nome de outro objeto criado pelo usuário
    -- não utilizar palavras reservadas

-- Comando CREATE TABLE
    -- cria uma tabela
    -- CREATE TABLE [schema.][ table ]( column datatype [DEFAULT expr]);
        -- OPÇÃO DEFAULT
            -- Ex.: "dt_compra DATE DEFAULT SYSDATE, ..."
            -- valores válidos são valores literais, expressões ou funções SQL
            -- valores ilegais são nomes de outras colunas ou pseudocolunas
            -- o tipo de dado da opção default deve corresponder ao tipo de dado da coluna

-- Consultando o dicionário de dados
    -- Visualizar as tabelas criadas pelo usuário
        -- SELECT * FROM user_tables;
    -- Visualizar os tipos de objetos distintos criados pelo usuário
        -- SELECT * FROM user_objects;
    -- Visualizar as tabelas, visões, sinônimos e sequences criadas pelo usuário
        -- SELECT * FROM user_catalog;

-- Tipos de Dados
    -- VARCHAR2(size)
    -- CHAR(size)
    -- NUMBER(p,s)
    -- BINARY_FLOAT     : número de precisão simples com 32 bits e ponto flutuante
    -- BINARY_DOUBLE    : número de precisão simples com 64 bits e ponto flutuante
    -- DATE
    -- LONG             : dados caractere de tamanho variável até 2 GB
    -- CLOB             : dados caractere single byte atpe 4 GB * tamanho bloco de dados
    -- RAW(size)        : dados binários com tamanho especidicado, máximo de 2000
    -- LONG RAW         : dados binários de tamanho variável até 2 GB
    -- BLOB             : dados binários de até 4 GB * tamanho bloco de dados
    -- BFILE            : ponteiro para um arquivo externo

-- Comando ALTER TABLE
    -- modifica uma tabela
        -- Adicionando nova coluna
            -- ALTER TABLE [ table_name ] ADD [ column datatype ]
        -- Modificando uma coluna
            -- ALTER TABLE [ table_name ] MODIFY [ column datatype [ DEFALUT value ] ]
        -- Renomeando uma coluna
            -- ALTER TABLE [ table_name ] RENAME COLUMN [ current_name ] TO [ new_name ]
        -- Excluindo uma coluna
            -- ALTER TABLE [ table_name ] DROP COLUMN [ column_name ]
        -- Renomeaando a tabela
            -- ALTER TABLE [current_table_name ] RENAME TO [new_table_name ];
            -- o curso usa "RENAME [current_table_name ] TO [new_table_name ];", mas não funcionou
        -- Desabilitando uma coluna
            -- ALTER TABLE [table_name] SET UNUSED ([column]);
            -- é como apagar a coluna com desempenho e impacto mínimo, especialmente em tabelas grandes.
            -- ele apenas remove a coluna do dicionário de dados (metadados) e marca a coluna internamente como "inutilizada".
            -- isso é instantâneo, mesmo em tabelas com milhões ou bilhões de linhas.
            -- ao contrário do DROP, ele não reescreve a tabela inteira (removendo fisicamente a coluna), permitindo fazer isso em momento oportuno
        -- Excluindo uma colunas não usadas
            -- ALTER TABLE [ table_name ] DROP UNUSED COLUMNS
            -- remove todas as colunas definidas como UNUSED

-- Comando DROP TABLE
    -- exclui uma tabela
    -- DROP TABLE [schema.][ table ];

-- Comando COMMENT
    -- inserir comentario na tabela
        -- COMMENT ON TABLE [table] IS '[comment]';
    -- visualizar comentários de uma tabela
        -- SELECT * FROM USER_TAB_COMMENTS WHERE TABLE_NAME = '[table_name]';
    -- inserir comentario na coluna
        -- COMMENT ON COLUMN [table].[column] IS '[comment]';
    -- visualizar comentários de uma coluna
        -- SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = '[table_name]';

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Alterando o formato para o padrão esperado no curso
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

-- Criando uma tabela
CREATE TABLE TESTE (
    CODIGO INTEGER NOT NULL PRIMARY KEY,
    DATA DATE DEFAULT SYSDATE
);

-- Verificando criação
SELECT * FROM TESTE;

-- Inserindo um registro
INSERT INTO TESTE (CODIGO)
VALUES (1);

COMMIT;

-- Visualizar as tabelas criadas pelo usuário
SELECT * FROM user_tables;

-- Visualizar todas as tabelas do DB
SELECT * FROM all_tables;

-- Visualizar os tipos de objetos distintos criados pelo usuário
SELECT * FROM user_objects;

-- Visualizar as tabelas, visões, sinônimos e sequences criadas pelo usuário
SELECT * FROM user_catalog;

-- Criar nova tabela a partir de um resultado de um select
CREATE TABLE TCONTRATO_VIP
AS SELECT * FROM TCONTRATO WHERE TOTAL > 500;

SELECT * FROM TCONTRATO_VIP;

-- Adicionando uma coluna a tabela
ALTER TABLE TCONTRATO_VIP
ADD VALOR NUMBER(5,2);

-- Modificando uma coluna
ALTER TABLE TCONTRATO_VIP
MODIFY VALOR NUMBER(8,2);

ALTER TABLE TCONTRATO_VIP
MODIFY VALOR NUMBER(12,2) DEFAULT 0;

-- Renomear uma coluna
ALTER TABLE TCONTRATO_VIP RENAME COLUMN VALOR TO VALOR2;

-- Excluir uma coluna
ALTER TABLE TCONTRATO_VIP DROP COLUMN VALOR2;

-- Excluindo uma tabela
DROP TABLE TCONTRATO_VIP;

-- Validando exclusões
SELECT * FROM user_tables;

-- Renomear uma Tabela
ALTER TABLE TESTE RENAME TO TCONTRATO_TOP;

-- Comentar na tabela
COMMENT ON TABLE TCONTRATO IS 'Informações de contratos';

-- Visualizar os comentários de uma tabela
SELECT * FROM USER_TAB_COMMENTS WHERE TABLE_NAME = 'TCONTRATO';

-- Comentar na coluna
COMMENT ON COLUMN TCONTRATO.COD_CONTRATO IS 'Código de identificação do contrato';

-- Visualizar os comentários de uma coluna
SELECT * FROM USER_COL_COMMENTS WHERE TABLE_NAME = 'TCONTRATO';

-- Desabilitando uma coluna (colocar como unused)
-- Consultando TCONTRATO_TOP
SELECT * FROM TCONTRATO_TOP;
-- Adicionando coluna para exemplo
ALTER TABLE TCONTRATO_TOP ADD TOTAL NUMBER(8,2) DEFAULT 0;
-- Desabilitando TOTAL
ALTER TABLE TCONTRATO_TOP SET UNUSED (TOTAL);

-- Removendo as colunas marcadas como UNUSED
ALTER TABLE TCONTRATO_TOP DROP UNUSED COLUMNS;

-- Excluir todos os registros de uma tabela
TRUNCATE TABLE TCONTRATO_TOP;

-- Excluindo tabelas não utilizadas
DROP TABLE TCONTRATO_TOP;
