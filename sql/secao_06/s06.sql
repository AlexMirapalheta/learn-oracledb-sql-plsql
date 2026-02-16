-- Seção 06: Agregando Dados Utilizando Funções de Grupo

-- Objetivos
    -- identificar as funções de grupo disponíveis
    -- descrever o uso de funções de grupo
    -- agrupar dados utilizando a cláusula GROUP BY
    -- incluir ou excluir linhas agrupadas utilizando a cláusula HAVING

-- O que são funções de grupo
    -- são funções que atuam em conjuntos de linhas para obter resultados por grupo
    -- podem ser na tabela interira ou na tabela dividida em grupos

-- Tipos de funções de grupo
    -- AVG      : valor médio de N, ignorando valores nulos
    -- COUNT    : número de linhas de acordo com expressão de validação
    -- MAX      : valor máximo de acordo com expressão
    -- MIN      : valor mínimo de acordo com expressão
    -- SUM      : soma dos valores de N, ignorando valores nulos

-- Sintaxe Básica
    -- SELECT group_function(column)
    -- FROM table
    -- [ WHERE condictions ]
    -- [ HAVING condictions ]
    -- [ GROUP BY columns ]
    -- [ ORDER BY columns / expression ];

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- No Oracle, o formato de exibição da data NÃO depende da tabela nem do tipo DATE, e sim de 'NLS_DATE_FORMAT da sessão (ou do banco)'
-- Alterando o formato para o padrão esperado no curso
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

-- Realizando uma consulta em TCONTRATO usando as funções de grupo
SELECT
    COUNT(*)                            AS QUANT_REGISTROS,
    AVG(TOTAL)                          AS MEDIA,
    ROUND(AVG(TOTAL),2)                 AS MEDIA_ARREDONDADA,
    TO_CHAR(MAX(TOTAL), 'L99G999D99')   AS MAIOR_CONTRATO,
    TO_CHAR(MIN(TOTAL), 'L99G999D99')   AS MENOR_CONTRATO,
    TO_CHAR(SUM(TOTAL), 'L99G999D99')   AS TOTAL_CONTRATOS,
    MAX(DATA)                           AS CONTRATO_MAIS_NOVO,
    MIN(DATA)                           AS CONTRATO_MAIS_ANTIGO
FROM TCONTRATO;

-- Verificando o próximo código sequencial da tabela TCONTRATO
SELECT
    MAX(COD_CONTRATO) + 1 AS PROXIMO_CODIGO
FROM
    TCONTRATO;

-- Verificando tabelas
SELECT * FROM TALUNO;
SELECT * FROM TCONTRATO;

-- Consultar o total dos contratos por aluno
SELECT
    COD_ALUNO AS ALUNO,
    COUNT(*) AS QTD_CONTRATOS,
    SUM(TOTAL) AS TOTAL_CONTRATOS
FROM
    TCONTRATO
GROUP BY
    COD_ALUNO
ORDER BY
    COD_ALUNO ASC;

-- Consultar o total de contratos por data
SELECT
    TO_CHAR(TRUNC(DATA), 'DD/MM/YYYY') AS DATA_FMT,
    SUM (TOTAL) AS TOTAL,
    AVG (TOTAL) AS MEDIA,
    COUNT(*)    AS QTDE
FROM
    TCONTRATO
GROUP BY
    TRUNC(DATA)
ORDER BY
    TO_CHAR(TRUNC(DATA), 'YYYY/MM/DD') DESC;
-- OBS.:
-- cuidado com o conflito de nome entre a coluna e o alias
-- sempre garanta que o alias não seja igual ao nome da coluna
-- se necessário, inclua o nome da tabela e coluna (ex.: TCONTRATO.DATA)
-- como no retorno do select não existe o campo DATA original, há o DATA_FMT
-- DATA_FMT é um string, portanto a ordenação de string não avalia como data
-- mas sim a cadeia de caracteres, portanto ordenar por DATA_FMT não traz o
-- resultado correto
-- usei o artificio de inverter o string de DATA para assim ordenar corretamente
-- mesmo sendo um string

-- Para o próximo exemplo é necessário realizar 2 uptdate colocando DESCONTO NULL
SELECT * FROM TCONTRATO;

UPDATE TCONTRATO
SET DESCONTO = NULL
WHERE COD_CONTRATO IN (3,5);

COMMIT;

-- Realizaar a contagem de contratos
SELECT
    COUNT(*)
FROM
    TCONTRATO;

-- Realizar a contagem de contratos pela coluna DESCONTO
SELECT
    COUNT(DESCONTO)
FROM
    TCONTRATO;
-- nesse retorno não são contadas as linhas com valor NULL

-- Realizar a contagem com ESTADO na tabela TALUNO
SELECT
    COUNT(ESTADO)
FROM
    TALUNO;
-- retornam 7, mesmo havendo repetidos

-- Realizar a contagem com ESTADO na tabela TALUNO
SELECT
    COUNT(DISTINCT(ESTADO))
FROM
    TALUNO;
-- retornam 5, despresando as repetições

-- Verificando quantos registros tem por estado
SELECT
    ESTADO,
    COUNT(ESTADO)
FROM
    TALUNO
GROUP BY
    ESTADO;

-- Verificando MÉDIAS de DESCONTO em TCONTRATO
SELECT
    SUM(DESCONTO) AS somatorio_descontos,
    COUNT(*) AS total_de_itens,
    COUNT(DESCONTO) AS itens_com_desconto,
    AVG(DESCONTO) AS media_sem_considerar_null,
    ROUND(AVG(NVL(DESCONTO,0)),2) AS media_considerando_null_zero
FROM
    TCONTRATO;

-- Verificando o total de contratos por ESTADO e DATA
SELECT
    ALU.ESTADO,
    TRUNC(CON.DATA) AS data_fmt,
    SUM(CON.TOTAL) AS sum_contr,
    COUNT(*) AS QTDE
FROM
    TALUNO ALU,
    TCONTRATO CON
WHERE
    ALU.COD_ALUNO = CON.COD_ALUNO
GROUP BY
    ALU.ESTADO, TRUNC(CON.DATA)
ORDER BY
    ALU.ESTADO, data_fmt;

-- Realizando filtragem de coluna com função de grupo
-- Uso do HAVING
-- Verificando a média do valor de contratos por aluno e extranindo o que tem valor maior que 500
SELECT
    TC.COD_ALUNO, TA.NOME, AVG(TC.TOTAL) AS MEDIA
FROM
    TCONTRATO TC, TALUNO TA
WHERE
    TA.COD_ALUNO = TC.COD_ALUNO
HAVING
    AVG(TC.TOTAL) > 500
GROUP BY
    TC.COD_ALUNO, TA.NOME
ORDER BY
    TC.COD_ALUNO;

-- Obter a média mais alta por aluno
SELECT
    MAX(AVG(TOTAL))
FROM
    TCONTRATO
GROUP BY
    COD_ALUNO;
-- caso de função aninhada, necessita do GROUP BY sem a citação da coluna ali indicada
-- se colocar a coluna indicada no select falha pois ele já usa implicitamente em MAX(AVG())

-- Soma dos salários por estado
SELECT
    ESTADO,
    SUM(SALARIO) AS TOTAL_SAL
FROM
    TALUNO
GROUP BY
    ESTADO
ORDER BY
    TOTAL_SAL;
