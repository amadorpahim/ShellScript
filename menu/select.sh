#!/bin/bash

# O contrutor select exibe o prompt PS3.
PS3="Digite a opção desejada: "

# O menu será montado com os itens da lista informada.
# Cada item do menu receberá um índice antes, que será
# usado para escolha do item.
# O item escolhido será atribuído a variável $ip e
# seu índice para a variável $REPLY
# É possível criar a lista com comandos executados em um subshell,
# usando, por exemplo, a sintaxe:
# select ip in $(cat file.txt)
select ip in 10.10.0.10 10.10.0.11 10.10.0.12 10.10.0.13
do
	# Caso um item inválido seja escolhido, a variável $ip
	# será nula. Os comandos dentro do select serão executados
	# a cada seleção, até encontrar um "break".
	[[ $ip ]] && {
		echo "Você escolheu o IP: $ip (opção $REPLY)"
		break	
	} || {
		echo "Opção $REPLY não existe!"
	}
done
