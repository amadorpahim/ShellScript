#!/bin/bash
#Amador Pahim
#
#Script para cálculo das datas de início e final do horário de verão brasileiro
#
# REGRAS:
## Início: 3º domingo de outubro
## Fim: 3º domingo de fevereiro
### Exceção: Se 3º Domingo de fevereiro for carnaval, o fim passa para o domingo seguinte.

# Recebe o ano a ser calculado
Ano=$1

# Se ano não for passado, pega ano atual
[ ! -z "$Ano" ] || Ano=$(date +%Y)

echo $Ano | grep '^[0-9]\{1,\}$' > /dev/null || { echo "Ano Inválido" ; exit 2 ; }

# Em anos anteriores a 2008 não havia regra definida
if [ $Ano -lt 2008 ]
	then
		echo "As regras só valem a partir de 2008"
		exit 1
        fi

# Calcula o ano seguinte (fim do horário de verão)
AnoSeguinte=$(($Ano + 1))

#################################################################
### Procura o 3º domingo de outubro
#################################################################

# loop para achar o 1º domingo de outubro 
for cont in {1..7}
do 
# pega o dia da semana
DiaDaSemanaOutubro=$(date -d "10/01/$Ano +$cont day" +%w)

# verifica se dia da semana é domingo. Se for, grava o dia e para o loop.
if [ $DiaDaSemanaOutubro -eq 0 ]
	then
		PrimeiroDomingoOutubro=$(date -d "10/01/$Ano +$cont day" +%m/%d/%Y)
		break		
	fi

done

# Calcula qual o 3º domingo (1º domingo + 14 dias)
TerceiroDomingoOutubro=$(date -d "$PrimeiroDomingoOutubro +14 day" +%d/%m/%Y)

#################################################################
### Procura o 3º domingo de fevereiro
#################################################################

# loop para achar o 1º domingo de fevereiro 
for cont in {1..7}
do
# pega o dia da semana
DiaDaSemanaFevereiro=$(date -d "02/01/$AnoSeguinte +$cont day" +%w)

if [ $DiaDaSemanaFevereiro -eq 0 ]
        then
		# verifica se dia da semana é domingo. Se for, grava o dia e para o loop.
                PrimeiroDomingoFevereiro=$(date -d "02/01/$AnoSeguinte +$cont day" +%m/%d/%Y)
                break
        fi
done

# Calcula qual o 3º domingo (1º domingo + 14 dias)
TerceiroDomingoFevereiro=$(date -d "$PrimeiroDomingoFevereiro +14 day" +%m/%d/%Y)

#################################################################
### Procura o domingo de páscoa
#################################################################
# Algoritmo em http://en.wikipedia.org/wiki/Computus#Meeus.2FJones.2FButcher_Gregorian_algorithm

let 'a = AnoSeguinte % 19'
let 'b = AnoSeguinte / 100'
let 'c = AnoSeguinte % 100'
let 'd = b / 4'
let 'e = b % 4'
let 'f = (b+8) / 25'
let 'g = (b - f + 1) / 3'
let 'h = (19 * a + b - d - g + 15) % 30'
let 'i = c / 4'
let 'j = c % 4'
let 'k = (32 + 2 * e + 2 * i - h - j) % 7'
let 'l = (a + 11 * h + 22 * k) / 451'
let 'mes = (h + k - 7 * l + 114) / 31'
let 'dia = ((h + k - 7 * l + 114) % 31) + 1'

#################################################################
### Cálcula o domingo de carnaval
#################################################################

# Domingo de carnaval é 49 dias antes do domingo de páscoa
DomingoCarnaval=$(date -d "$mes/$dia/$AnoSeguinte -49 day" +%m/%d/%Y)

#################################################################
### Calcula data para fim do horário de verão
#################################################################

# Se 3º domingo de fevereiro for o domingo de carnaval, o fim
# do horário de verão é adiado 7 dias.
if [ $TerceiroDomingoFevereiro == $DomingoCarnaval ]
	then
		Fim=$(date -d "$TerceiroDomingoFevereiro +7 day" +%d/%m/%Y)
	else
		Fim=$(date -d "$TerceiroDomingoFevereiro" +%d/%m/%Y)
fi

# RESULTADO

echo Inicio: $TerceiroDomingoOutubro
echo Fim: $Fim
