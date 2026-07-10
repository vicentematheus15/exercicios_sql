-- 1. o nome, a matrícula , o cpf e a data de nascimento dos funcionários
SELECT nome, 
    matricula, 
    cpf, 
    dtnascimento 
FROM funcionarios
ORDER BY matricula;

-- 2. o nome, a matrícula, o cpf dos funcionários admitidos depois de 01/01/2000    
SELECT nome, 
    matricula, 
    cpf
FROM funcionarios
WHERE admissao > '01/01/2000'
ORDER BY matricula;

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
WHERE tipomovtos.classificacao NOT IN (1, 5, 11, 12)
    AND funcionarios.sexo = 'F'
ORDER BY matricula;
    
-- 5. o nome e a matrícula dos funcionários bem como o nome do cargo e o nome 
-- da função a qual os funcionários pertencem(tabelas envolvidas: 
-- funcionários, cargos, funções).
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    cargos.descricao as descricao_cargo, 
    funcoes.descricao as descricao_funcao
FROM funcionarios
JOIN cargos
    ON cargos.cargo = funcionarios.cargo 
JOIN funcoes
    ON funcoes.funcao = funcionarios.funcao
ORDER BY funcionarios.matricula;

-- 6. o nome e a matrícula bem como o nome do cargo e o nome do setor ao qual 
-- osfuncionários pertencem (tabelas envolvidas: funcionários, cargos, setor).
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    cargos.descricao as descricao_cargo, 
    setores.descricao as descricao_setor
FROM funcionarios
JOIN cargos 
    ON cargos.cargo = funcionarios.cargo
JOIN setores
    ON setores.setor = funcionarios.setor
ORDER BY funcionarios.matricula;

-- 7. Nome e a matrícula do funcionário e o nome e o período de todas as 
-- empresas pelas quais ele já trabalhou (aba de averbações. Tabela: empregos)
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    empregos.nomeempresa,
to_char(dtadm, 'dd/mm/yyyy') || ' - ' || to_char(dtdem, 'dd/mm/yyyy')as periodo
FROM funcionarios
JOIN empregos
    ON empregos.codigo = funcionarios.matricula
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
    setores_responsaveis. matricula,
    responsaveis.nome as responsaveis_setor
FROM funcionarios
JOIN cargos 
    ON cargos.cargo = funcionarios.cargo
JOIN setores
    ON setores.setor = funcionarios.setor
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
    ON funcionarios.matricula = calculos.matricula
JOIN contas
    ON contas.conta = calculos.conta
WHERE funcionarios.matricula = 1
AND calculos.conta = 9002
ORDER BY calculos.referencia;

-- 11. O nome, a matrícula, o nome da conta e o valores recebidos por um 
--funcionário na folha mensal de referência 01/06/2017 (tabelas envolvidas: 
-- funcionários, cálculos, contas e tipofolha)
SELECT funcionarios.nome, 
    funcionarios.matricula, 
    contas.descricao as nome_da_conta, 
    calculos.referencia as mes_referencia, 
    calculos.valor
FROM funcionarios
JOIN calculos
    ON funcionarios.matricula = calculos.matricula
JOIN contas
    ON contas.conta = calculos.conta
WHERE referencia BETWEEN '01/06/2017' AND '30/06/2017'
AND funcionarios.matricula = 1
AND calculos.tipofolha = 1;

-- 12. SQL que retorna quantidade de servidores (funcionários) ;
SELECT COUNT(funcionarios.matricula) as qtd_servidores
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
    ON calculos.matricula = funcionarios.matricula
WHERE funcionarios.matricula = 1
and  calculos.conta = 9002
GROUP BY funcionarios.matricula, 
    funcionarios.nome;
-- como somar somente o valor líquido? no caso sao os que tem calculo.conta = 9002

-- 15. A matrícula, o nome do funcionário e o máximo valor líquido recebido 
-- por aquele funcionário
SELECT funcionarios.matricula,
    funcionarios.nome,
    MAX(calculos.valor) as valor_maximo
FROM funcionarios
JOIN calculos
    ON calculos.matricula = funcionarios.matricula
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

-- 17. Listar a matrícula e o histórico de troca de nome daquela pessoa (data inicio, data fim e
--o nome da época). Tabelas envolvidas: funcionários e movimentacoes
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

    


