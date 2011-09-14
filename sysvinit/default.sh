#! /bin/bash
#
# chkconfig: 345 20 80
# description: Activates/Deactivates a service
#


# Função de erro para facilitar as coisas 
erro(){
	ret_val="${1}"
	logger -s -t "${0}" "${2}"
	[ "${3}" == "crit" ] && exit $ret_val
}

cmd_start=""
cmd_stop=""

process="mysqld"
pidfile="/var/run/mysqld/mysqld.pid"
net="3306/tcp"

# Se a variável $process for atribuida, descobre o pid
# usando o comando "pidof"
[ "${process}" ] && { pid_from_pidof=$(pidof "${process}") && {
		echo pid_from_pidof "${pid_from_pidof}" 
	} || {
		erro 1 "Erro buscando pid pelo nome do processo" crit
	}
}


# Se a variável $pidfile for atribuída, verifica se o
# arquivo existe e descobre o pid pelo conteúdo do arquivo.
[ "${pidfile}" ] &&  { [ -e "${pidfile}" ] && pid_from_file=$(< "${pidfile}") && {
		echo pid_from_file "${pid_from_file}" 
	} || { 
		erro 2 "Erro buscando pid pelo pidfile" crit
	}
}

# Se a variável $net for atribuída, descobre o pid
# usando o comando fuser.
[ "${net}" ] && { pid_from_net=$(fuser "${net}" 2> /dev/null) && {
		echo pid_from_port "${pid_from_net}" 
	} || {
		erro 3 "Erro buscando pid pelo socket" crit
	}
}


#start(){

#}

#stop(){

#}

#case $1 in
#	start)

#	;;
#	stop)

#	;;
#	restart)

#	;;
#	*)
#	echo "Uso: $0 { start | stop | restart }"
#	;;
#esac

exit $ret_val
