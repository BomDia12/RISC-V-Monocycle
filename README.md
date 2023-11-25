# Trabalho de Gerador de Imediatos RiscV
 - Aluno: Arthur Mota Furtado
 - Matrícula: 200014935

O projeto foi desenvolvido em VHDL e testado utilizando o software Modelsim, uma parte da suite Quartus Prime.

Esse projeto implementa o gerador de imediatos síncrono (não necissita de um clock), que com base na instrução recebida (informada no formato std_logic_vector (31 downto 0)) retorna o imediato da instrução (no formato signed (31 downto 0)). Caso o gerador receba um opcode que fuja do padrão estabelecido, ou uma instrução do tipo R, que não tem imediato, retorna como imediato o valor 0.

O Testbench criado testa instruções de todos os tipos, e a extensão dos sinais, caso algo esteja errado, ela retorna uma mensagem de erro explicitando qual instrução falhou. Arbitrariamente, foi escolhido o valor de 10 ns entre cada teste. O tempo para rodar todos os testes é de 100 ns, após esse tempo, os testes são repetidos indefinidamente.

## Questões a serem repondidas
 1. Qual a razão do embaralhamento dos imediatos no RiscV?
    - Os imediatos são embaralhados para que cada número fique em lugares específicos, por exemplo, os bits 19-12 do imediato sempre estão nos bits de 19-12 da instrução. Essa consistência permite uma implementação mais fácil do gerador de imediatos.
 2. Por que alguns imediatos não incluem o bit 0?
    - Ambos os tipos de instrução que não incluem o bit 0 são instruções que alteram o valor do PC (program counter), que indica a instrução a ser executada. E, como todas as instruções tem 4 bytes (32 bits) e o indereço da memória é medido de acordo com os bytes, o PC nunca deve ser ímpar, e, caso o bit 0 for isso aconteceria. Dessa forma esse bit, que seria inutil de se representar na instrução, permitindo até que ocorram mais erros, é substituido por um bit mais significativo.
 3. Os imediatos de operações lógica estendem os sinais?
    - Não, pois essas instruções só aceitam números positivos, afinal, um shift -1 bits para a esquerda pode ser escrito (corretamente) como um shift 1 bit para a direita.
 4. Como é implementada a instrução NOT no RiscV?
    - A instrução not é implementada da seguinte forma: `xor rd, r1, -1`, já que -1 é expandido para `0xffffffff`, e `1 xor x = -x`, essa operação inverte o valor de todos os bits do registrador r1, sendo igual a um not.
