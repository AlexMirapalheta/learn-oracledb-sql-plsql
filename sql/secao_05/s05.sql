-- Seção 05: Exibindo Dados a Partir de Multiplas Tabelas

-- Objetivo
    -- escrever SELECTs utilizando diversos tipos de JOINS
    -- visualizar dados que geralmente não correspondem a condição de JOIN utilizando OUTER JOINS
    -- executar um JOIN de uma tabela com ela mesma (SELF JOIN)

-- Obtendo dados a partir de multiplas tabelas
    -- as vezes precisamos unir campos de uma tabela com campos de outra

-- O que é um JOIN ?
    -- SELECT [table.column ...] FROM table1, table2, ... WHERE table1.column1 = table2.column2;
    -- Utilize um JOIN para consultar dados de mais de uma tabela
    -- Escreva a condição de JOIN dentro do WHERE
    -- Prefixe o nome da coluna com o nome da tabela quando o mesmo nome existir em mais de uma tabela

-- Produto Cartesiano
    -- Um produto cartesiano é formado quando:
        -- uma condição JOIN é omitida
        -- uma condição JOIN é inválida
        -- totas as linhas da primeira tabela são unidas a todas as linhas da segunda
    -- Para evitar um produto cartesiano, sempre inclua uma consição JOIN válida na cláusula WHERE

-- Qualificando Nomes de Colunas Ambíguas
    -- utilize prefixos
    -- aumente a performance utilizando prefixos de tabela
    -- faça distinção de colunas com nomes idênticos em tabelas diferentes utilizando ALIAS

-- Tipos de JOINS
    -- Equi join (relacionamento clássico)
        -- conecta duas ou mais tabelas de acordo com dados que são comuns a elas
    -- Non equi join
        -- procura por relacionamentos que não correspondam a uma condição de igualdade (não tem relação exata, é uma faixa de relação)
    -- Outer join
        -- resulta em dados existentes em uma tabela que não possuem uma condição de igualdade com outra (apresenta dados sem registros de ligação)
        -- pode visualizar as linhas que não correspondem a condição de join
    -- Self join
        -- são relacionados os dados de uma mesma tabela mais de uma vez

-- Exemplos




-- Veridicando as tabelas TALUNO e TCONTRATO
SELECT * FROM TALUNO;
SELECT * FROM TCONTRATO;

-- Selecionando os alunos e seus contratos
-- Exemplo ERRADO (sem WHERE) gerando Produto Cartesiano
SELECT
    TA.COD_ALUNO,
    TA.NOME,
    TC.TOTAL,
    TC.COD_CONTRATO
FROM
    TALUNO TA,
    TCONTRATO TC;

-- Exemplo CORRETO (com WHERE) com critério de união
SELECT
    TALUNO.COD_ALUNO,
    TALUNO.NOME,
    TCONTRATO.TOTAL,
    TCONTRATO.COD_CONTRATO
FROM
    TALUNO,
    TCONTRATO
WHERE
    TALUNO.COD_ALUNO = TCONTRATO.COD_ALUNO;

-- Exemplo ERRADO com coluna ambígua
-- Error at Line: 10, Column: 24
-- SQL Error: ORA-00918: column ambiguously defined
SELECT
    TA.COD_ALUNO,
    TA.NOME,
    TC.TOTAL,
    TC.COD_CONTRATO
FROM
    TALUNO TA,
    TCONTRATO TC
WHERE
    COD_ALUNO = COD_ALUNO;

-- Exemplo utilizando ALIAS
SELECT
    TA.COD_ALUNO,
    TA.NOME,
    TC.TOTAL,
    TC.COD_CONTRATO
FROM
    TALUNO TA,
    TCONTRATO TC
WHERE
    TA.COD_ALUNO = TC.COD_ALUNO
ORDER BY
    TA.NOME ASC;

-- Realizando um SELECT unindo 4 tabelas
-- Verificando o que as tabelas tem em comum
SELECT * FROM TALUNO ORDER BY COD_ALUNO;
SELECT * FROM TCONTRATO;
SELECT * FROM TCURSO;
SELECT * FROM TITEM;
-- Selecionando as 4 tabelas
SELECT
    ALU.COD_ALUNO,
    ALU.NOME,
    CON.COD_CONTRATO,
    CON.DATA,
    CON.TOTAL,
    ITE.COD_CURSO,
    CUR.NOME AS CURSO,
    ITE.VALOR
FROM
    TALUNO ALU,
    TCONTRATO CON,
    TCURSO CUR,
    TITEM ITE
WHERE
    ALU.COD_ALUNO = CON.COD_ALUNO
    AND ITE.COD_CONTRATO = CON.COD_CONTRATO
    AND ITE.COD_CURSO = CUR.COD_CURSO
