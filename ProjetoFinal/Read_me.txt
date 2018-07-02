Na pasta ProjetoFinal:
  main.lua -> Programa do Love que executa o jogo. É preciso que o Arduino esteja conectado ao computador
              Modificar as linhas 278 e 279 para o caminho da porta na qual o Arduino está conectado
              Pressionar a tecla ENTER para começar o jogo

  Pasta createNotes -> Contém o programa que gera o arquivo de texto que o programa principal lê.
                       Ele escreve as notas desejadas (momento no qual ela chega na base e o tipo de nota) neste arquivo de texto
                       Pressionar as teclas 'a', 's' e 'd' no momento desejado e pressionar a tecla ENTER quando tiver terminado
                       O arquivo notesData3.txt já está preenchido com as notas da música gravada no exemplo

  Pasta testeComunicacaoArduino -> Contem o arquivo falacomserial.ino
                                   O Arduino precisa estar com este programa para funcionar
                                   Se a música for mudada, modificar o tempo inicial mostrado no display de 7 segmentos para o tempo total da nova música
                                   Não será possível testar com a música pois é preciso do shield que contém o leitor de cartão microSD
