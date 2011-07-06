#!/bin/bash
# Script conceitual, usado para calcular a melhor combinação de "numero de peças x ganho x montante disponível".
######################################################################################
## INFORME QUANTO DINHEIRO ESTA DISPONIVEL E QUANTAS PECAS VOCE TEM

montante=8.34
numpecas=3

## PARA CADA PECA CRIE UM VETOR ASSOCIATIVO

declare -A peca1
declare -A peca2
declare -A peca3

## PARA CADA PECA DECLARE NOME, PRECO E GANHO. O INDICE SERA CALCULADO.
## LEMBRE DE AJUSTAR OS NOMES DOS VETORES PRA CADA PECA

#PECA A1
peca1[nome]="A1"
peca1[preco]="1.87"
peca1[ganho]="1.234"
peca1[indice]=$(echo "${peca1[preco]}" / "${peca1[ganho]}" | bc -l )

#PECA A2
peca2[nome]="A2"
peca2[preco]="0.44"
peca2[ganho]="0.245"
peca2[indice]=$(echo "${peca2[preco]}" / "${peca2[ganho]}" | bc -l )

#PECA B1
peca3[nome]="B1"
peca3[preco]="0.44"
peca3[ganho]="0.245"
peca3[indice]=$(echo "${peca3[preco]}" / "${peca3[ganho]}" | bc -l )

## DAQUI PARA BAIXO NAO TEM MAIS NADA PRA SER EDITADO
######################################################################################
for i in $(seq $numpecas)
do
array[$i]=$(eval echo \${peca$i[indice]}:\${peca$i[ganho]}:\${peca$i[preco]}:\${peca$i[nome]} | sed "s/^\./0\./g")
done

cont=1
for j in $(echo ${array[*]} | tr " " "\n" | sort -g)
do
arrayOrdenado[$cont]=$j
let cont++
done

> .aux.$$
ganhototal=0

for k in $(seq ${#arrayOrdenado[*]})
do
preco=$(echo ${arrayOrdenado[$k]} | cut -d ":" -f 3)
nome=$(echo ${arrayOrdenado[$k]} | cut -d ":" -f 4)
ganho=$(echo ${arrayOrdenado[$k]} | cut -d ":" -f 2)
teste=$(echo "$preco <= $montante" | bc)
while [ "$teste" -eq "1" ]
do
montante=$(echo "$montante - $preco" | bc -l)
ganhototal=$(echo "$ganhototal + $ganho" | bc )
echo $nome >> .aux.$$
teste=$(echo "$preco <= $montante" | bc)

done
done

echo "Peças:"
cat .aux.$$ | sort | uniq -c | tr -s " "
echo "Ganho Total:"
echo $ganhototal
echo "Restou:"
echo -n 'R$ '
echo $montante | sed "s/^\./0\./g"

rm .aux.$$
