-- 1. o nome, a matrícula , o cpf e a data de nascimento dos funcionários
SELECT nome, matricula, cpf, dtnascimento
FROM funcionarios
ORDER BY matricula;

-- 2. o nome, a matrícula , o cpf dos funcionários admitidos depois de 01/01/2000.
SELECT nome, matricula, cpf
FROM funcionarios
WHERE admissao &gt; &#39;01/01/2000&#39;
ORDER BY matricula;

-- 3. Matrícula, nome, código da situação e descrição da situação dos funcionários (tabelas
--envolvidas: funcionarios, tipomovtos)
SELECT funcionarios.matricula, funcionarios.nome, funcionarios.tipmov,
tipomovtos.descricao
FROM funcionarios
JOIN tipomovtos
    ON tipomovtos.tipmov = funcionarios.tipmov
ORDER BY funcionarios.matricula;

-- 4. o nome, a matrícula , o cpf dos funcionários ativos (não desligados/exonerados) que
--sejam do sexo feminino.
SELECT nome, matricula, cpf
FROM funcionarios
WHERE vinculo NOT IN (13, 11)
AND sexo = &#39;F&#39;
ORDER BY matricula;

-- 5. o nome e a matrícula dos funcionários bem como o nome do cargo e o nome da função
--a qual os funcionários pertencem (tabelas envolvidas: funcionários, cargos, funções).
SELECT funcionarios.nome, funcionarios.matricula, cargos.descricao as descricao_cargo,
funcoes.descricao as descricao_funcao
FROM funcionarios
JOIN cargos
ON cargos.cargo = funcionarios.cargo
JOIN funcoes
ON funcoes.funcao = funcionarios.funcao
ORDER BY funcionarios.matricula;

-- 6. o nome e a matrícula bem como o nome do cargo e o nome do setor ao qual
--osfuncionários pertencem (tabelas envolvidas: funcionários, cargos, setor).
SELECT funcionarios.nome, funcionarios.matricula, cargos.descricao as descricao_cargo,
setores.descricao as descricao_setor
FROM funcionarios
JOIN cargos
ON cargos.cargo = funcionarios.cargo
JOIN setores
ON setores.setor = funcionarios.setor
ORDER BY funcionarios.matricula;

-- 7. Nome e a matrícula do funcionário e o nome e o período de todas as empresas pelas
--quais ele já trabalhou (aba de averbações. Tabela: empregos)
SELECT funcionarios.nome, funcionarios.matricula, empregos.nomeempresa,
to_char(dtadm, &#39;dd/mm/yyyy&#39;) || &#39; - &#39; || to_char(dtdem, &#39;dd/mm/yyyy&#39;)as periodo
FROM funcionarios
JOIN empregos
ON empregos.codigo = funcionarios.matricula
ORDER BY funcionarios.matricula;

-- 8. Matrícula, nome, o tipo da formação (Se é graduação, pós graduação, mestrado, etc.),
--o nome do curso acadêmico e a data início e data fim.
SELECT funcionarios.matricula, funcionarios.nome, graus.descricao as descricao_curso
FROM funcionarios
JOIN graus
ON graus.grauinst = funcionarios.grauinst
ORDER BY funcionarios.matricula;

-- 9. Pelo sistema, entrar em TABELAS - SETORES e cadastrar em alguns setores, os
--responsáveis por aquele setor. Após isso, adicionar à querie 6 uma coluna
-- (nome do responsável) que será o nome do funcionário responsável por aquele setor.
--(usar tabela setores_responsaveis)
SELECT funcionarios.nome, funcionarios.matricula, cargos.descricao as cargo,
setores.descricao as setor, setores_responsaveis. matricula
FROM funcionarios
JOIN setores_responsaveis
ON setores_responsaveis.matricula = funcionarios.matricula
AND setores_responsaveis.setor = setores.setor
JOIN cargos
ON cargos.cargo = funcionarios.cargo
ORDER BY funcionarios.matricula;