-- Seção 02: execução de comandos SQL básicos

-- Executar comando SELECT básico
-- SELECT [DISTINCT] {*, column [ALIAS], ...} FROM table;
-- Escrevendo comandos:
    -- não fazem distinção entre maiúsculas e minúsculas
    -- podem estar em mais de uma linha
    -- palavras chave não podem ser abreviadas ou divididas
    -- clausulas normalmente são colocadas em linhas separadas
    -- tabulações e identações são utilizadas para melhorar a legibilidade
-- Padrões de cabeçalhos de colunas:
    -- alinhamento padrão: esquerda para dados tipor caractere e data; direita para dados tipo numérico
    -- exibição padrão do nome da coluna em MAIÚSCULAS
-- Expressões Aritiméticas:
    -- podem ser usadas em cláusulas SELECT, WHERE, GROUP BY, HAVING e ORDER BY
    -- operadores aritméticos: +, -, *, /, %
    -- parênteses podem ser usados para controlar a ordem de avaliação
-- Precedência de operadores:
    -- parênteses
    -- multiplicação e divisão
    -- adição e subtração
-- Definindo um valor nulo
    -- um nulo é um valor indisponível, não atribuido, desconhecido ou não aplicável
    -- Um nulo não é o mesmo que zero ou uma string vazia (ou em branco)
    -- Um nulo é representado por NULL
    -- NULL é um valor especial que pode ser usado em expressões, mas não é igual a nada, nem mesmo a outro NULL
    -- expressões que envolvem NULL geralmente resultam em NULL
-- Definindo um Alias de coluna
    -- altera o cabeçalho de uma coluna
    -- segue imediatamente o nome da coluna, palavra chave AS entre o nome e o alias é opcional
    -- requer aspas duplas se ele possuir espaços ou caracteres especiais
    -- é case sensitive
-- Operador de Concatenação
    -- concatena colunas ou strings
    -- é representado por || (duas barras verticais)
    -- cria uma coluna resultante que é uma expressão caractere
-- String de caracteres literais
    -- é qualque caractere, espressão ou número incluídos na lista da clausula SELECT
    -- valores literais do tipo data e caractere devem ser colocados entre aspas simples
    -- cada string de caractere é exibida uma vez para cada linha retornada
-- Linhas Duplicadas
    -- a exibição padrão lista todas as linhas, incluindo duplicatas
    -- elimine linhas duplicadas utilizando a palavra DISTINCT


-- SELECT simples indicando campos específicos
SELECT COD_ALUNO, NOME, CIDADE
FROM TALUNO;

-- SELECT utilizando ALIAS
SELECT COD_ALUNO AS "Código", NOME AS "Nome do Aluno"
FROM TALUNO;

-- Listar todas as cidades da tabela de Alunos (nesse caso tráz todos os registros e suas cidades)
SELECT CIDADE
FROM TALUNO;

-- Listar todas as cidades da tabela de Alunos sem apresentar duplicatas
SELECT DISTINCT CIDADE
FROM TALUNO;

-- Calcular o valor por hora de cada curso e apresentar listagem ordenada do menor valor hora para o maior
SELECT NOME AS Curso, VALOR, VALOR/CARGA_HORARIA, ROUND(VALOR/CARGA_HORARIA,2) AS Valor_Hora
FROM TCURSO
ORDER BY Valor_Hora;

-- Listar alunos utilizando ALIAS com dados separados por espaço ou contendo carácters especiais
SELECT COD_ALUNO AS "Código", NOME AS "Nome do Aluno"
FROM TALUNO;

-- Listar tudo em contratos
SELECT *
FROM TCONTRATO;

-- Alterar o desconto do contrato 4 para NULL para permitir operações com este tipo
UPDATE TCONTRATO
SET DESCONTO = NULL
WHERE COD_CONTRATO = 4;
COMMIT;

-- Fazer SELECT realizando calculos com coluna NULL. O resultado dos calculos deve ser NULL
SELECT COD_CONTRATO, TOTAL, DESCONTO, TOTAL+DESCONTO
FROM TCONTRATO;

-- Tratamento de dados NULL: função NVL
SELECT COD_CONTRATO, TOTAL, NVL(DESCONTO,0), NVL(TOTAL+DESCONTO, 0) AS "TOTAL MAIS DESCONTO"
FROM TCONTRATO;

-- Concatenação de colunas
SELECT COD_ALUNO || ' - ' || NOME || ' // ' || CIDADE AS Aluno
FROM TALUNO;

-- Tipos de Colunas
    -- INTEGER : 1, 2 --> apelido para NUMBER(38)
    -- NUMBER(5,2): 999,99 --> 5 é o total de algarismo e 2 é a parte decimal (logo a parte inteira é no máximo 3 digitos)
    -- NUMERIC(5,2): é um sinônimo de NUMBER (são iguais)
    -- DATA: campo que expressa data e hora (sempre juntos)
    -- VARCHAR2(10): campo designado para strings
    -- VARCHAR(10): é um sinônimo para VARCHAR2
    -- CHAR(10): campo de caracteres com tamanho fixo: sempre terá 10 de tamanho, preenchendo os campos não informados com vazio.
