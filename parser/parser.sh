#!/bin/bash

# Inter Field Separator será "enter" --> "0a"
IFS=$'\x0a'

# O 'sed' irá:
## - remover a partir do comentário (#) até o fim da linha;
## - tirar qualquer quantidade de espaços antes e depois do '=';
## - remover as linhas em branco.
for LINE in $(cat $config_file | sed 's/#.*//g;s/ \{1,\}=/=/g;s/= \{1,\}/=/g;/^$/d') 
do
	# pegando a chave da linha
	key=$(echo $LINE | cut -d "=" -f 1)
	# pegando o valor da linha
	value=$(echo $LINE | cut -d "=" -f 2)
	# criando a variável com mesmo nome da chave e atribuindo o valor
	eval $key=\"${value}\"
done
