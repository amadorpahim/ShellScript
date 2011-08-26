#!/bin/bash

## Arquivo com os parametros que serão tratados pelo parser
config_file="parametros.cfg"

## Carregando o parser
source parser.sh

## Agora faça seu script.
## Cada chave do arquivo de parametros é uma variável já inicializada e atribuida
echo O nome é: $nome
echo A porta é: $porta
echo O host é: $host
