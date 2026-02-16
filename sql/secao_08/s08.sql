-- Seção 08: Manipulando Dados (DML)

-- Objetivos
    -- descrever cada comando DML
    -- inserir linhas em uma tabala
    -- atualizar linhas de uma tabela
    -- remover linhas de uma tabela
    -- controlar transações

-- DML: Data Manipulation Language / Linguagem de Manipulação de Dados
    -- é executado quando
        -- adiciona linhas em uma tabela --> INSERT
        -- modifica linhas em uma tabela --> UPDATE
        -- remove linhas em uma tabela --> DELETE
    -- uma transação consiste de um conjunto de comandos DML
        -- forma uma unidade lógica de trabalho

-- Comando INSERT
    -- insere uma linha em uma tabela
        -- INSERT INTO [ table ] [ column, ... ] VALUES ( value, ... );

-- Comando UPDATE
    -- atualiza os campos de todas as linhas de uma tabela que satisfazerem a condição
        -- UPDATE [ table ] SET [ column = value, ... ] WHERE [ conditions ];

-- Comando DELETE
    -- remove as linhas de uma tabela que satisfazerem a condição
        -- DELETE FROM [ table ] WHERE [ conditions ];

-- Comando COMMIT
    -- confirma todas as operações da tranação e disponibiliza para consulta de outros usuários
        -- COMMIT;
    -- somente para INSERT, UPDATE e DELETE

-- Comando ROLLBACK
    -- desfaz todas as operações da transação, desde que não tenha sido aplicado o COMMIT
        -- ROLLBACK;
    -- somente para INSERT, UPDATE e DELETE

-- Comando TRUNCATE
    -- realiza o DELETE de todos os dados de uma tabela (não há cláusula WHERE) e não permite ROLLBACK
        -- TRUNCATE TABLE [ table ];
    -- igual a um DELETE sem WHERE seguido de um COMMIT

-- Comando SAVEPOINT
    -- serve para criar um ponto de restauração das tabelas do banco de dados
        -- SAVEPOINT [ savepoint_name ];

-- Comando ROLLBACK TO SAVEPOINT
    -- serve para restaurar as tabelas do banco de dados para os valores definidos no savepoint
        -- ROLLBACK TO SAVEPOINT [ savepoint_name ];

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Verificando a tabela TDESCONTO
SELECT * FROM TDESCONTO;

-- Inserindo valores utilizando variáveis de substituição
-- permite utilizar um prompt para inserção de cada valor
-- na extensão do VSC ele abre uma janela para receber os dados e dar apply
INSERT INTO
    TDESCONTO(CLASSE, INFERIOR, SUPERIOR)
VALUES
    ('&cla', '&inf', '&sup');
-- também permite utilizar com outros comandos
SELECT * FROM TDESCONTO WHERE CLASSE = UPPER('&cla');

-- Atualizando o registro de classe F
UPDATE
    TDESCONTO
SET
    INFERIOR = '&inf',
    SUPERIOR = '&sup'
WHERE
    CLASSE = 'F';

-- Removendo o registro de classe F
DELETE FROM TDESCONTO
WHERE CLASSE = UPPER('&cla');

-- Criando uma nova tabela copiando uma outra
CREATE TABLE TDESCONTO2 AS SELECT * FROM TDESCONTO;

SELECT * FROM TDESCONTO2;

-- confirmar as operações realizadas
COMMIT;

-- Apagando todos os registros da tabela TDESCONTO2
DELETE FROM TDESCONTO2;

-- Desfazendo a remoção dos registros da tabela TDESCONTO2
ROLLBACK;

-- Apagando os dados da tabela TDESCONTO2 utilizando o TRUNCATE
TRUNCATE TABLE TDESCONTO2;

-- Verificando os dados da tabela TDESCONTO
SELECT * FROM TDESCONTO;

-- Criando o ponto de restauração upd_b
SAVEPOINT upd_b;

-- Realizando alterações em TDESCONTO
UPDATE
    TDESCONTO
SET
    SUPERIOR = 88
WHERE
    CLASSE = 'B';

-- Criando o ponto de restauração upd_a
SAVEPOINT upd_a;

-- Realizando alterações em TDESCONTO
UPDATE
    TDESCONTO
SET
    SUPERIOR = 99
WHERE
    CLASSE = 'A';

-- Criando o ponto de restauração ins_ok
SAVEPOINT ins_ok;

-- Inserindo um novo registro
INSERT INTO
    TDESCONTO(CLASSE, INFERIOR, SUPERIOR)
VALUES
    ('&cla', '&inf', '&sup');

-- Verificando os dados da tabela TDESCONTO
SELECT * FROM TDESCONTO;

-- Retornando para o SAVEPOINT ins_ok;
ROLLBACK TO SAVEPOINT ins_ok;

-- Retornando para o SAVEPOINT upd_a;
ROLLBACK TO SAVEPOINT upd_a;

-- Retornando para o SAVEPOINT upd_b;
ROLLBACK TO SAVEPOINT upd_b;

-- Excluindo a tabela TDESCONTO2
DROP TABLE TDESCONTO2;