ORDER BY
    ALU.NOME ASC,
    CON.COD_CONTRATO ASC,
    CON.TOTAL DESC;

-- Inserindo novo ALUNO
INSERT INTO TALUNO VALUES (10, 'ALEX', 'RIO GRANDE', 96213002, 'RS', 1000, '17/10/1981');
COMMIT;

-- Se quiser apresentar todos os alunos, mesmo não tendo contrato ...
-- O uso do (+) [Outer Join Operator] no critério de união vai permitir apresentar também os dados que não atendem o critério
-- Note que o resultado traz todos os registros com contrato e os registros sem contrato, curso e item
-- 0 novo registro "ALEX" apresenta o valor NULL para todos os dados inexistente (assim como PEDRO e VALDO)
SELECT
    ALU.COD_ALUNO,
    ALU.NOME,
    CON.COD_CONTRATO,
    CON.DATA,
    CON.TOTAL,
    ITE.COD_CURSO,
    CUR.NOME AS CURSO,
    ITE.VALOR
FROM
    TALUNO ALU,
    TCONTRATO CON,
    TCURSO CUR,
    TITEM ITE
WHERE
    ALU.COD_ALUNO = CON.COD_ALUNO(+)
    AND ITE.COD_CONTRATO(+) = CON.COD_CONTRATO
    AND ITE.COD_CURSO = CUR.COD_CURSO(+)
ORDER BY
    ALU.NOME ASC,
    CON.COD_CONTRATO ASC,
    CON.TOTAL DESC;

-- OBSERVAÇÃO:
-- Operador de Left/Right Outer Join legado do Oracle
-- Versão equivalente em ANSI JOIN (forma moderna recomendada)
-- FROM
--    TCONTRATO CON
--    RIGHT JOIN TDESCONTO DES
--        ON CON.DESCONTO BETWEEN DES.INFERIOR AND DES.SUPERIOR


-- Criando uma nova tabela (TDESCONTO) e inserindo dados para realizar novos exemplos
CREATE TABLE TDESCONTO(
    CLASSE VARCHAR(1) PRIMARY KEY,
    INFERIOR NUMBER(4,2),
    SUPERIOR NUMBER(4,2)
);

INSERT INTO TDESCONTO VALUES('A', 00, 10);
INSERT INTO TDESCONTO VALUES('B', 11, 15);
INSERT INTO TDESCONTO VALUES('C', 16, 20);
INSERT INTO TDESCONTO VALUES('D', 21, 25);
INSERT INTO TDESCONTO VALUES('E', 26, 30);

SELECT * FROM TDESCONTO;

COMMIT;

-- Relacionando TCONTRATO com TDESCONTO com chave não exata (por faixa de valores)
-- Verificando os valores de desconto em TCONTRATO
SELECT * FROM TCONTRATO;
-- Atualizando TCONTRATO para que todos os registros tenham DESCONTO
UPDATE TCONTRATO
SET DESCONTO = 12
WHERE COD_CONTRATO = 2;

UPDATE TCONTRATO
SET DESCONTO = 29
WHERE COD_CONTRATO = 4;

COMMIT;
-- Selecionando e unindo tabelas com critério de união por faixa de valor
SELECT
    CON.COD_CONTRATO,
    CON.DESCONTO,
    DES.CLASSE,
    DES.INFERIOR,
    DES.SUPERIOR
FROM
    TCONTRATO CON,
    TDESCONTO DES
WHERE
    CON.DESCONTO BETWEEN DES.INFERIOR AND DES.SUPERIOR
ORDER BY CON.COD_CONTRATO;

-- Realizando um SELECT da tabela com ela mesmo
-- Utilizando TCURSO e realizando o Self Join com a coluna PRE_REQ
-- Verificando a tabela
SELECT * FROM TCURSO ORDER BY COD_CURSO;
-- Inserindo novos cursos
INSERT INTO TCURSO VALUES (6, 'LÓGICA', 100, 20, NULL);
INSERT INTO TCURSO VALUES (7, 'PHP', 1000, 100, 6);
-- Atualizando todos os registros aplicando os devidos PRE_REQ
UPDATE TCURSO SET PRE_REQ=6 WHERE COD_CURSO IN (1, 3);
COMMIT;
-- Apresentar os nomes dos cursos e os nomes dos cursos que são pré requisitos
-- Os cursos que não tem pré requisito também devem ser apresentados
SELECT
    TCURSO.COD_CURSO,
    TCURSO.NOME AS CURSO,
    NVL(PRE_REQ.NOME, 'n/a') AS PRE_REQUISITO
FROM
    TCURSO,
    TCURSO PRE_REQ
WHERE
    TCURSO.PRE_REQ = PRE_REQ.COD_CURSO(+);
