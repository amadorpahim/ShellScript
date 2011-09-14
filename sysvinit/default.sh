#! /bin/bash
#
# chkconfig: 345 20 80
# description: Activates/Deactivates a service
#

cmd_start="/etc/init.d/mysql start"
cmd_stop="/etc/init.d/mysql stop"

process="mysqld"
pidfile="/var/run/mysqld/mysqld.pid"
net="3306/tcp"


verifica_processo(){

# Se a variável $process for atribuida, descobre o pid
# usando o comando "pidof"
[ "${process}" ] && { pid_from_pidof=$(pidof "${process}") || {
		return 2
	}
}

# Se a variável $pidfile for atribuída, verifica se o
# arquivo existe e descobre o pid pelo conteúdo do arquivo.
[ "${pidfile}" ] &&  { [ -e "${pidfile}" ] && pid_from_file=$(< "${pidfile}") || { 
		return 3
	}
}

# Se a variável $net for atribuída, descobre o pid
# usando o comando fuser.
[ "${net}" ] && { pid_from_net=$(fuser "${net}" 2> /dev/null) || {
		return 4
	}
}
	
# Verifica se dentre os itens informados todos tem mesmo PID.
[ $( {
[ "${pid_from_pidof}" ] && echo "${pid_from_pidof}"
[ "${pid_from_file}" ] && echo "${pid_from_file}"
[ "${pid_from_net}" ] && echo "${pid_from_net/ /}"
} | uniq  | wc -l) -eq 1 ] && return 0 || return 1 

}

status_processo(){

verifica_processo
case $? in
	0)
		echo Processo rodando.
	;;
	1)
		echo Falha ao procurar processo. pid, pidfile ou socket inconsistentes.
	;;
	2)
		echo Processo parado.
	;;
	3)
		echo Erro. Não achei pidfile.
	;;
	4)
		echo Erro. Não achei socket.
	;;
esac

}

stop(){

echo -n "Parando processo..."
while verifica_processo
do 
	echo -n "."
	$cmd_stop
	sleep 1
done	 
status_processo

}

start(){

$cmd_start
status_processo

}

case $1 in
	start)
		start
	;;
	stop)
		stop
	;;
	restart)
		stop
		start
	;;
	*)
	echo "Uso: $0 { start | stop | restart }"
	;;
esac

exit $ret_val
