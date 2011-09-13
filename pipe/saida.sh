#!/bin/bash
# Para escrever no pipe use:
# echo "string" > contador

pipe="contador" 

[ -p "$pipe" ] || mkfifo "$pipe"

while :
do
	for i in $(< $pipe)
	do
		echo "Escreveram $i no PIPE"
	done
done
