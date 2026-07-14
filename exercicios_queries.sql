-- 1. o nome, a matrícula , o cpf e a data de nascimento dos funcionários
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    funcionarios.cpf, 
    funcionarios.dtnascimento 
FROM funcionarios
ORDER BY funcionarios.matricula;

-- 2. o nome, a matrícula, o cpf dos funcionários admitidos depois de 01/01/2000    
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    funcionarios.cpf
FROM funcionarios
WHERE funcionarios.admissao > '01/01/2000'
ORDER BY funcionarios.matricula;

-- 3. Matrícula, nome, código da situação e descrição da situação dos 
-- funcionários (tabelas envolvidas: funcionarios, tipomovtos)
SELECT funcionarios.matricula, 
    funcionarios.nome, 
    funcionarios.tipmov, 
    tipomovtos.descricao
FROM funcionarios
JOIN tipomovtos 
    ON tipomovtos.tipmov = funcionarios.tipmov
ORDER BY funcionarios.matricula;

-- 4. o nome, a matrícula , o cpf dos funcionários ativos 
-- (não desligados/exonerados) que sejam do sexo feminino.
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    funcionarios.cpf 
FROM funcionarios
JOIN tipomovtos 
    ON tipomovtos.tipmov = funcionarios.tipmov
WHERE tipomovtos.classificacao NOT IN (1, 5, 12)
    AND funcionarios.sexo = 'F'
ORDER BY funcionarios.matricula;
    
-- 5. o nome e a matrícula dos funcionários bem como o nome do cargo e o nome 
-- da função a qual os funcionários pertencem(tabelas envolvidas: 
-- funcionários, cargos, funções).
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    cargos.descricao as descricao_cargo, 
    funcoes.descricao as descricao_funcao
FROM funcionarios
JOIN cargos
    ON cargos.empresa = funcionarios.empresa
    AND cargos.cargo = funcionarios.cargo 
JOIN funcoes
    ON funcoes.empresa = funcionarios.empresa
    AND funcoes.funcao = funcionarios.funcao
ORDER BY funcionarios.matricula;

-- 6. o nome e a matrícula bem como o nome do cargo e o nome do setor ao qual 
-- os funcionários pertencem (tabelas envolvidas: funcionários, cargos, setor).
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    cargos.descricao as descricao_cargo, 
    setores.descricao as descricao_setor
FROM funcionarios
JOIN cargos 
    ON cargos.empresa = funcionarios.empresa    
    AND cargos.cargo = funcionarios.cargo
JOIN setores
    ON setores.empresa = funcionarios.empresa
    AND setores.setor = funcionarios.setor
ORDER BY funcionarios.matricula;

-- 7. Nome e a matrícula do funcionário e o nome e o período de todas as 
-- empresas pelas quais ele já trabalhou (aba de averbações. Tabela: empregos)
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    empregos.nomeempresa as empresa,
to_char(empregos.dtadm, 'dd/mm/yyyy') || ' - ' || to_char(empregos.dtdem, 'dd/mm/yyyy')as periodo
FROM funcionarios
JOIN empregos
    ON empregos.empresa = funcionarios.empresa 
    AND empregos.codigo = funcionarios.matricula
ORDER BY funcionarios.matricula;

-- 8. Matrícula, nome, o tipo da formação (Se é graduação, pós graduação, 
-- mestrado, etc.), o nome do curso acadêmico e a data início e data fim.
SELECT funcionarios.matricula, 
    funcionarios.nome, 
    tipoformacao.descricao as tipo_formacao, 
    cursoacad.descricao as nome_curso, 
    formacao.dtinicio as dtinicio, 
    formacao.dtfim as dtfim
FROM funcionarios
JOIN formacao
    ON formacao.matricula = funcionarios.matricula
JOIN cursoacad
    ON cursoacad.codigo = formacao.cursoacad
JOIN tipoformacao
    ON tipoformacao.codigo = formacao.curso
ORDER BY funcionarios.matricula;

-- 9. Pelo sistema, entrar em TABELAS - SETORES e cadastrar em alguns setores, 
-- os responsáveis por aquele setor. Após isso, adicionar à querie 6 uma coluna 
-- (nome do responsável) que será o nome do funcionário responsável por aquele 
-- setor. (usar tabela setores_responsaveis)
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    cargos.descricao as cargo, 
    setores.descricao as setor, 
    responsaveis.nome as responsavel_setor
FROM funcionarios
JOIN cargos 
    ON cargos.empresa = funcionarios.empresa
    AND cargos.cargo = funcionarios.cargo
JOIN setores
    ON setores.empresa = funcionarios.empresa
    AND setores.setor = funcionarios.setor
JOIN setores_responsaveis
     ON setores_responsaveis.empresa = setores.empresa
     AND setores_responsaveis. setor = setores.setor
JOIN funcionarios responsaveis
    ON responsaveis.empresa = setores_responsaveis.empresa
    AND responsaveis.matricula = setores_responsaveis.matricula
