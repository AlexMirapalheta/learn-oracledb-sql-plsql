-- Seção 04: Funções Básicas

-- Objetivo
    -- descrever os vários tipos de funções disponĩveis em SQL
    -- utilizar funções do tipo caractere, numéricas e de datas em comandos SELECT
    -- descrever o uso de funções de conversão

-- Funções SQL

-- Entrada [ args ] -->  FUNÇÃO --> Saída [ valor resultante ]

-- Tipos
    -- single row
        -- funções que operam em linhas unicas retornando um resultado para cada linha processada
    -- multiple row
        -- funções que manipulam grupos de linhas para obter um resultado para cada grupo processado

-- Single Row
    -- Definições
        -- manipulam itens de dados
        -- recebem argumentos e retornam um valor
        -- atuam sobre cada linha recuperada
        -- retornam um resultado por linha
        -- podem modificar o tipo de um dado
        -- podem ser alinhadas
    -- Sintaxe
        -- function_name (column | expression, [args ...])
    -- Funções de Caracteres
        -- CONCAT   : concatena a primeira string com a segunda
        -- INITCAP  : converte a string deixando a primeira letra em cada palavra maiúscula
        -- INSTR    : retorna a posição numérica do caracter dentro da string
        -- LENGTH   : retorna o número de caracteres da string
        -- LOWER    : converte a string de caracteres para minúsculas
        -- LPAD     : retorna uma string com tamanho total de n alinhada a direita
        -- REPLACE  : substitui uma string por outra
        -- RPAD     : coloca caracteres a direita até completar um tamanho n
        -- SUBSTR   : retornar os caracteres a partir de uma posição inicial m com tamanho n
        -- UPPER    : converte a string de caracteres para maiúsculas
        -- TRIM     : remove espaços em branco do início e final da string
    -- Funções Numéricas
        -- ROUND    : arredonda o número conforme quantidade de casas indicada
        -- TRUNC    : trunca o número conforme quantidade de casas indicada
        -- MOD      : apresenta o resto de uma divisão
    -- Funções de Datas
        -- SYSDATE          : retorna a data e hora do servidor
        -- MONTHS_BETWEEN   : retorna a diferença de meses entre datas
        -- ADD_MONTHS       : retorna a data informada acrescida dos meses indicados
        -- NEXT_DAY         : retorna a data do próximo dia da semana informado. Dias da semana em inglês (completo ou abreviado) ou de 1 a 7
        -- LAST_DAY         : retorna a data do ultimo dia do mês corrente a data informada
        -- ROUND(D,'MONTH') : se a data D for um menor ou igual a 15, retorna o primeiro dia do mês de D, caso contrário o primeiro dia do próximo mês
        -- TRUNC(D,'MONTH') : retorna o primeiro dia do mês de D
    -- Funções de Transformação
        -- TO_CHAR          : utilizado para formatação da apresentação de uma data e hora, numéricos e caractere
    -- Funções Gerais
        -- NVL      : trata valores nulos retornando o valor indicado
        -- NVL2     : verifica se o valor não é nulo, se verdadeiro retorna um valor indicado, senão (é nulo) retornar outro valor indicado (É UM IF)
    -- Funções de Expressão Condicional
        -- CASE     : permite definir o tipo de ação baseado no valor do parâmetro
        -- DECODE   : compara um valor com várias opções e retorna um resultado conforme a primeira correspondência encontrada.

-- Exemplos Práticos
-- Conferindo a estrutura da tabela TALUNO
SELECT * FROM TALUNO;

-- Função CONCAT
SELECT CONCAT(COD_ALUNO, NOME) FROM TALUNO;

-- Função INITCAP
SELECT INITCAP(NOME) FROM TALUNO;
SELECT INITCAP('JOSÉ DA SILVA') FROM DUAL;

-- Função INSTR
SELECT NOME, INSTR(NOME, 'A') FROM TALUNO;

-- Função LENGTH
SELECT NOME, LENGTH(NOME) FROM TALUNO;

-- Função LOWER
SELECT NOME, LOWER(NOME) FROM TALUNO;

-- Função UPPER
SELECT NOME, UPPER(NOME) FROM TALUNO;
SELECT UPPER('josé da silva') FROM DUAL;

-- Função LPAD
SELECT LPAD(COD_ALUNO, 3, 0), NOME FROM TALUNO;

-- Função RPAD
SELECT NOME, RPAD(NOME, 10, '.') FROM TALUNO;

-- Função SUBSTR
SELECT NOME, SUBSTR(NOME, 1, 3) FROM TALUNO;

