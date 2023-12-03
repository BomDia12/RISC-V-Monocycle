# Trabalho de Gerador de Imediatos RiscV
 - Aluno: Arthur Mota Furtado
 - Matrícula: 200014935

O projeto foi desenvolvido em VHDL e testado utilizando o software Modelsim, uma parte da suite Quartus Prime.

Este Projeto implementa um banco de registradores com 32 registradores de 32 bits cada. O projeto foi testado com a testbench. Para ter certeza que o registador x0 sempre tenha o valor 0, este registador não faz parte da memória, e sempre retorna zero, então, toda escrita a este registador também é descartada, para evitar erros.