WHERE setores_responsaveis.DTAFIM IS null
OR setores_responsaveis.DTAFIM > TRUNC(sysdate)
ORDER BY funcionarios.matricula;


-- 10. O nome, a matrícula, a referencia e o valor líquido recebido por um 
-- funcionário (tabelas envolvidas: funcionários e cálculos. No sistema, 
-- observar a tela de lançamento de ocorrências fixas).
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    calculos.referencia, 
    calculos.valor
FROM funcionarios
JOIN calculos
    ON calculos.empresa = funcionarios.empresa
    AND calculos.matricula = funcionarios.matricula
JOIN contas
    ON contas.conta = calculos.conta
WHERE funcionarios.matricula = 1
AND calculos.conta = 9002
ORDER BY calculos.referencia;

-- 11. O nome, a matrícula, o nome da conta e o valores recebidos por um 
-- funcionário na folha mensal de referência 01/06/2017 (tabelas envolvidas: 
-- funcionários, cálculos, contas e tipofolha)
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    contas.descricao as nome_da_conta, 
    calculos.referencia as mes_referencia, 
    calculos.valor
FROM funcionarios
JOIN calculos
    ON calculos.empresa = funcionarios.empresa
    AND calculos.matricula = funcionarios.matricula
JOIN contas
    ON contas.conta = calculos.conta
WHERE referencia BETWEEN '01/06/2017' AND '30/06/2017'
AND funcionarios.matricula = 1
AND calculos.tipofolha = 1;

-- 12. SQL que retorna quantidade de servidores (funcionários) ;
SELECT COUNT(DISTINCT funcionarios.cpf) as qtd_servidores
FROM funcionarios;

-- 13. SQL que retorne a quantidade de servidores por vínculo empregatício 
-- (mostrar o código do vínculo, o nome do vínculo e a quantidade de servidores
-- daquele vínculo)
SELECT vinculos.vinculo as cod_vinculo, 
    vinculos.descricao as nome_vinculo,
    COUNT(funcionarios.matricula) as qtd_servidores
FROM funcionarios
JOIN vinculos
    ON vinculos.vinculo = funcionarios.vinculo
GROUP BY vinculos.vinculo, 
    vinculos.descricao
ORDER BY cod_vinculo;

-- 14. A matrícula, o nome do funcionário e a soma do valor líquido recebido 
-- em todas as referências por um funcionário.
SELECT funcionarios.matricula, 
    funcionarios.nome,
    SUM( calculos.valor ) as total
FROM funcionarios
JOIN calculos
    ON calculos.empresa = funcionarios.empresa
    AND calculos.matricula = funcionarios.matricula
WHERE funcionarios.matricula = 1
and  calculos.conta = 9002
GROUP BY funcionarios.matricula, 
    funcionarios.nome;

-- 15. A matrícula, o nome do funcionário e o máximo valor líquido recebido 
-- por aquele funcionário
SELECT funcionarios.matricula,
    funcionarios.nome,
    MAX(calculos.valor) as valor_maximo
FROM funcionarios
JOIN calculos
    ON calculos.empresa = funcionarios.empresa
    AND calculos.matricula = funcionarios.matricula
WHERE funcionarios.matricula = 1
GROUP BY funcionarios.matricula,
    funcionarios.nome;

-- 16. Listar a matrícula, o nome e o histórico de troca de setor daquela pessoa 
-- (data inicio, data fim e o código e nome do setor que ela estava na época).
-- Tabelas envolvidas: funcionários e movimentacoes.
SELECT funcionarios.matricula,
    funcionarios.nome, 
    movimentacoes.dtinicio,
    movimentacoes.dttermino,
    movimentacoes.setor,
    setores.descricao
FROM funcionarios
JOIN movimentacoes
    ON movimentacoes.empresa = funcionarios.empresa
    AND movimentacoes.matricula = funcionarios.matricula
JOIN tipomovtos
    ON tipomovtos.tipmov = movimentacoes.tipmov
JOIN setores
    ON setores.empresa = movimentacoes.empresa
    AND setores.setor = movimentacoes.setor
WHERE tipomovtos.tipmov = 30
AND funcionarios.matricula = 1
ORDER BY movimentacoes.dtinicio DESC;

-- 17. Listar a matrícula e o histórico de troca de nome daquela pessoa 
--(data inicio, data fim e o nome da época). Tabelas envolvidas: 
-- funcionários e movimentacoes
SELECT funcionarios. matricula,
    movimentacoes.obs2 as nome_anterior,
    to_char(dtinicio, 'dd/mm/yyyy') || ' - ' || to_char(dttermino, 'dd/mm/yyyy') as periodo
FROM funcionarios
JOIN movimentacoes
    ON movimentacoes.empresa = funcionarios.empresa
    AND movimentacoes.matricula = funcionarios.matricula
JOIN tipomovtos
    ON tipomovtos.tipmov = movimentacoes.tipmov
WHERE tipomovtos.tipmov = 37
AND funcionarios.matricula = 1
ORDER BY movimentacoes.dtinicio DESC;