-- Função REPLACE
SELECT NOME, REPLACE(NOME, 'A', '@') FROM TALUNO;

-- Encadeando Funções
SELECT
    LPAD(LPAD(COD_ALUNO, 3, 0),4,'c'),
    NOME,
    REPLACE(LOWER(NOME), 'a', '@'),
    SUBSTR(NOME, LENGTH(NOME)-2,3),
    SUBSTR(NOME, LENGTH(NOME),1)
FROM TALUNO;

-- Fazendo um update para permitir outros exemplos
UPDATE TALUNO SET SALARIO = 633.47 WHERE COD_ALUNO = 1;
COMMIT;
SELECT * FROM TALUNO;

-- Encadeando Funções para Tratamento da Apresentação do Dado
SELECT
    NOME,
    SALARIO,
    REPLACE(SALARIO, ',', ''),
    RPAD(SALARIO, 10, 0),
    LPAD(SALARIO, 10, 0),
    LPAD(REPLACE(SALARIO, ',',''),10,0)
FROM
    TALUNO;

-- Utilizando Funções nas Condições de Filtragem
SELECT *
FROM TALUNO
WHERE LOWER(NOME) = 'marcio';

SELECT *
FROM TALUNO
WHERE LOWER(SUBSTR(CIDADE, 1, 3)) = 'can';

-- Função TRIM
SELECT TRIM('    JOSÉ DA SILVA    ') FROM DUAL;

--


-- Funções Numéricas: ROUND, TRUNC, MOD
SELECT
    ROUND(45.925, 2),
    TRUNC(45.925, 2),
    TRUNC(1.99),
    MOD(10,2),
    MOD(10,3)
FROM DUAL;

--


-- Funções de Data e Hora

-- No Oracle, o formato de exibição da data NÃO depende da tabela nem do tipo DATE, e sim de 'NLS_DATE_FORMAT da sessão (ou do banco)'
-- Alterando o formato para o padrão esperado no curso
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

-- Função SYSDATE
SELECT SYSDATE FROM DUAL;

-- Ao usar o TRUNC no SYSDATE ele apresenta a hora com 00:00:00
SELECT TRUNC(SYSDATE) FROM DUAL;

-- Operações com Data
SELECT
    DATA,
    SYSDATE,
    DATA + 5 AS DATA_MAIS_5,
    SYSDATE - DATA AS DIF_DIAS,
    TRUNC(SYSDATE - DATA) AS DIAS
FROM TCONTRATO;

-- Operações com Horas
SELECT
    SYSDATE,
    SYSDATE + 5/24 AS SOMANDO_5_HORAS,
    SYSDATE + 5/(24*60) AS SOMANDO_5_MINUTOS,
    SYSDATE + 5/(24*60*60) AS SOMANDO_5_SEGUNDOS
FROM DUAL;

-- Função MONTHS_BETWEEN
SELECT MONTHS_BETWEEN(SYSDATE, SYSDATE - 90) AS DIF_MESES FROM DUAL;

-- Função ADD_MONTHS
SELECT ADD_MONTHS(SYSDATE, 5) AS ADD_MONTHS FROM DUAL;

-- Função NEXT_DAY
SELECT NEXT_DAY(SYSDATE, 'Wednesday') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 'Wed') FROM DUAL;
SELECT NEXT_DAY(SYSDATE, 4) FROM DUAL;

-- Função LAST_DAY
SELECT LAST_DAY(SYSDATE) AS DATA_ULTIMO_DIA_MES FROM DUAL;
SELECT LAST_DAY('17/10/1981') AS DATA_ULTIMO_DIA_MES FROM DUAL;

-- Função ROUND para uma data utilizando MONTH
-- Se a data é até o dia 15 do mês, retorna o primeiro dia do mês da data informada
SELECT ROUND(TO_DATE('15/02/2026'), 'MONTH') FROM DUAL;
-- Se a data é maior do que o dia 15 do mês, retorna o primeiro dia do próximo mês da data informada
SELECT ROUND(TO_DATE('16/02/2026'), 'MONTH') FROM DUAL;

-- Função TRUNC para uma data utilizando MONTH
-- Sempre retorna a data do primeiro dia do mês da data informada
SELECT TRUNC(TO_DATE('15/02/2026'), 'MONTH') FROM DUAL;

--


-- Funções de Transformação

