/*PREFIXOS DE VARIÁVEIS
    const_ : constantes
    filtro_ : filtros vindos do sistema
    aux_ : variaveis genéricas que seguram valores auxiliares
    acc_ : variaveis que serão incrementadas durante a execução do objeto
    f_ : flags (sim/nao, existe/nao existe)
    r_ : variaveis que recebem o valor de retorno de uma funcao*/
    
    
-- estrutura padrão quando for criar procedure. criar null e depois alterar o conteúdo dela
create or replace procedure pcr_exercicios_vicente (
    in_parametro number
) is
begin
    null;
end;

-- Para chamar ela, mas não executar, abrir segurando o CTRL e clicando
call pcr_exercicios_vicente();

--Ao abrir, o ambiente será PL/SQL, permitindo usar condicionais, loops e ao finalizar, será compilado, atualizando o conteúdo da procedure

/*1 Criar uma variável do tipo 'NUMBER' chamada w_auxiliar.
Iniciar essa variável com o valor 10;
inserir uma linha na tabela xcp_debug com o valor da variável; (é só fazer a chamada
prc_xcp_debug (1,1,w_auxiliar);*/

create or replace procedure pcr_exercicios_vicente 
is
    aux_auxiliar number := 10;
begin
    prc_xcp_debug ('teste_variavel_vicente', $$plsql_line, aux_auxiliar);
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_variavel_vicente';

/*2 (UTILIZANDO A CLÁUSULA LOOP)
Criar uma variável do tipo 'NUMBER' chamada w_auxiliar.
Iniciar essa variável com o valor 10;
Criar um laço de interação para enquanto ela for maior que zero, inserir uma linha na
tabela xcp_debug; (é só fazer a chamada prc_xcp_debug (1,2,w_auxiliar);*/

create or replace procedure pcr_exercicios_vicente is
    aux_auxiliar number := 10;    
begin
    while aux_auxiliar > 0 loop
         prc_xcp_debug('teste_vicente_loop', $$plsql_line, aux_auxiliar);
         aux_auxiliar := aux_auxiliar - 1;
    end loop;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_loop'

/*3 (UTILIZANDO A CLAUSA IF() )
Criar uma variável do tipo 'NUMBER' chamada w_auxiliar.
Iniciar essa variável com o valor 10;
Criar um laço de interação para enquanto ela for maior que zero e for número ímpar,
inserir uma linha na tabela xcp_debug; (é só fazer a chamada prc_xcp_debug
(1,3,w_auxiliar) */

--sem funcao
create or replace procedure pcr_exercicios_vicente is
    aux_auxiliar number := 10;    
begin
    while aux_auxiliar > 0 loop
    if mod(aux_auxiliar, 2) <> 0 then
         prc_xcp_debug('teste_vicente_loop/if', $$plsql_line, aux_auxiliar);
    end if;
         aux_auxiliar := aux_auxiliar - 1;
    end loop;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_loop/if';



--abstraindo a logica da condicional para uma function
create or replace procedure pcr_exercicios_vicente is
    aux_auxiliar number := 10;    
    -- a function fica na parte das declarações de variaveis, antes do begin da procedure
    function retorna_num_impar (
          in_numero number  
    ) return number
    is
    begin
        return case
            when mod(in_numero, 2) <> 0 then 1
            else 0
        end;
    end;
     
begin
    while aux_auxiliar > 0 loop
        if retorna_num_impar(aux_auxiliar) = 1 then
             prc_xcp_debug('teste_vicente_loop/if_funcao', $$plsql_line, aux_auxiliar);
        end if;
    
         aux_auxiliar := aux_auxiliar - 1;
    end loop;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_loop/if_funcao';

/*4 (UTILIZANDO 'INTO' )
Criar uma variável do tipo 'NUMBER' chamada w_auxiliar.
Iniciar essa variável com a quantidade
de funcionários que existem na folha mensal de julho/2019 utilizando 'select into';
inserir uma linha na tabela xcp_debug com o valor da variável; (é só fazer a chamada
prc_xcp_debug (1,4,w_auxiliar);*/

create or replace procedure pcr_exercicios_vicente is
     aux_auxiliar number; 

/*sempre que fizer um select into,  preciso cuidar para padronizar possível erros (null por exemplo, padronizando para 0) é preciso envolver a procedure dentro de outro begin/end e passar 
    "exception when no_data_found then
            aux_auxiliar := 0;"                                                                 */    