-- 18. Listar a matricula e o nome dos funcionários, bem como a data de inicio das férias e a
-- quantidade de dias, de todos os registros de férias gozadas em 2018
SELECT funcionarios.matricula,
    funcionarios.nome,
    ferias.dtgozo as dt_inicio,
    ferias.diasferias
FROM funcionarios
JOIN ferias
    ON ferias.empresa = funcionarios.empresa
    AND ferias.matricula = funcionarios.matricula
WHERE extract(year from ferias.dtgozo) = 2018
ORDER BY funcionarios.matricula;

-- 19. A matricula, o nome, a data de vencimento das férias e a quantidade de 
-- dias gozados naquele aquisitivo
SELECT funcionarios.matricula,
    funcionarios.nome,
    ferias.dtvcto,
    SUM(nvl(ferias.diasferias, 0))as dias_gozados
FROM funcionarios
JOIN ferias
    ON ferias.empresa = funcionarios.empresa
    AND ferias.matricula = funcionarios.matricula
GROUP BY funcionarios.matricula,
    funcionarios.nome,
    ferias.dtvcto
ORDER BY funcionarios.matricula,
    ferias.dtvcto;

-- 20. A matricula, o nome, o ano de vencimento das férias e a quantidade de 
-- dias de saldo remanescente das férias daquele aquisitivo.
SELECT funcionarios.matricula,
    funcionarios.nome,
    to_char(ferias.dtvcto, 'yyyy')as ano_vencimento,
    to_char(ferias.dtvcto_ini, 'dd/mm/yyyy') || ' - ' || to_char(ferias.dtvcto, 'dd/mm/yyyy') as periodo_aquisitivo,
    to_number(30 - (nvl(ferias.diasferias, 0) + nvl(ferias.diasperdidos, 0) + nvl(ferias.diasabono, 0))) as qtd_dias_restantes
FROM funcionarios
JOIN ferias
    ON ferias.empresa = funcionarios.empresa
    AND ferias.matricula = funcionarios.matricula
ORDER BY funcionarios.matricula,
    periodo_aquisitivo
;

SELECT funcionarios.matricula,
    funcionarios.nome,
    ferias.dtvcto_ini,
    ferias.dtvcto,
    concessoes.dias as dias_direito,
    concessoes.dias - SUM((nvl(ferias.diasferias, 0) + nvl(ferias.diasperdidos, 0) + nvl(ferias.diasabono, 0))) as dias_restantes
FROM funcionarios
JOIN ferias
    ON ferias.empresa = funcionarios.empresa
    AND ferias.matricula = funcionarios.matricula
JOIN cargos
    ON cargos.empresa = funcionarios.empresa
    AND cargos.cargo = funcionarios.cargo
JOIN grupofunc
    ON grupofunc.grupo = cargos.grupo
JOIN concessoes
    ON concessoes.concessao = grupofunc.concessao_ferias
GROUP BY funcionarios.matricula,
    funcionarios.nome,
    ferias.dtvcto_ini,
    ferias.dtvcto,
    concessoes.dias
ORDER BY funcionarios.matricula;

    

-- 21. Listar todas as contas, código e descrição, bem como uma flag para dizer se incide ou
-- não para imposto de renda. (tabelas envolvidas: contas, incidencia e containcid)
SELECT contas.conta,
    contas.descricao,
    CASE WHEN 
        min(incidencia.tipoincidencia) = 78
        THEN 'Sim' 
        ELSE 'Não' 
        END as incide_para_IR
FROM contas
JOIN incidencia
    ON incidencia.conta = contas.conta
GROUP BY contas.conta,
    contas.descricao
;

-- 22. Listar o código e o nome de todos operadores que possuem a permissão 
-- (perfil) Folha de Pagamento.
SELECT operadores.operador,
    operadores.nome
FROM operadores
JOIN operadoresperfis
    ON operadoresperfis.operador = operadores.operador
JOIN perfis
    ON perfis.codigo = operadoresperfis.perfil
WHERE perfis.codigo = 18
;
--23. Criar um sql com 7 colunas: Matricula, Nome, Tipo de folha, Referência da 
-- folha, valor bruto recebido, total de descontos e total líquido, de valores de folha
SELECT * FROM
    (
        SELECT
            funcionarios.matricula,
            funcionarios.nome,
            tipofolha.descricao AS tipo_de_folha,
            calculos.referencia,
            calculos.conta,
            calculos.valor
        FROM funcionarios
        JOIN calculos 
            ON calculos.empresa = funcionarios.empresa
            AND calculos.matricula = funcionarios.matricula
        JOIN tipofolha 
            ON tipofolha.tipofolha = calculos.tipofolha
            AND calculos.conta BETWEEN 9000 AND 9002
    ) PIVOT (
        SUM(valor)
        FOR conta
        IN ( 9000 AS total_bruto, 
            9001 AS total_descontos, 
            9002 AS total_liquido )
    )
ORDER BY matricula, referencia;


select * from PERFISPERMISSAO;
select * from permissoes;
select * from operadores;
select * from perfis;
select * from vinculos;