-- Função TO_CHAR para formatação de data
-- Obter apenas o dia da data corrente
SELECT TO_CHAR(SYSDATE, 'DD') FROM DUAL;
-- Obter apenas o número do dia da semana (1-7)
SELECT TO_CHAR(SYSDATE, 'D') FROM DUAL;
-- Obter apenas o dia da semana por extenso
SELECT TO_CHAR(SYSDATE, 'DAY') FROM DUAL;
-- Obter apenas o dia da semana por extenso de forma abreviada
SELECT TO_CHAR(SYSDATE, 'DY') FROM DUAL;

-- Obter apenas o mês da data corrente
SELECT TO_CHAR(SYSDATE, 'MM') FROM DUAL;
-- Obter apenas o mês da data corrente escrito por extenso
SELECT TO_CHAR(SYSDATE, 'Month') FROM DUAL;

-- Obter apenas o ano da data corrente com 2 digitos
SELECT TO_CHAR(SYSDATE, 'YY') FROM DUAL;
-- Obter apenas o ano da data corrente (completo)
SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;
-- Obter apenas o ano da data corrente por extenso
SELECT TO_CHAR(SYSDATE, 'YEAR') FROM DUAL;

-- Obter apenas a data no formato DD/MM/YYYY, sem as horas
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY') FROM DUAL;
-- Obter apenas a data no formato DD/MM/YY, sem as horas
SELECT TO_CHAR(SYSDATE, 'DD/MM/YY') FROM DUAL;
-- Obter apenas a data no formato DD/MM
SELECT TO_CHAR(SYSDATE, 'DD/MM') FROM DUAL;

-- Escrever a data de forma personalizada
SELECT TO_CHAR(SYSDATE, '"Rio Grande," fmDAY"," DD "de" fmMonth"de" YYYY.')
FROM DUAL;

-- Obter apenas Hora
SELECT
    TO_CHAR(SYSDATE, 'HH24:MI') HORA_MINUTO,
    TO_CHAR(SYSDATE, 'HH24:MI:SS') HORA_MINUTO_SEGUNDO
FROM DUAL;

-- Obter Data e Hora
SELECT
    TO_CHAR(SYSDATE, 'DD/MM HH24:MI') DIA_MES_HORA_MINUTO,
    TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS') DATA_HORA,
    TO_CHAR(SYSDATE, 'YYYY-MM-DD"T"HH24:MI:SS.SSSS"Z"') DATA_HORA_UTC,
    TO_CHAR(SYSDATE -3, 'YYYY-MM-DD"T"HH24:MI:SS"-03:00"') "DATA_HORA_UTC_-03:00"
FROM DUAL;

-- Função TO_CHAR para numéricos
    -- L -> R$
    -- G -> ponto
    -- D -> casas decimais
SELECT
    NOME,
    SALARIO,
    TO_CHAR(SALARIO, 'L99999.99'),
    TO_CHAR(SALARIO, 'L99G999D99')
FROM TALUNO;

--


-- Funções Gerais

-- Função NVL
SELECT
    TOTAL,
    DESCONTO,
    DESCONTO + TOTAL,
    NVL(DESCONTO,0),
    NVL(DESCONTO,0) + TOTAL,
    NVL2(DESCONTO, -1, TOTAL)
FROM TCONTRATO;

--


-- Funções de Expressão Condifional

-- Alterando alguns valores em TALUNO para apresenter um exemplo
SELECT * FROM TALUNO;

UPDATE TALUNO
SET ESTADO = 'SC'
WHERE COD_ALUNO = 1;

UPDATE TALUNO
SET ESTADO = 'RJ'
WHERE COD_ALUNO = 5;

UPDATE TALUNO
SET ESTADO = 'AC'
WHERE COD_ALUNO = 25;

COMMIT;

-- Função CASE
SELECT
    COD_ALUNO
    NOME,
    ESTADO,
    CASE
        WHEN ESTADO = 'RS' THEN 'GAUCHO'
        WHEN LOWER(ESTADO) = 'ac' THEN 'ACREANO'
        WHEN ESTADO = 'RJ' THEN 'CARIOCA'
        WHEN ESTADO = 'SP' THEN 'PAULISTA'
        ELSE 'OUTROS || NÃO EXISTE'
    END AS APELIDO
FROM TALUNO
ORDER BY COD_ALUNO;

-- Função DECODE
SELECT
    COD_ALUNO
    NOME,
    ESTADO,
    DECODE(ESTADO,
        'RS', 'GAUCHO',
        'AC', 'ACREANO',
        'RJ', 'CARIOCA',
        'SP', 'PAULISTA',
        'OUTROS'
    ) AS APELIDO
FROM TALUNO
ORDER BY COD_ALUNO;
