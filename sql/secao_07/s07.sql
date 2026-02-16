-- Seção 07: Sub-Consultas

-- Objetivos
    -- Realizar uma consulta em um resultado de uma consulta (uma dentro de outra)
-- Sub-Select
    -- utilizando operadores de comparação
        -- =, >, >=, etc.
    -- utilizando outros operadores de comparação
        -- IN
    -- sub-consulta na cláusula FROM

-- Exemplos

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- verificando o conteúdo das tabelas
SELECT * FROM TCONTRATO;
SELECT * FROM TCURSO ORDER BY COD_CURSO;
SELECT * FROM TALUNO ORDER BY COD_ALUNO;

-- selectionar todos os registros da tabela de contrato onde o total for maior do que o valor do curso
SELECT
    COD_CONTRATO,
    DATA,
    TOTAL
FROM
    TCONTRATO
WHERE
    TOTAL > (
        SELECT
            VALOR
        FROM
            TCURSO
        WHERE
            COD_CURSO = 7
    );
-- nesse formato de sub-consulta utilizando os operadores de comparação, o sub-select só pode retornar 1 valor, caso contrário haverá um erro
-- no sub-select os campos tem que ser os mesmos indicados no WHERE

-- selecionar a soma de todos os itens e apresentar somente aqueles com valor mínimo seja maior ou igual a média dos cursos
SELECT
    COD_CURSO,
    MIN(VALOR),
    SUM(VALOR),
    COUNT(*) AS QTDE
FROM
    TITEM
WHERE
    COD_CURSO > 0
HAVING
    MIN(VALOR) >= (
        SELECT AVG(VALOR)
        FROM TCURSO
    )
GROUP BY
    COD_CURSO
ORDER BY
    COD_CURSO;
-- ESSE EXEMPLO DO CURSO É CONFUSO, EU NÃO ENTENDI O PORQUE DESTE RESULTADO

-- Selecionar todos os cursos que estão na tabela de itens de contrato (vendidos)
SELECT
    COD_CURSO,
    NOME,
    VALOR
FROM
    TCURSO
WHERE
    COD_CURSO IN (
        SELECT
            COD_CURSO
        FROM
            TITEM
    )
ORDER BY
    COD_CURSO;
-- com o operador IN a consulta do sub-select pode conter vário registros

-- Selecionar todos os cursos que NÃO FORAM VENDIDOS
SELECT
    COD_CURSO,
    NOME,
    VALOR
FROM
    TCURSO
WHERE
    COD_CURSO NOT IN (
        SELECT
            COD_CURSO
        FROM
            TITEM
    )
ORDER BY
    COD_CURSO;

-- Sub-consulta na cláusula FROM
SELECT
    ITE.COD_CONTRATO,
    ITE.VALOR,
    ITE.COD_CURSO,
    CUR.COD_CURSO,
    CUR.NOME,
    CUR.VALOR
FROM
    TITEM ITE,
    (
        SELECT COD_CURSO, VALOR, NOME
        FROM TCURSO
        WHERE VALOR > 500
    ) CUR
WHERE CUR.COD_CURSO = ITE.COD_CURSO;
