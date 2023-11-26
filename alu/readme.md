# Trabalho de Gerador de Imediatos RiscV
 - Aluno: Arthur Mota Furtado
 - Matrícula: 200014935

O projeto foi desenvolvido em VHDL e testado utilizando o software Modelsim, uma parte da suite Quartus Prime.

Este Projeto implementa a ULA (unidade lógica aritmética) de um processador RISC-V. Essa ULA não implementa operações de multiplicação ou divisão, ou operações em ponto flutuante. Ela sempre recbe 3 parâmetros, opcode, que escolhe a operação a ser realizada, e a e b, que são os dois valores com os quais a instrução será realizada. Sendo que opcode é um `std_logic_vector (3 downto 0)` e a e b são `std_logic_vector (31 downto 0)`. A ULA retorna dois valores, res `std_logic_vector (31 downto 0)`, que simboliza o valor retornado pela operação, e zero `std_logic`, que vale `'1'` se o valor de res for zero.

Para testar a ULA foi criado um testbench que avalia 3 testes para cada instrução implementada, e imprime uma mensagem de erro, epecificando qual foi a área na qual o erro ocorreu, caso alguma instrução não esteja funcionando como esperado.

As fotos da simulação estão presentes na pasta simulation.

## Instruções implementadas

| opcode | instrução | descrição
| ------ | --------- | ---------
| 0000 | add | adiciona `a` a `b`
| 0001 | sub | subtrai `b` de `a`
| 0010 | and | realisa um and bitwise entre `a` e `b`
| 0011 | or  | realisa um or bitwise entre `a` e `b`
| 0100 | xor | realisa um xor bitwise entre `a` e `b`
| 0101 | sll | realisa um shift lógico para a esquerda em `a` `b` bits
| 0110 | srl | realisa um shift lógico para a direita em `a` `b` bits
| 0111 | sra | realisa um shift aritimético para a direita em `a` `b` bits
| 1000 | slt | Caso `a` < `b` retorna 1, caso contrário 0
| 1001 | sltu | Caso `a` < `b` retorna 1, caso contrário 0, sem sinal
| 1010 | sge | Caso `a` >= `b` retorna 1, caso contrário 0
| 1011 | sgeu | Caso `a` >= `b` retorna 1, caso contrário 0, sem sinal
| 1100 | seq | Caso `a` == `b` retorna 1, caso contrário 0
| 1101 | sne | Caso `a` != `b` retorna 1, caso contrário 0

## Perguntaas a serem respondidas
1. Explique, em suas palavras a diferença entre comparações com e sem sinal
    - Como usamos a notação do complemento de dois, ao compararmos dois valores sem sinal, números negativos sempre serão maiores que números positivos, como o valor do bit 31 sempre será `1` para eles. Uma comparação com sinal leva o complemento de dois em conta, então `-1 < 10` retornaria verdadeiro, por exemplo. Um ponto interessante, é que mesmo em uma comparação sem sinal, comparar dois números negativos ou dois números positivos sempre dará certo.
2. Como se poderia detectar overflow nas operações ADD e SUB?
    - Para a soma, se `a` e `b` forem positivos, e o resultado for negativo, ocorreu um overflow, se ambos forem negativos, e o resultado for positivo, também é possível afirmar que ocorreu um overflow. Para a subtração, o mesmo pode ser dito, só que com `-b`.

