-- Seção 03: restringindo e ordenando dados

-- Objetivos
    -- limitar linhas recuperadas
    -- ordenar as linhas recuperadas

-- Limitando as linhas selecionadas
    -- consulta utilizando a clausula WHERE
    -- SELECT [DISTINCT] {*, column [ALIAS], ...} FROM table [WHERE condiction(s)];
    -- condiction(s)
        -- composta de nomes de coluna, expressões, constantes, operadores de comparação
        -- Strings de caractere e Datas
            -- string de caractere e valores tipo data são inclusos entre aspas simples
            -- valores de caractere são case sensitive
            -- valores de data são sensíveis ao formato
        -- Operadores de comparação
            -- =, >, >=, <. <=, <> ou !=
            -- [WHERE expr operator value]
        -- Outros operadores de comparação
            -- BETWEEN ... AND ...
            -- IN
            -- LIKE
            -- IS NULL

-- Preparando as tabelas para permitir a execução dos exemplos
SELECT * FROM TALUNO;


-- Adicionando a coluna ESTADO na tabela de TALUNO
ALTER TABLE TALUNO
ADD ESTADO CHAR(2)
DEFAULT 'RS';

ALTER TABLE TALUNO
ADD SALARIO NUMBER(8,2)
DEFAULT 620;

UPDATE TALUNO
SET ESTADO='AC', SALARIO='250'
WHERE COD_ALUNO = 1;

UPDATE TALUNO
SET ESTADO='MT', SALARIO='2000'
WHERE COD_ALUNO = 5;

UPDATE TALUNO
SET ESTADO='SP', SALARIO='800'
WHERE COD_ALUNO = 3;

COMMIT;


-- Realizando consulta de todos os alunos
SELECT * FROM TALUNO;


-- Realizando consulta dos alunos com estado != RS, com salário <= 800 e ordenado desc por salário
SELECT *
FROM TALUNO
WHERE ESTADO!='RS'
AND SALARIO<=800
ORDER BY SALARIO DESC;


-- Inserindo novos registros para melhorar os exemplos
INSERT INTO TALUNO (COD_ALUNO, NOME, CIDADE)
VALUES (SEQ_ALUNO.nextval, 'VALDO', 'DOIS IRMÃOS');

INSERT INTO TALUNO (COD_ALUNO, NOME, CIDADE)
VALUES (SEQ_ALUNO.nextval, 'ALDO', 'QUATRO IRMÃOS');

UPDATE TALUNO
SET ESTADO='SP', SALARIO=900, NOME='PEDRO'
WHERE COD_ALUNO=25;

COMMIT;


-- Consultar  estado, salário e nome em TALUNO, ordenado por estado ASC e salário DESC
SELECT ESTADO, SALARIO, NOME FROM TALUNO ORDER BY ESTADO ASC, SALARIO DESC;


-- Consultar  estado, salário e nome em TALUNO, ordenado por estado DESC e salário ASC
SELECT ESTADO, SALARIO, NOME FROM TALUNO ORDER BY ESTADO DESC, SALARIO ASC;


-- Adicionando a coluna NASCIMENTO em TALUNO para permitir novos exemplos
ALTER TABLE TALUNO
ADD NASCIMENTO DATE
DEFAULT SYSDATE - 1000;

SELECT * FROM TALUNO;

-- No Oracle, o formato de exibição da data NÃO depende da tabela nem do tipo DATE, e sim de 'NLS_DATE_FORMAT da sessão (ou do banco)'
-- Alterando o formato para o padrão esperado no curso
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

-- Atualizando as datas de nascimento dos alunos Marcio e Paula
UPDATE TALUNO
SET NASCIMENTO='17/10/81'
WHERE NOME='MARCIO';

UPDATE TALUNO
SET NASCIMENTO='07/02/79'
WHERE NOME='PAULA';

SELECT * FROM TALUNO;


-- Selecionando apenas alunos nascidos em 18/05/2023
-- COMO O CAMPO NASCIMENTO TEM A HORA, É NECESSÁRIO USAR A FUNÇÃO TRUNC
SELECT COD_ALUNO, NOME, NASCIMENTO
FROM TALUNO
WHERE TRUNC(NASCIMENTO)='18/05/23';


-- Selecionando apenas alunos nascidos entre um período de data e hora00
-- Esperado retorno com os registros não alterados após a adição de NASCIMENTO (18/05/2023 18:00:47)
SELECT COD_ALUNO, NOME CIDADE, NASCIMENTO
FROM TALUNO
WHERE NASCIMENTO
BETWEEN TO_DATE('18/05/23 00:00', 'DD/MM/YY HH24:MI')
AND TO_DATE('18/05/23 23:59', 'DD/MM/YY HH24:MI');


