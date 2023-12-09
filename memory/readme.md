# Trabalho de Gerador de Imediatos RiscV
 - Aluno: Arthur Mota Furtado
 - Matrícula: 200014935

O projeto foi desenvolvido em VHDL e testado utilizando o software Modelsim, uma parte da suite Quartus Prime.

Este Projeto implementa tanto uma memória de dados (ram) quanto uma memória de instruções (rom). A memória de instruções é inicializada a partir do arquivo `rom.txt`, que foi criado pelo programa python presente em `populate.py`. Rodando este programa, ele automaticamente transforma rom.txt no arquivo com os dados corretos para os testes. Todos os testes implementados fazem uso do assert report, então automaticamente encontram erros e explicitam em que parte da memória o erro ocorreu.