begin
    begin
        select count(*)
        into aux_auxiliar
        from funcionarios
        join calculos
            on calculos.empresa = funcionarios.empresa
            and calculos.matricula = funcionarios.matricula
        where 0 = 0
        and calculos.tipofolha = 1
        and calculos.referencia between '01/07/2019' and '31/07/2019';
    exception when no_data_found then
        aux_auxiliar := 0; 
    end;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_into';


/*5 (UTILIZANDO 'CURSOR' )
Declarar um cursor que busque matricula e nome da tabela de funcionarios;
Através de um laço de interação, inserir linha a linha a matricula e o nome do
funcionário na tabela prc_xcp_debug (<nomecursor.matricula>, 5, <nomecursor.nome>)*/
create or replace procedure pcr_exercicios_vicente is    
begin
-- isso é uma declaração implícita de um cursor. ele é essa variável "func", que vai armazenar o resultado da busca que ta sendo feita no banco 
    for func in ( 
        select *
        from funcionarios
        where 0 = 0
        and matricula between 1 and 10
    )loop     --início do loop
        -- então é utilizado um loop para ir gravando cada uma das linhas que a variável "func" armazenou temporariamente, ja que ela percorre todas as linhas do select.
        prc_xcp_debug('teste_vicente_func', $$plsql_line, func.matricula || ' - ' || func.nome);
    end loop;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_func';

/*6 Faça um loop na tabela inteira de funcionários ( apenas com esse select: select
matricula, nome, sexo from funcionarios) e escreva na xcp_debug o nome das pessoas
do sexo feminino*/

-- o exercicio pede para usar apenas aquele select (usando um if func.seco = 'F' no loop), mas é melhor para performance já filtrar com where no select.
/* ficaria assim:
    for func in (
            select matricula, nome, sexo 
            from funcionarios
        )loop
            if func.sexo = 'F' then
                prc_xcp_debug('teste_vicente_loop_nomes_femininos', $$plsql_line, func.nome);
            end if;
        end loop;*/
        
create or replace procedure pcr_exercicios_vicente is
begin
        for func in (
            select matricula, nome, sexo 
            from funcionarios
            where 0 = 0 
            and sexo = 'F'
        )loop
        prc_xcp_debug('teste_vicente_loop_nomes_femininos', $$plsql_line, func.nome);
        end loop;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_loop_nomes_femininos';

/*7 Faça um loop na tabela inteira de funcionarios (apenas assim: select matricula from
funcionarios) e escreva na tabela xcp_debug o nome do conjuge, se houver. Caso não
tenha, escreva: NAO TEM*/

/* nesse foi feito o select pedido no exercício e depois no loop foi feito a ligacao para conseguir pegar o nome dos conjuges

também foi utilizado a funcao listagg(nome, ', '), pois estava retornando mais de um nome para a consulta que so deveria retornar 1, 
entao o listagg coloca os nomes retornados no primeiro parametro em uma string, separados pela vpirgula passada no segundo parametro

alem do tratamento de exceções no final do loop, também foi usado nvl para corrigir o espaço vazio que o listagg estava retornando, assim corrigindo os retornos null para 'nao tem'

foi criada uma varivel para deixar explicado qual era o grau de parentesco referente ao conjuge, para facilitar o entendimento e manutenção futura, 
pois assim evita o trabalho que tive de buscar em todos os relacioanamentos de tabelas, qual qera o grau que eu estava procurando

a outra variavel foi para armazenar o nome do conjuge, quando tinha

foi utilizaado cursor implicito (func) e into para buscar dados em um select de uma tabela, por meio de um loop e armazenar em uma variavel */

create or replace procedure pcr_exercicios_vicente is
      const_grau_parentesco_conjuge constant number := 1;
      aux_nome_conjuge varchar2(256);
begin
        for func in (
            select matricula 
            from funcionarios
        )loop
            begin
                select nvl(listagg(nome, ', '), 'Não tem')
                into aux_nome_conjuge
                from dependentes
                where 0 = 0
                and dependentes.matricula = func.matricula
                and dependentes.grau = const_grau_parentesco_conjuge
                and dependentes.dtafim is null;
            exception when no_data_found then
                aux_nome_conjuge := 'Não tem';
            end;
            
            prc_xcp_debug('teste_vicente_loop_nome_conjuges', $$plsql_line, func.matricula || ' - Conjuge: ' || aux_nome_conjuge);
        end loop;
end;

call pcr_exercicios_vicente();

select *
from xcp_debug
where 0 = 0
and des_usuario = 'teste_vicente_loop_nome_conjuges';