-- Consultando alunos nascidos entre um período de data e hora que não tem registros.
-- Esperado nenhum retorno como resposta.
SELECT COD_ALUNO, NOME CIDADE, NASCIMENTO
FROM TALUNO
WHERE NASCIMENTO
BETWEEN TO_DATE('18/05/23 00:00', 'DD/MM/YY HH24:MI')
AND TO_DATE('18/05/23 17:59', 'DD/MM/YY HH24:MI');


-- Selecionando contratos filtrando por total utilizando calculo na clausula de WHERE
SELECT COD_CONTRATO, DATA, TOTAL, DESCONTO, DESCONTO + 1000 AS CALCULO
FROM TCONTRATO
WHERE TOTAL <= DESCONTO + 1000;


-- Atualizando registo em contratos para permitir novos exemplos
UPDATE TCONTRATO
SET DESCONTO = NULL
WHERE COD_CONTRATO = 2;

SELECT * FROM TCONTRATO;


-- Selecionando todos os contratos com desconto null
SELECT *
FROM TCONTRATO
WHERE DESCONTO IS NULL;


-- Selecionando todos os contratos com desconto entre 0 e 10
SELECT *
FROM TCONTRATO
WHERE DESCONTO
BETWEEN 0 AND 10;


-- Selecionando todos os contratos com desconto entre 0 e 10, tratando nulos como zero
SELECT *
FROM TCONTRATO
WHERE NVL(DESCONTO, 0)
BETWEEN 0 AND 10;


-- Utilizando forma similar ao between
SELECT *
FROM TCONTRATO
WHERE DESCONTO >= 0
AND DESCONTO <= 10;


-- Selecionando cursos com códigos 1, 2, 3
SELECT *
FROM TCURSO
WHERE COD_CURSO IN (1, 2, 3);


-- Selecionando cursos com códigos 1, 2, 3 usando equivalente a IN
SELECT *
FROM TCURSO
WHERE COD_CURSO = 1
OR COD_CURSO = 2
OR COD_CURSO = 3;


-- Selecionando cursos que não sejam códigos 1, 2, 3
SELECT *
FROM TCURSO
WHERE COD_CURSO NOT IN (1, 2, 3);


-- Adicionando mais um curso
INSERT INTO TCURSO (COD_CURSO, NOME, VALOR, CARGA_HORARIA)
VALUES (5, 'WINDOWS', 1000, 50);

COMMIT;

SELECT * FROM TCURSO;


-- Selecinando os cursos que NÃO vendidos (cursos não existentes e TITEM)
SELECT *
FROM TCURSO
WHERE COD_CURSO NOT IN (
    SELECT COD_CURSO FROM TITEM
);


-- Selecinando os cursos que vendidos (cursos existentes e TITEM)
SELECT *
FROM TCURSO
WHERE COD_CURSO IN (
    SELECT COD_CURSO FROM TITEM
);


--- Selecionando nomes de alunos que contenham a segunda letra como A (uso do LIKE)
SELECT COD_ALUNO, NOME, CIDADE
FROM TALUNO
WHERE NOME LIKE '_A%';


--- Selecionando nomes de alunos que não contenham a segunda letra como A (uso do LIKE)
SELECT COD_ALUNO, NOME, CIDADE
FROM TALUNO
WHERE NOME NOT LIKE '_A%';


--- Selecionando nomes de cursos que começam com a letra W (uso do LIKE)
SELECT COD_CURSO, NOME
FROM TCURSO
WHERE NOME LIKE 'W%';


--- Selecionando nomes de cursos que contenham a palavra JAVA (uso do LIKE)
SELECT COD_CURSO, NOME
FROM TCURSO
WHERE NOME LIKE '%JAVA%';


--- Selecionando nomes de cursos que terminam com a palavra FACES (uso do LIKE)
SELECT COD_CURSO, NOME
FROM TCURSO
WHERE NOME LIKE '%FACES';


-- Alterando a tabela de cursos para adicionar um pré requisito
ALTER TABLE TCURSO ADD PRE_REQ INTEGER;

UPDATE TCURSO
SET PRE_REQ = 1
WHERE COD_CURSO = 2;

UPDATE TCURSO
SET PRE_REQ = 3
WHERE COD_CURSO = 4;

COMMIT;

SELECT * FROM TCURSO;
SELECT * FROM TCURSO WHERE PRE_REQ IS NULL;
SELECT * FROM TCURSO WHERE PRE_REQ IS NOT NULL;


-- Exemplos de precedência de operadores
-- (), AND, OR
-- No próximo exemplo ele responde com os que tem valor menor que 1000 e carga horária 25 ou com os que tem valor maior que 750
SELECT *
FROM TCURSO
WHERE VALOR > 750
OR VALOR < 1000
AND CARGA_HORARIA = 25;
-- No exemplo a seguir ele filtra os valores e do conjunto resultante responde apenas com os que cumprem o requisito de carga horário
SELECT *
FROM TCURSO
WHERE (VALOR > 750 OR VALOR < 1000)
AND CARGA_HORARIA = 25;
