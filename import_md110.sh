#!/bin/bash
#
# Script para importar registros de ligações do PABX MD110 e inserir em tabela MySQL
#
 
FTP_HOST=192.168.0.10
FTP_USER=root
FTP_PASS=sysadm
FTP_FILE=cab

MYSQL_HOST=mysql.example.com
MYSQL_USER=root
MYSQL_PASS=senha
MYSQL_DB=db_teste

#AINDA NAO ESTA APAGANDO ARQUIVO APOS DOWNLOAD
echo "Conectando no FTP e baixando arquivo..."
ftp -ivn $FTP_HOST  << FIM > .ftp.log 2> /dev/null
quote USER $FTP_USER
quote PASS $FTP_PASS
bin
get $FTP_FILE
quit
FIM

grep "226 Transfer complete" .ftp.log > /dev/null 2> /dev/null && {


IFS="
"

cont=0
for linha in $(awk '{print substr($0,4,8)":"substr($0,13,5)":"substr($0,19,4)":"substr($0,24,2)":"substr($0,27,5)":"substr($0,34,3)":"substr($0,38,20)":"substr($0,59,10)":"substr($0,70,15)":"substr($0,86,6)":"substr($0,100,2)":"substr($0,103,9)}' $FTP_FILE | sed 's/ //g')
do
	
	eval vetor$cont[0]=$(echo $linha | cut -d ":" -f 1)
	eval vetor$cont[1]=$(echo $linha | cut -d ":" -f 2)
	eval vetor$cont[2]=$(echo $linha | cut -d ":" -f 3)
	eval vetor$cont[3]=$(echo $linha | cut -d ":" -f 4)
	eval vetor$cont[4]=$(echo $linha | cut -d ":" -f 5)
	eval vetor$cont[5]=$(echo $linha | cut -d ":" -f 6)
	eval vetor$cont[6]=$(echo $linha | cut -d ":" -f 7)
	eval vetor$cont[7]=$(echo $linha | cut -d ":" -f 8)
	eval vetor$cont[8]=$(echo $linha | cut -d ":" -f 9)
	eval vetor$cont[9]=$(echo $linha | cut -d ":" -f 10)
	eval vetor$cont[10]=$(echo $linha | cut -d ":" -f 11)
	eval vetor$cont[11]=$(echo $linha | cut -d ":" -f 12)
	

#TIRAR
	echo "Linha $cont"
	eval echo "\	Date/Time:		\${vetor$cont[0]}"
	eval echo "\	Call Duration Time:	\${vetor$cont[1]}"
	eval echo "\	Call Metering Pulses:	\${vetor$cont[2]}"
	eval echo "\	Condition Code:		\${vetor$cont[3]}"
	eval echo "\	Access Code 1:		\${vetor$cont[4]}"
	eval echo "\	Access Code 2/ISDN CBC:	\${vetor$cont[5]}"
	eval echo "\	Dialled Number:		\${vetor$cont[6]}"
	eval echo "\	Calling Number:		\${vetor$cont[7]}"
	eval echo "\	Account Code:		\${vetor$cont[8]}"
	eval echo "\	Authorization Code:	\${vetor$cont[9]}"
	eval echo "\	Queue Time:		\${vetor$cont[10]}"
	eval echo "\	External Line ID:	\${vetor$cont[11]}"
#############	

	comando_sql=$(eval echo "\"insert into tabela (campo1,campo2,campo3,campo4,campo5,campo6,campo7,campo8,campo9,campo10,campo11,campo12) values ('\${vetor$cont[0]}','\${vetor$cont[1]}','\${vetor$cont[2]}','\${vetor$cont[3]}','\${vetor$cont[4]}','\${vetor$cont[5]}','\${vetor$cont[6]}','\${vetor$cont[7]}','\${vetor$cont[8]}','\${vetor$cont[9]}','\${vetor$cont[10]}','\${vetor$cont[11]}')\"")



#TIRAR ECHO QUANDO COMANDO ESTIVER "VALENDO"
	echo ""
	echo "Comando MYSQL:"
	echo ""
	echo mysql -h $MYSQL_HOST -u $MYSQL_USER -p $MYSQL_PASS $MYSQL_DB -e \"$comando_sql\"
############

#TIRAR
	read -p "Aperte ENTER para continuar" enter
##############
let cont++
done	
exit 0
} || {
echo Erro baixando arquivo
}
