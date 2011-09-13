#!/bin/bash

# O contrutor select exibe o prompt PS3.
PS3="Digite a opção desejada: "

# O menu será montado com os itens da lista informada.
# Cada item do menu receberá um índice antes, que será
# usado para escolha do item.
# O item escolhido será atribuído a variável $name e
# o índice para a variável $REPLY
select name in $(<lista.txt)
do
	# Caso um item inválido seja escolhido, a variável $name
	# será nula. Os comandos dentro do select serão executados
	# a cada seleção, até encontrar um "break".
	[[ $name ]] && {
		echo "Você escolheu o IP: $name (opção $REPLY)"
		break	
	} || {
		echo "Opção $REPLY não existe!"
	}
done
