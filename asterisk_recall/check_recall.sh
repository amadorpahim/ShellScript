#!/bin/bash 
sleep 1

RECALL="/root/script/recall.sh"
AST="/usr/sbin/asterisk"
LOG_FACILITY="local5.warning"

[ $# -ne 2 ] && {
	logger -p $LOG_FACILITY -t "$0" "ERRO: Você precisa informar os dois numeros envolvidos no hangup."
	exit 1
}

callee1=$1
caller1=$($AST -rx "database get recall $callee1")

callee2=$2
caller2=$($AST -rx "database get recall $callee2")

#### TESTA SE ESTÁ OCUPADO #########
#caller_busy=$($AST -rx "core show channels concise" | cut -d "!" -f 3 | fgrep "${caller}" > /dev/null 2>&1 && echo 0 || echo 1 )
#
#[ "${caller_busy}" -eq 0 ] && {
#	echo nao posso ligar agora
#} || {
#	echo ligue agora
#}
#####################################

[ "${caller1}" ==  "Database entry not found." ] && {
	logger -p $LOG_FACILITY -t "$0" "Sem espera para $callee1"
} || {
	logger -p $LOG_FACILITY -t "$0" "${caller1#* } quer falar com $callee1"
	$RECALL ${caller1#* } $callee1
	$AST -rx "database del recall $callee1"
}

[ "${caller2}" ==  "Database entry not found." ] && {
        logger -p $LOG_FACILITY -t "$0" "Sem espera para $callee2"
} || {
	logger -p $LOG_FACILITY -t "$0" "${caller2#* } quer falar com $callee2"
	$RECALL ${caller2#* } $callee2
	$AST -rx "database del recall $callee2"
}


