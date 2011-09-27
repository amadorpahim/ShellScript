#!/bin/bash 
sleep 1

RECALL="/usr/local/script/recall.sh"
AST="/usr/sbin/asterisk"
LOG_FACILITY="local5.warning"

[ $# -ne 2 ] && {
        logger -p $LOG_FACILITY -t "$0" "ERRO: Você precisa informar os dois numeros envolvidos no hangup."
        exit 1
}


callee1=$1
caller1_full=$($AST -rx "database show recall" | grep -m 1 ": ${callee1}" | tr -s " " | cut -d " " -f 1)
caller1=${caller1_full#*_}

callee2=$2
caller2_full=$($AST -rx "database show recall" | grep -m 1 ": ${callee2}" | tr -s " " | cut -d " " -f 1)
caller2=${caller2_full#*_}

#### TESTAR SE ESTA OCUPADO
#caller_busy=$($AST -rx "core show channels concise" | cut -d "!" -f 3 | fgrep "${caller}" > /dev/null 2>&1 && echo 0 || echo 1 )
#
#[ "${caller_busy}" -eq 0 ] && {
#       echo nao posso ligar agora
#} || {
#       echo ligue agora
#}
#####################################

[ -z "${caller1}" ] && {
        logger -p $LOG_FACILITY -t "$0" "Sem espera para $callee1"
} || {  
        logger -p $LOG_FACILITY -t "$0" "$caller1 quer falar com $callee1"
        $RECALL $caller1 $callee1
        $AST -rx "database del recall ${caller1_full##*/}"
}

[ -z "${caller2}" ] && {
        logger -p $LOG_FACILITY -t "$0" "Sem espera para $callee2"
} || {  
        logger -p $LOG_FACILITY -t "$0" "$caller2 quer falar com $callee2"
        $RECALL $caller2 $callee2
        $AST -rx "database del recall ${caller2_full##*/}"
}
